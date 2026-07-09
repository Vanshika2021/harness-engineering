# Per-run scoring sheet

Copy this sheet once per run. Fill **Part 1** during the run, **Part 2** right after it ends (while details are fresh), then copy the **summary line** into §9 of `EXPERIMENT.md`.

Two kinds of fields:
- **Measured** = read it off, no judgment (times, counts, pass/fail). Can't be biased.
- **Judged** = your 1–5 scores, compared against Bo's reference. Do these **blind** (see below).

---

## Blind-grading step (do this before Part 2)

1. When the build finishes, save the site in a folder named by **Run ID only** (e.g. `R004/`) — no "harness" / "baseline" in the name.
2. Score the website in front of you on its own merits vs Bo's reference, **without looking at which arm produced it.** (Easiest: score a few runs' outputs in shuffled order, arm labels hidden.)
3. Only *after* you've written the 1–5 scores, look up which arm it was and record it.

Why: if you know it's the "harness" version, you'll unconsciously score it higher. Hiding the label keeps you judging the *website*, not the *method*. Only the judged 1–5 scores need this — measured numbers can't be biased.

---

## Part 1 — measured (during / right after the run)

- Run ID:
- Site:
- Arm / method:  A  /  B1  /  B2
- Trial #:
- Date:
- Model: `claude-opus-4-8 [1m]`
- How it ended (§5):  complete  /  stalled  /  capped
- Wall-clock time:
- Agent turns (tool calls):
- Human interventions (count):
- Builds & lints clean:  pass  /  fail
- Test coverage:  ____%  (or "none")

## Part 2 — judged, 1–5, vs Bo's reference (do blind)

**Output quality**
- Design quality (modern / on par with reference): __/5
- Content fidelity (menu, prices, hours, address correct): __/5
- Tricky-content correctness (name translation right, nothing invented): __/5
- Functionality (runs, links work, mobile-responsive): __/5

**Code quality**
- Code organization / readability: __/5

**Self-correction**
- Bugs the agent caught & fixed itself (count): __
- Bugs that escaped to you (count): __
- Recovery quality (diagnosed & fixed vs spun / got stuck): __/5

**Notes** (what broke, what it fixed, standout moments for the blog):


## Summary line → paste into §9 of EXPERIMENT.md

```
| R0xx | <site> | <arm> | <trial> | opus-4-8 [1m] | <time> | <turns> | <interventions> | <self-caught> | <escaped> | <design> | <content> | <correctness> | <function> | <coverage> | <short note> |
```

---

## Worked example (what a filled-in sheet looks like)

**Part 1 — measured**
- Run ID: R004
- Site: Szechuan Royale
- Arm / method: **B1** (GSD Core)
- Trial #: 1
- Date: 2026-07-08
- Model: `claude-opus-4-8 [1m]`
- How it ended: **complete**
- Wall-clock time: 31 min
- Agent turns: 44
- Human interventions: 1 *(had to tell it which local port the dev server was on)*
- Builds & lints clean: **pass**
- Test coverage: 62%

**Part 2 — judged (scored blind, arm revealed after)**
- Design quality: **4/5** — clean and modern; hero section a bit generic next to the reference's photography
- Content fidelity: **5/5** — menu items, prices, hours, address all matched the source
- Tricky-content correctness: **5/5** — kept "Szechuan Royale" correct; the earlier known mistranslation did not recur
- Functionality: **4/5** — all links work; mobile nav slightly cramped
- Code organization: **4/5**
- Bugs self-caught: **3** — verify step found a broken menu image path + 2 failing tests, fixed all three
- Bugs escaped: **1** — mobile menu overlap I spotted, it didn't
- Recovery quality: **5/5** — diagnosed the failing tests and fixed them with no help
- Notes: GSD's verify step caught the broken menu image *before* declaring done — good "harness earned its keep" moment for the blog. Mobile nav overlap escaped to me.

**Summary line**
```
| R004 | Szechuan Royale | B1 | 1 | opus-4-8 [1m] | 31m | 44 | 1 | 3 | 1 | 4 | 5 | 5 | 4 | 62% | verify step caught broken menu image; mobile nav escaped |
```
