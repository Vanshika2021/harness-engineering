# Harness Engineering — Website Modernization Experiment Protocol

**Owner:** Vanshika Agrawal · **Supervisor:** Bo Wen (Enkira / NovaServe)
**Task domain:** "Modernize this website" on real restaurant sites
**Two deliverables this protocol feeds:**
1. Control experiment — same task built *with* vs *without* a harness.
2. Blog post — which agent skills / methods performed best.

> **Start here (pilot):** Run the full Arm A vs Arm B comparison on **Szechuan Royale alone** first — 3 trials per arm, 6 runs total. Validate that the process, logging, and rubric work, then scale to Shokudo and Sushi Kingdom. Szechuan Royale is the best first case because Bo flagged its Chinese name being mistranslated in an earlier build, so it stress-tests the tricky-content dimension where the harness should show its value.

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
- Base model — pin it (e.g. a specific Claude model in Claude Code). Record the exact version.
- Definition of "done" — see §5.
- Reference target for grading — Bo's example repo for that site.

**The independent variable (what we vary)**
- **Arm A — No harness:** plain Claude Code, single prompt, no skill loaded, no verification loop, no plan file.
- **Arm B — Harness:** harness-engineer skill loaded + a verification loop (tests / lint / visual check via Claude in Chrome / quality gates).
- **Arm B-variants (RQ2):** swap in different methods one at a time (see §7).

**Validity controls**
- **Repeat runs:** LLM output is stochastic. Run each configuration >=3 trials per site. Report the spread, not just one number.
- **Fresh context every run:** brand-new session, no memory bleed between runs.
- **Order counterbalancing:** don't always run Arm A first — alternate, so fatigue/learning doesn't favor one arm.
- **Blind grading where feasible:** strip arm labels from outputs before scoring so you don't score what you expect.
- **Sites with reference repos = head-to-head; extras = replication.** Only three source sites have a matching Bo reference (Szechuan Royale, Shokudo, Sushi Kingdom). Use those three for the scored comparison. sk08865.com and the second Sushi Kingdom URL have no reference, so treat them as held-out replication / stretch.

---

## 3. Sites

| Site | Source ("before") | Bo reference repo | Role |
|---|---|---|---|
| Szechuan Royale | szechuanroyalechinese.com | enkira-ai/szechuan-royale-website | Scored — START HERE |
| Shokudo | shokudo07840.com | enkira-ai/shokudo-website | Scored |
| Sushi Kingdom | sushikingdomrestaurant.com | enkira-ai/sushi-kingdom-website | Scored |
| SK08865 | sk08865.com | — | Replication |
| Sushi Kingdom (CT) | sushikingdomct.com | — | Replication |

> Per Bo: ignore the Vercel deploy step — run the site on a local webserver and let the agent debug it visually via the Claude Chrome extension.

---

## 4. Scoring rubric

Four dimensions. The middle three are the metrics you chose ("all of the above"); the first captures whether the site is actually any good. Score 1-5 unless noted.

**A. Output quality**
- Design quality vs Bo's reference (does it look modern / on par?) — 1-5
- Content fidelity: menu items, prices, hours, address all correct — 1-5
- Tricky-content correctness: restaurant-name translation right, no hallucinated info — 1-5 *(Bo flagged this as a common failure point)*
- Functionality: runs locally, links work, responsive on mobile — 1-5

**B. Code quality & test coverage**
- Tests present? coverage % if measurable
- Code organization / readability — 1-5
- Builds & lints clean — pass / fail

**C. Speed / iterations**
- Wall-clock time to "done"
- Agent turns / tool calls
- Token cost (if visible)
- Human interventions required (count)

**D. Self-correction**
- Bugs the agent caught and fixed on its own (count)
- Bugs that escaped to the human (count)
- Recovery quality: on failure, did it diagnose + fix, or spin / get stuck? — 1-5

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

| Site | Restaurant name | URL |
|---|---|---|
| Szechuan Royale | Szechuan Royale | szechuanroyalechinese.com |
| Shokudo | Shokudo | shokudo07840.com |
| Sushi Kingdom | Sushi Kingdom | sushikingdomrestaurant.com |

---

## 7. Candidate methods for RQ2

Baseline is the control; each method below is one row in your results log. As you read Bo's sources, extract the specific technique each advocates and map it to a variant.

- **Baseline** — single-shot, no harness *(this is Arm A)*
- **Verification/build-test loop** — the enkira harness-engineer skill *(this is Arm B)*
- **Spec / plan-file-driven** — write a plan to disk, work against it (planning-with-files style)
- **Self-review / critique loop** — agent critiques its own output, or a second model reviews (codex-review style)
- **Context-isolation / subagent** — delegate subtasks to keep the main context clean

Reading list these map to (from Bo's onboarding email): Addy Osmani — loop-engineering; Mario Zechner — pi-coding-agent; OpenAI — harness-engineering; Anthropic — harness design for long-running apps. Slot the concrete technique from each into the rows above as you go.

---

## 8. Procedure (per run)

1. Fresh Claude Code session in the correct arm folder (arm-a-no-harness/ or arm-b-harness/).
2. Give the fixed prompt (§6) + the source site.
3. Start a timer. Log **every** human intervention and **every** self-correction *as it happens* — you can't reconstruct these later.
4. Let it run until "done" per §5.
5. Run the site locally; check against the rubric; screenshot the result.
6. Open Bo's reference repo for that site; score dimension A against it.
7. Fill one row in the results log (§9). Reset. Next run.

---

## 9. Results log (fill in live)

| Run ID | Site | Arm / Method | Trial | Model | Wall time | Agent turns | Human interventions | Bugs self-caught | Bugs escaped | Design | Content | Correctness | Function | Test cov. | Notes |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| R001 | Szechuan | A (baseline) | 1 | | | | | | | | | | | | |
| R002 | Szechuan | B (harness) | 1 | | | | | | | | | | | | |
| ... | | | | | | | | | | | | | | | |

*(Consider mirroring this in a spreadsheet once it grows — easier to aggregate.)*

---

## 10. Analysis to blog

- Aggregate across trials; report **mean + spread** per arm/method (spread matters because of stochasticity).
- The money question for RQ1: *where did no-harness fail that the harness caught?* Concrete failure examples > averages for the blog.
- For RQ2: rank methods per dimension; note that "best" may differ by dimension (a method can be faster but lower quality).
- Keep screenshots + the escaped-bug list — those are your evidence.
