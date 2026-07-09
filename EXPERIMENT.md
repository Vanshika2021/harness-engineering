# Harness Engineering — Website Modernization Experiment Protocol

**Owner:** Vanshika Agrawal · **Supervisor:** Bo Wen (Enkira / NovaServe)
**Task domain:** "Modernize this website" on real restaurant sites
**Two deliverables this protocol feeds:**
1. Control experiment — same task built *with* vs *without* a harness.
2. Blog post — which agent skills / methods performed best.

> **Start here (pilot):** Run the full comparison — Arm A vs B1 vs B2 — on **Szechuan Royale alone** first: **3 trials per arm × 3 arms = 9 runs total.** Validate that the process, logging, and rubric work, then scale to Shokudo and Sushi Kingdom. Szechuan Royale is the best first case because Bo flagged its Chinese name being mistranslated in an earlier build, so it stress-tests the tricky-content dimension where the harness should show its value.

---

## 1. Research questions

- **RQ1 (control):** Does building with a harness produce measurably better outcomes than building without one, on the same modernization task?
- **RQ2 (skills bake-off):** Among candidate harness/agent-skill methods, which yields the best outcomes on this task?

RQ1 is the headline finding. RQ2 is the blog's spine. They share the same rig, so we run them together.

---

## 2. Core principle — control everything except one variable

Every run changes exactly **one** thing (the harness / method). Everything else is held identical, or recorded when it can't be.

**Held fixed across all runs**
- Source website (the "before") — same URL / same scraped content.
- Task prompt — one verbatim prompt, defined once in §6 and never edited mid-study.
- Base model — **pinned: `claude-opus-4-8` (1M context)** in Claude Code. Same model for every run; record it in the §9 Model column each time.
- Definition of "done" — see §5.
- Reference target for grading — Bo's example repo for that site.

**The independent variable (what we vary)**
- **Arm A — No harness:** plain Claude Code, single prompt, no skill loaded, no verification loop, no plan file.
- **Arm B — Harness:** the agent works under a harness. Two harness methods are tested here (see §7):
  - **B1 — GSD Core:** an off-the-shelf spec-driven harness framework (fresh-context subagents, persistent `.planning/` artifacts, a Verify step).
  - **B2 — DIY harness:** a lightweight hand-rolled harness — `harness-engineer` skill + a verification loop (tests / lint / visual check via Claude in Chrome / quality gates).

**Validity controls**
- **Repeat runs:** LLM output is stochastic. Run each configuration **≥3 trials** per site. Report the spread, not just one number.
- **Fresh context every run:** brand-new session, no memory bleed between runs.
- **Order counterbalancing:** don't always run Arm A first — alternate, so fatigue/learning doesn't favor one arm.
- **Blind grading where feasible:** strip arm labels from outputs before scoring so you don't score what you expect.
- **Sites with reference repos = head-to-head; extras = replication.** Only three source sites have a matching Bo reference (Szechuan Royale, Shokudo, Sushi Kingdom). Use those three for the scored comparison. `sk08865.com` and the second Sushi Kingdom URL have no reference, so treat them as held-out replication / stretch.

---

## 3. Sites

| Site | Source ("before") | Bo reference repo | Role |
|---|---|---|---|
| Szechuan Royale | szechuanroyalechinese.com | enkira-ai/szechuan-royale-website | Scored |
| Shokudo | shokudo07840.com | enkira-ai/shokudo-website | Scored |
| Sushi Kingdom | sushikingdomrestaurant.com | enkira-ai/sushi-kingdom-website | Scored |
| SK08865 | sk08865.com | — | Replication |
| Sushi Kingdom (CT) | sushikingdomct.com | — | Replication |

> Per Bo: ignore the Vercel deploy step — run the site on a local webserver and let the agent debug it visually via the Claude Chrome extension.

---

## 4. Scoring rubric

Four dimensions. The middle three are the metrics you chose ("all of the above"); the first captures whether the site is actually any good. Score 1–5 unless noted.

**A. Output quality**
- Design quality vs Bo's reference (does it look modern / on par?) — 1–5
- Content fidelity: menu items, prices, hours, address all correct — 1–5
- Tricky-content correctness: restaurant-name translation right, no hallucinated info — 1–5 *(Bo flagged this as a common failure point)*
- Functionality: runs locally, links work, responsive on mobile — 1–5

**B. Code quality & test coverage**
- Tests present? coverage % if measurable
- Code organization / readability — 1–5
- Builds & lints clean — pass / fail

**C. Speed / iterations**
- Wall-clock time to "done"
- Agent turns / tool calls
- Token cost (if visible)
- Human interventions required (count)

**D. Self-correction**
- Bugs the agent caught and fixed on its own (count)
- Bugs that escaped to the human (count)
- Recovery quality: on failure, did it diagnose + fix, or spin / get stuck? — 1–5

---

## 5. Definition of "done"

A run ends when **any** of these is true — record which:
1. **Complete** — the agent declares the task done AND the site runs locally without errors.
2. **Stalled** — no useful progress for **5 consecutive agent turns**.
3. **Capped** — **45 minutes** of wall-clock time reached.

These thresholds are now frozen for the whole study — don't change them mid-run. *(Confirm with Bo; adjust here only if he wants different numbers, before the first run.)*

---

