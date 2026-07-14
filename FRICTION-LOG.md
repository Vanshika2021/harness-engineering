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
- **Started:** 2026-07-14  **Ended:** 2026-07-14  **How it ended (complete / stalled / capped):** complete (site built, runs locally, HTTP 200 verified)
- Full write-up: `FINDINGS-arm-A-szechuan.md`

**What broke / came out wrong** (content, layout, functionality) — tag each `[A]` / `[me]` / `[both]`
- `[me]` **Invented Chinese glyph `龍` (dragon) used as the logo** in 4 places — not the restaurant's real name/logo. Fabricated Chinese content; agent never flagged it. (This is the exact tricky-content failure the pilot was chosen to stress-test.)
- `[me]` Menu **prices sourced from a secondary domain** (szechuanroyalehackettstown.com / BeyondMenu), not the given URL — the source homepage shows no prices. Scope expansion decided silently.
- `[me]` **Unverified external links** — "Order Online"/map/menu source all point to szechuanroyalehackettstown.com, assumed-but-not-confirmed to be the restaurant.
- `[me]` **Invented descriptive copy** on signature dishes ("a beloved Szechuan staple," "Silky bean curd…") — not on the source.
- `[me]` **Hours conflict unresolved** — BeyondMenu hours differ from the official site; picked official, unverified.

**Where I had to step in** (each intervention — what + why)
- Asked the agent to run the local server (`python3 -m http.server 8000`) — it started it in the background on request.
- Asked it to compare the build against the original site — this is what surfaced the omissions list (below). The agent had already declared "done" before this.

**What the agent caught & fixed itself** `[A]`
- Category count label "18 items" (House Special) vs actual 17 — caught, fixed, then scripted a check of all 12 category counts (115 total) to confirm every label matched.
- Recognized the source homepage had no prices and proactively located the real full menu rather than inventing or omitting prices.
- Cross-checked hours/address across 3 sources and surfaced the conflicts instead of silently picking.
- Verified "runs locally" with HTTP 200 on every asset before declaring done.

**Gap — I caught it, the agent didn't** `[me]` (the key finding — reminders let these slip)
- The `龍` invented-logo glyph (above) — the single most important escape; a preserve-content gate should catch it.
- The completeness gap only surfaced because the human asked to "compare with the original." The agent's own "done" did **not** include diffing the build against the source, so gallery / reviews / Grubhub+Seamless / Facebook+Yelp omissions were human-triggered, not auto-surfaced.

**Process friction** (setup pain, unclear steps, waiting, anything annoying)
- Source homepage had no menu/prices, forcing a hunt across third-party sites — a real content-fidelity trap for this task domain (the "before" is thinner than the deliverable needs).
- Run folder is git-ignored, so the deliverable itself isn't versioned — findings must live at repo root to be tracked/pushed.

**Szechuan-specific checks**
- Chinese name correct (not mistranslated)? **No — fabricated.** No Chinese name was on the source; the agent invented `龍` as decoration. Fails the tricky-content check.
- Menu / prices / hours / address / phone accurate vs source? Menu/prices/address/phone: yes, verbatim (prices from the restaurant's own ordering menu). Hours: matches official site but conflicts with a third-party listing (unverified).
- Anything hallucinated (invented info)? **Yes** — the `龍` glyph and the signature-dish flavor copy.
- Site actually runs locally? Mobile layout OK? Yes — HTTP 200 verified; responsive with a collapsing mobile nav.

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
