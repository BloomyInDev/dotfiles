---
name: plan-runner
description: >
  Run a plan in a subagent, then review that work in a second, independent
  subagent, looping until the reviewer is clean. Use whenever the user says
  "run the plan", "run this plan", "implement then review", or "build and
  review".
---

Loop: builder implements, reviewer checks, repeat until the reviewer finds
nothing. The main thread only orchestrates and reports back.

1. **Build.** Spawn a general coding agent. Give it the full plan text
   verbatim (it has no conversation context), the repo path, and any test or
   lint command. Tell it to implement only what the plan says and to report the
   files it changed. No commits unless the user asked for one.

2. **Review.** Spawn a separate agent. Give it the plan and the list of changed
   files, but not the builder's reasoning. Ask it to read the diff and report
   correctness bugs, missed plan items, and scope creep, one line each, or to
   say plainly that it found nothing.

3. **Loop.** Send the findings to the builder that did the work, continuing its
   existing session instead of starting a new agent, so it keeps what it already
   learned. Then spawn a fresh reviewer. Repeat until a review comes back clean
   or the user stops you. Show the user each round's findings, since they never
   see subagent reports.

The reviewer must never inherit the main thread's context. A review is only
worth something if it starts cold.

In Claude Code: builders and reviewers are `general-purpose` agents, you
continue a builder with `SendMessage` to its ID, and the reviewer must not be
spawned with `subagent_type: "fork"`, which would inherit context.
