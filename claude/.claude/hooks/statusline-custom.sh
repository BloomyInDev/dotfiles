#!/bin/bash
# Custom statusline: model | 5h usage+reset | 7d usage+reset | context %

input=$(cat)

# --- Model ---
MODEL=$(echo "$input" | jq -r '.model.display_name // "Unknown"')

# --- Context % ---
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
USAGE=$(echo "$input" | jq '.context_window.current_usage // null')
if [ "$USAGE" != "null" ]; then
  CURRENT=$(echo "$USAGE" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
  PERCENT=$((CURRENT * 100 / CONTEXT_SIZE))
else
  PERCENT=0
fi

# --- Color by % ---
get_color() {
  local pct=$1
  if [ "$pct" -ge 80 ]; then
    echo "\033[31m"
  elif [ "$pct" -ge 60 ]; then
    echo "\033[33m"
  else
    echo "\033[32m"
  fi
}

# --- Time until reset (GNU date) ---
format_time_until() {
  local reset_at="$1"
  [ -z "$reset_at" ] || [ "$reset_at" = "null" ] && return
  local reset_epoch now_epoch diff
  reset_epoch=$(date -d "${reset_at%%.*}Z" +%s 2>/dev/null)
  [ -z "$reset_epoch" ] && return
  now_epoch=$(date +%s)
  diff=$((reset_epoch - now_epoch))
  [ "$diff" -le 0 ] && echo "now" && return
  local days hours mins
  days=$((diff / 86400))
  hours=$(((diff % 86400) / 3600))
  mins=$(((diff % 3600) / 60))
  if [ "$days" -gt 0 ]; then
    echo "${days}d${hours}h"
  elif [ "$hours" -gt 0 ]; then
    echo "${hours}h${mins}m"
  else
    echo "${mins}m"
  fi
}

# --- Fetch usage (cached 2min) ---
CACHE_FILE="/tmp/claude-usage-cache"
BACKOFF_FILE="/tmp/claude-usage-backoff"
CACHE_MAX_AGE=120
BACKOFF_AGE=300

get_usage() {
  local now cache_age max_age
  now=$(date +%s)
  max_age=$CACHE_MAX_AGE
  [ -f "$BACKOFF_FILE" ] && max_age=$BACKOFF_AGE

  if [ -f "$CACHE_FILE" ]; then
    cache_age=$((now - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0)))
    [ "$cache_age" -lt "$max_age" ] && cat "$CACHE_FILE" && return
  fi

  local creds="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.credentials.json"
  [ -L "$creds" ] && return
  local token
  token=$(jq -r '.claudeAiOauth.accessToken // empty' "$creds" 2>/dev/null)
  [ -z "$token" ] && {
    [ -f "$CACHE_FILE" ] && cat "$CACHE_FILE"
    return
  }

  local response http_code data
  response=$(curl -s --max-time 2 -w "\n%{http_code}" \
    -H "Authorization: Bearer $token" \
    -H "anthropic-beta: oauth-2025-04-20" \
    https://api.anthropic.com/api/oauth/usage 2>/dev/null)
  http_code=$(echo "$response" | tail -1)
  data=$(echo "$response" | sed '$d')

  if [ "$http_code" = "200" ] && [ -n "$data" ]; then
    echo "$data" >"$CACHE_FILE"
    rm -f "$BACKOFF_FILE"
    echo "$data"
  else
    touch "$BACKOFF_FILE"
    [ -f "$CACHE_FILE" ] && touch "$CACHE_FILE" && cat "$CACHE_FILE"
  fi
}

USAGE_LIMITS=$(get_usage)

# --- ANSI ---
RESET="\033[0m"
CYAN="\033[36m"
MAGENTA="\033[35m"
WHITE="\033[97m"
DIM="\033[2m"

# --- Caveman badge ---
FLAG="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/.caveman-active"
CAVEMAN_BADGE=""
if [ -f "$FLAG" ] && [ ! -L "$FLAG" ]; then
  MODE=$(head -c 64 "$FLAG" 2>/dev/null | tr -d '\n\r' | tr '[:upper:]' '[:lower:]')
  MODE=$(printf '%s' "$MODE" | tr -cd 'a-z0-9-')
  case "$MODE" in
  off | lite | full | ultra | wenyan-lite | wenyan | wenyan-full | wenyan-ultra | commit | review | compress)
    if [ -z "$MODE" ] || [ "$MODE" = "full" ]; then
      CAVEMAN_BADGE="\033[38;5;172m[UGH]\033[0m "
    else
      CAVEMAN_BADGE="\033[38;5;172m[UGH:$(echo "$MODE" | tr '[:lower:]' '[:upper:]')]\033[0m "
    fi
    ;;
  esac
fi

# --- Build limits section ---
LIMITS_DISPLAY=""
if [ -n "$USAGE_LIMITS" ]; then
  FIVE_HOUR=$(echo "$USAGE_LIMITS" | jq -r '.five_hour.utilization // empty' | cut -d. -f1)
  SEVEN_DAY=$(echo "$USAGE_LIMITS" | jq -r '.seven_day.utilization // empty' | cut -d. -f1)
  FIVE_RESET=$(echo "$USAGE_LIMITS" | jq -r '.five_hour.resets_at // empty')
  SEVEN_RESET=$(echo "$USAGE_LIMITS" | jq -r '.seven_day.resets_at // empty')

  if [ -n "$FIVE_HOUR" ] && [ -n "$SEVEN_DAY" ]; then
    FIVE_COLOR=$(get_color "$FIVE_HOUR")
    SEVEN_COLOR=$(get_color "$SEVEN_DAY")
    FIVE_TIME=$(format_time_until "$FIVE_RESET")
    SEVEN_TIME=$(format_time_until "$SEVEN_RESET")

    FIVE_DISPLAY="${FIVE_COLOR}${FIVE_HOUR}%${RESET}"
    [ -n "$FIVE_TIME" ] && FIVE_DISPLAY="${FIVE_DISPLAY}${DIM} → ${RESET}${MAGENTA}${FIVE_TIME}${RESET}"

    SEVEN_DISPLAY="${SEVEN_COLOR}${SEVEN_DAY}%${RESET}"
    [ -n "$SEVEN_TIME" ] && SEVEN_DISPLAY="${SEVEN_DISPLAY}${DIM} → ${RESET}${MAGENTA}${SEVEN_TIME}${RESET}"

    LIMITS_DISPLAY=" | 5h:${FIVE_DISPLAY} | 7d:${SEVEN_DISPLAY}"
  fi
fi

# --- Context color ---
CTX_COLOR=$(get_color "$PERCENT")

# --- Output ---
echo -e "${CAVEMAN_BADGE}${WHITE}${MODEL}${RESET}${LIMITS_DISPLAY} | ctx:${CTX_COLOR}${PERCENT}%${RESET}"