## 6. The fixed prompt (define once, reuse verbatim)

This wording is frozen for the whole study. The **only** things that change per run are the two placeholders (restaurant name + URL); the sentences around them never change, and neither does anything between arms except the harness/skill context. *(Send Bo this exact wording to confirm before your first run.)*

```
Modernize the website for <RESTAURANT NAME> (current site: <URL>).
Keep all real content exactly as-is: menu items, prices, hours, address, and phone number.
Do not invent, omit, or alter any of this information.
Deliver a modern, responsive website that runs locally.
```

**Per-run substitutions** (fill the two placeholders each time — everything else stays identical):

| Site | `<RESTAURANT NAME>` | `<URL>` |
|---|---|---|
| Szechuan Royale | Szechuan Royale | szechuanroyalechinese.com |
| Shokudo | Shokudo | shokudo07840.com |
| Sushi Kingdom | Sushi Kingdom | sushikingdomrestaurant.com |

---

## 7. Candidate methods for RQ2

This section has **two parts**: the approaches you actually run (each is one arm), and the techniques those approaches are built from. Keeping them separate is the thing that usually causes confusion.

**Part 1 — Approaches you run** (each = one arm = rows in the log):

- **A — Baseline:** single-shot, plain Claude Code, no harness. *You write nothing.*
- **B1 — GSD Core:** the off-the-shelf framework. Runs a Discuss → Plan → Execute → Verify → Ship loop with disk-based `.planning/` artifacts and fresh-context subagents. *You install it; it brings its own rules — you write nothing.*
- **B2 — DIY harness:** a harness you assemble yourself — the `harness-engineer` skill + your own checks (tests / lint / visual check via Claude in Chrome / quality gates). *This is the only arm where you author rules — once, up front, then reuse unchanged.*

**Part 2 — Techniques** (the building blocks — never run on their own):

These are the *ingredients* a harness is made of. GSD Core (B1) already bundles all three automatically; your DIY harness (B2) is you picking and assembling some of them by hand.

- **Spec / plan-file-driven** — write a plan to disk, work against it (planning-with-files style).
- **Self-review / verify loop** — the agent checks its own output before "done" (or a second model reviews, codex-review style).
- **Context-isolation / subagents** — hand subtasks to fresh-context helpers to keep the main context clean.

**So the RQ2 headline comparison is:** B1 (a full pre-built framework) vs B2 (a simple hand-assembled harness) vs A (nothing) — with the Part 2 techniques as the shared parts list B1 and B2 are built from.

*Reading list (where the techniques come from — from Bo's onboarding email + call):* Addy Osmani — loop-engineering; Mario Zechner — pi-coding-agent; OpenAI — harness-engineering; Anthropic — harness design for long-running apps; GSD Core docs (docs.opengsd.net). As you read each, jot the specific trick it recommends next to the matching technique above.

---

## 8. Procedure (per run)

1. Fresh Claude Code session in the correct arm folder (`arm-a-no-harness/` or `arm-b-harness/`).
2. Give the fixed prompt (§6) + the source site.
3. Start a timer. Log **every** human intervention and **every** self-correction *as it happens* — you can't reconstruct these later.
4. Let it run until "done" per §5.
5. Run the site locally; check against the rubric; screenshot the result.
6. Open Bo's reference repo for that site; score dimension A against it.
7. Fill one row in the results log (§9). Reset. Next run.

---

## 9. Results log (fill in live)

**9a. Coverage tracker** — at-a-glance grid of which runs are done. Each box is one trial; check it off (☐ → ☑) as you complete a run. The pilot is complete when the Szechuan Royale row is all ticked (9 boxes).

| Site | Arm A (no harness) | Arm B1 (GSD Core) | Arm B2 (DIY harness) |
|---|---|---|---|
| Szechuan Royale | ☐ ☐ ☐ | ☐ ☐ ☐ | ☐ ☐ ☐ |
| Shokudo | ☐ ☐ ☐ | ☐ ☐ ☐ | ☐ ☐ ☐ |
| Sushi Kingdom | ☐ ☐ ☐ | ☐ ☐ ☐ | ☐ ☐ ☐ |

**9b. Detailed log** — one row per run, filled in live during the build.

| Run ID | Site | Arm / Method | Trial | Model | Wall time | Agent turns | Human interventions | Bugs self-caught | Bugs escaped | Design | Content | Correctness | Function | Test cov. | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| R001 | Szechuan | A (baseline) | 1 | opus-4-8 [1m] | | | | | | | | | | | |
| R002 | Szechuan | B1 (GSD Core) | 1 | opus-4-8 [1m] | | | | | | | | | | | |
| R003 | Szechuan | B2 (DIY harness) | 1 | opus-4-8 [1m] | | | | | | | | | | | |
| … | | | | | | | | | | | | | | | |

*(Consider mirroring 9b in a spreadsheet once it grows — easier to aggregate.)*

---

## 10. Analysis → blog

- Aggregate across trials; report **mean + spread** per arm/method (spread matters because of stochasticity).
- The money question for RQ1: *where did no-harness fail that the harness caught?* Concrete failure examples > averages for the blog.
- For RQ2: rank methods per dimension; note that "best" may differ by dimension (a method can be faster but lower quality).
- Keep screenshots + the escaped-bug list — those are your evidence.
