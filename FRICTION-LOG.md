# Friction log — exploratory runs

Purpose: these first runs are **not scored** (per Bo). The goal is to surface the list of things to improve before scaling up. Jot anything that breaks, anything you had to step in for, and anything about the *process* that was clunky. Rough notes are fine — messy observations are the whole point.

How to fill this: type notes as you watch the run, and/or ask the run's own agent to append its problems/fixes here, and/or paste observations into the chat and have them collected here. (An agent's self-report misses errors it didn't notice — so trust your own eyes for correctness bugs.)

**Mark every observation with who caught it** — this provenance is itself a finding:
- `[A]` — the agent reported it (from its own notes)
- `[me]` — I caught it (the agent didn't flag it)
- `[both]` — both noticed it

The `[me]`-only items are the important ones: they're what a reminder-style setup lets slip and a real harness would need to catch.

---

## Run: Arm A — baseline (plain Claude Code)

- **Folder:** runs/szechuan-A-1
- **Started:** ___  **Ended:** ___  **How it ended (complete / stalled / capped):** ___

**What broke / came out wrong** (content, layout, functionality) — tag each `[A]` / `[me]` / `[both]`
-

**Where I had to step in** (each intervention — what + why)
-

**What the agent caught & fixed itself** `[A]`
-

**Gap — I caught it, the agent didn't** `[me]` (the key finding — reminders let these slip)
-

**Process friction** (setup pain, unclear steps, waiting, anything annoying)
-

**Szechuan-specific checks**
- Chinese name correct (not mistranslated)?
- Menu / prices / hours / address / phone accurate vs source?
- Anything hallucinated (invented info)?
- Site actually runs locally? Mobile layout OK?

---

## Run: Arm B1 — GSD Core

- **Folder:** runs/szechuan-B1-1
- **Started:** ___  **Ended:** ___  **How it ended (complete / stalled / capped):** ___

**What broke / came out wrong** — tag each `[A]` / `[me]` / `[both]`
-

**Where I had to step in**
-

**What the agent / harness caught & fixed itself** `[A]`
-

**Gap — I caught it, the harness didn't** `[me]`
-

**Process friction** (GSD setup questions, extra steps, overhead vs baseline)
-

**Szechuan-specific checks**
- Chinese name correct?
- Menu / prices / hours / address / phone accurate?
- Anything hallucinated?
- Runs locally? Mobile OK?

---

## Cross-run takeaways (fill after both) → bring to Bo

- Biggest recurring failure modes (candidates for real harness gates):
-
- Where GSD clearly helped vs. where it added overhead:
-
- Process fixes needed before a clean scored comparison:
-
- Open questions for Bo:
-
