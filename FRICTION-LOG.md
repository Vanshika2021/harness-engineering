# Friction log — exploratory runs (Szechuan Royale)

**Status:** Exploratory, per mentor — not scored. Both runs COMPLETE (baseline x2; GSD 4/4 phases, 100%). Goal: surface failure modes and process friction, and spec a harness that beats GSD/baseline. Model pinned: `claude-opus-4-8` (1M) throughout. Runs executed in a separate terminal from this bookkeeping session.

Provenance: `[A]` = agent reported · `[me]` = human caught (agent did not flag) · `[both]`.

---

## ★ HEADLINE FINDINGS

**1. Baseline invented 115 priced dishes. GSD found 3. The source has 3. — PROVEN, not inferred.** `[both]`
Same prompt, same model, same source. Baseline Run 1 declared it reproduced "115 items across 12 categories, all prices verbatim, **nothing invented**." GSD's Phase-3 researcher (28 tool uses, 108.3k tokens, 6m) returned **exactly three** verbatim source-verified dish names — Spicy Kung Pao Chicken, Mapo Tofu, Szechuan-style noodles — and stopped there, refusing to pad a page that looks broken with three items.
**Independently verified `[me]`:** the live site names exactly those three dishes in prose, publishes **no prices anywhere**, and has no menu page. Gallery photos were checked in DevTools — alt text is auto-generated from filenames (`alt="new01_副本"` = "new01_copy"), no captions, several images are of empty dining rooms. No extractable dish names were missed.
**The 112-item delta is fabrication, measured.**

**2. The baseline is a distribution, not a behavior.**
Two baseline runs, identical inputs, opposite conduct: Run 1 guessed and built immediately; Run 2 fetched, hit a 403 on the ordering site, recognized it "can't safely default," and stopped to ask. Confirms mentor's warning: a single A-vs-B comparison is noise. Also localizes the unreliability — ambiguous content sourcing. `[me]`

**3. Two of three "verified" ordering links were dead (HTTP 410) — every automated gate passed them.** `[me]`
GSD fetched the ordering URLs from the live source, asserted them character-for-character with `grep -F`, passed 7/7 assertions, passed plan-check, passed phase verification. Human clicked the buttons: Grubhub and Seamless both returned **410 Gone**. The source site's own listings are retired. **Perfect fidelity to a broken source.** GSD then searched, found the live listing (ID 6858288, address-matched to 470 Schooleys Mountain Rd), rejected a wrong-address candidate (24 Hastings Dr), and swapped them in — recorded as a user-authorized fidelity exception, flagged for Phase 4 owner sign-off.

**4. GSD's fidelity verification is architecturally capped by its tooling — and it said so.** `[A]`
Asked to confirm the replacement listings, GSD reported: Grubhub/Seamless are JavaScript apps that serve the same shell to its fetcher for **every** URL — live or 410 — so WebFetch received **200 OK for a page that shows a 410 to a human**. Its words: *"The reliable test is a real browser, which is exactly the tool that caught the original 410s: yours."* It fell back to a heuristic (dead listings carry a generic "Prepare your taste buds..." title; live ones carry real titles) to narrow candidates, then required human click-testing to confirm.
**Consequence for the harness spec: an HTTP-status check is insufficient. Liveness verification must be browser-based (render + read).**

**5. Chinese name — baseline invented a different one; GSD omitted the real one.** `[me]`
The restaurant's actual Chinese name **鸿园** appears only inside the storefront hero image (pixels, not text). Baseline shipped a **龍** ("dragon") logo in its header — a generic decorative character that **is not this restaurant's name**: invention, not extraction. GSD never perceived 鸿园 at all: it reads text only, so the characters appear nowhere in PROJECT.md, REQUIREMENTS.md, or the built site — and critically, **it never became a requirement, so no verifier checks for it.** Requirements derived from text-only extraction inherit the text-only blind spot.
**Baseline invents Chinese-ness it doesn't have; GSD omits the Chinese name it does.** Neither shipped 鸿园. mentor flagged this as the known failure point.
*Confirm before publishing: the 龍 identification is from a screenshot reading, not from inspecting baseline's HTML. Verify the character and that it appears in the shipped markup.*

---

## Run A1 — baseline, `runs/szechuan-A-1`

- **Ended:** complete. ~5-6 min to a finished, self-verified site. 5 files (index, menu, styles, script, README). 3 permission approvals, **0** substantive content corrections requested.
- **Genuine strengths `[A]`:** started a local server unprompted and curled every page for 200; wrote scripts to check category counts vs. labels; caught and fixed a mismatch (House Special 18→17); flagged the price-sourcing problem and an address discrepancy after the fact.
- **The failure `[me]`:** claimed 115 priced items from a source that publishes none. The "18→17" self-correction was *internal-consistency* only — it matched the page to itself, never to reality, and may have concealed a dropped item rather than fixed a bug.
- **Process friction:** made unilateral content-sourcing decisions silently; disclosed only after building.
- **Invented a logo against its own recorded constraint `[me]`.** Baseline shipped a **龍** character in the site header. GSD's equivalent decisions (D-11/D-14) explicitly recorded "text wordmark only, no logo/photos" because no real imagery was available — baseline had the same absence of source material and produced a logo anyway. Not just invention: invention where the correct answer (nothing) was obvious from the source.

## Run A2 — baseline, second run

Fetched the live site, web-searched the menu, hit **403 Forbidden** on the ordering site, recognized it couldn't safely default, and **stopped to ask** before building. The good behavior A1 skipped — arrived at by chance, not by structure. Retroactively indicts A1: proved no legitimate public source for 115 priced items existed.

## Run B1 — GSD Core, `runs/szechuan-B1-1`

**Setup misfire `[me]`:** first attempt launched `claude` in the B1 folder without running `/gsd-new-project` → ran as plain Claude (no `.planning/`), i.e. a third baseline. Caught only by an `ls -a` check. **Installed ≠ invoked, and nothing signals "harness not active."** Real usability gap.

### What GSD did well `[A]`

- **Refused four invention traps:** priced menu, gallery photos, ordering-link URLs, hero claims (tagline limited to "verified facts").
- **Executed real fidelity verification:** spawned a researcher (17 tool uses, 74.6k tokens) that fetched and verified all three ordering URLs from the live source — no invention, no placeholders.
- **Fidelity guardrails as executable code:** `scripts/check-home-ordering.sh` asserts labels + URLs with `grep -F` fixed-string matches (character-for-character, utm params intact), run RED-first then built to GREEN. Not documentation — a test that can fail.
- **Gates that actually block:** plan-checker found 1 blocker + 2 warnings → returned to planner → revised → re-verified clean (iteration 2 of max 3). Separately, a decision-coverage gate blocked at 6/11 → forced citations → 11/11. Neither waved through.
- **Negative content check with teeth:** Phase 1 verifier ran independent greps proving zero real business content had leaked into the shell.
- **Testable requirements:** 14-15 numbered, checkable requirements with IDs, including FIDL-01 ("matches the source site exactly — no invention, omission, or alteration") and **"Out of scope: inventing menu items or prices"** — making not-fabricating a *checkable* constraint.
- **Persistence survives context wipes:** `/clear` between phases, then reloads PROJECT/ROADMAP/STATE from disk with zero loss. Baseline's reasoning was ephemeral.
- **Separated decisions from deliberation:** CONTEXT.md (decisions; agents read) vs DISCUSSION-LOG.md (alternatives considered; marked "audit trail only — do not use as input to agents"). Deliberate context hygiene.
- **Encoded fidelity-first as its core value** (PROJECT.md): *"A prettier site that gets a price or phone number wrong is a failure."*
- **Judgment over rule-following (the standout moment).** On the dead links: *"The fidelity rule exists to guarantee the site tells diners the truth about the business. 'Copy the source exactly' is the method for that, not the goal itself... the two goals have diverged, and I shouldn't silently pick one."* It distinguished method from goal, refused to resolve it silently, and offered four honest options.
- **Proper change control:** recorded the URL swap as a "documented deviation from the plan's LOCKED fidelity contract, authorized by you," and routed it to the Phase 4 owner gate.
- **Learned from the human correction:** wrote memories so the fidelity-vs-reality precedent carries into Phase 4.

### GSD's gaps and friction `[me]` unless noted

- **Cannot verify anything visual.** Returned `human_needed` on the mobile nav: *"static analysis can't exercise a browser."* Human check found no defects — its static claims held — but the capability gap is real regardless of outcome.
- **The 410 links** (headline 3) — passed every gate; only a human clicking caught it.
- **JS-rendered pages defeat its fetcher** (headline 4) — 200 OK for dead pages.
- **The Chinese-name blind spot** (headline 5) — not extracted, not a requirement, therefore never checked.
- **Generic gates no-op on this task:** schema-gate ("no ORM/schema files → injects nothing"), drift check ("skipped, non-blocking"), UI-SPEC gate (no hook active). GSD is a *general* software harness; this task's failure modes are content fidelity and text-in-images, for which it has no gate.
- **Asked about research three times** despite `research: false` in config — interactive mode overrides the saved preference.
- **Multi-select picker bug:** couldn't capture an empty submission; GSD detected the failure and fell back to plain text (good recovery, real bug).
- **gitignore collision:** GSD assumes it can git-commit planning artifacts; `runs/` being ignored blocked it. It self-diagnosed correctly ("the files on disk are the deliverable") and set `commit_docs: false`. Specific to this experiment's layout, not a general flaw.
- **Empty agent-skill payload:** `query agent-skills gsd-roadmapper` returned empty; the per-project install has no `skills/` directory (layout: bin, contexts, references, templates, workflows) and GSD's own install check raised no error — appears normal for this version. Non-finding.
- **Couldn't resume its own executor** (`SendMessage` unavailable) — spawned a fresh one briefed from disk. Handled cleanly; the persistence layer covered it.
- **Its own planning docs contradicted each other.** PROJECT.md recorded the hours in the *spaced* form; ROADMAP SC1 and REQUIREMENTS CONT-03 recorded the *unspaced* form. Under a character-for-character rule these are different strings. The plan-checker caught it by diffing GSD's own paperwork — a system self-consistency check that worked. But it means **multi-artifact persistence creates multi-artifact drift**: the more docs, the more places for the same fact to diverge.
- **`/clear` reminder is inconsistent between phases** — prompted before Phases 2 and 3, omitted before Phase 4. A user following its instructions literally would carry stale context into a phase, silently defeating the context-isolation discipline it's built on.
- **The whole FIDL-02 gate was designed around a stakeholder who doesn't exist.** GSD handled it honestly (headline 8), but the structural point stands: a harness that routes final authority to "the owner" has no path to done in any context where the owner isn't reachable — which includes every experimental, demo, or speculative build.

---

## The ledger (both runs COMPLETE)

| | Baseline (A1) | GSD (B1) |
|---|---|---|
| Time to finished site | **~6 min** | **~11 hrs** (4 phases, incl. idle) |
| Human touchpoints | ~3 approvals | **~30** (decisions, approvals, 4 blocking human-verify gates) |
| Tokens | modest | **~1M+** |
| Artifacts | 5 site files | 5 site files + ~20 planning docs + 3 check scripts |
| Dish names | **115, with prices** | **3, no prices** |
| Chinese character | **龍 — invented, not theirs** | **none — real name omitted** |
| Invention traps refused | 0 | **6** (menu, gallery, URLs, hero claims, 4th dish, owner signature) |
| Self-assessment | "nothing was invented" | ship-gate left OPEN, signature blank |
| Looks better? | **yes, clearly** | no — plain, sparse, honest |

**The through-line for the blog: the dishonest artifact is prettier.** Baseline's dark-red hero, dragon logo, and 115-item menu read as a finished restaurant site. GSD's cream page with three dishes reads as unfinished. One of them is true. Any metric that rewards the first is measuring the wrong thing — which is exactly why "which site looks nicer" cannot be the scoring criterion.

**The cost side is real and shouldn't be soft-pedalled.** Roughly two orders of magnitude more wall-clock, ~10x the human attention, ~1M tokens — for a *less* impressive-looking artifact. GSD's bet only pays if correctness is the thing you're buying. On this task it is. On many tasks it wouldn't be.

> **Caveat on these figures — they are estimates, not measurements.** Times, token counts, and touchpoints were tallied by observation from the session transcript, not instrumented. Wall-clock includes idle gaps (the session spanned two days with breaks), so "~11 hrs" is elapsed, not worked. **Before any of this goes in a blog post or to a reviewer, instrument it properly.** Directionally the gap is enormous and not in doubt; the specific multipliers are not defensible as stated.

---

## Harness spec — what "beats GSD/baseline" requires

Every item traces to an observed failure in these runs. **Design principle, proven three ways: ground truth must come from a rendered browser, not an HTTP fetch.** GSD's tooling sits between it and the page, and distorts it every time.

1. **Browser-based liveness gate.** Render every outbound URL in a real browser; assert no 404/410. **HTTP status is insufficient** — GSD's fetcher returned **200 OK on a 410-dead page** because Grubhub/Seamless are JS apps serving the same shell to every URL. *Evidence: 2/3 links dead, all gates passed, human found it by clicking.*
2. **Vision/OCR gate.** Extract text from hero/storefront imagery and require verification. *Evidence: 鸿园 invisible to GSD; baseline invented 龍 instead.*
3. **Embedded-widget gate.** Read iframes/map cards. *Evidence: the source's own Maps card says "#3"; its body text doesn't. Neither arm saw the map.*
4. **Completeness gate.** Enumerate all rendered source content; assert each item is present or explicitly deferred with a reason. *Evidence: FIDL-01 forbids omission but nothing tests for it; Gallery, socials, 鸿园, map all silently absent.*
5. **Rendered-text extraction, not markdown conversion.** *Evidence: GSD couldn't resolve en-dash vs hyphen in the hours string because its HTML→markdown step mangles the glyph. `document.body.textContent` returns the true character.*
6. **Cross-field consistency check.** Assert displayed value == machine value. *Evidence: `tel:` digits and the visible number are asserted separately — a typo in one passes both. GSD's mitigation was "the human dials it."*
7. **Stop-on-ambiguity gate.** Halt and ask when a required fact can't be sourced. *Evidence: baseline A1 fabricated; A2 did it by luck; GSD does it by design — make it structural.*

**Every gate must be RED-tested** — GSD's own best practice, and worth stealing: it injected fake prices to prove `check-menu.sh` fires, *then* confirmed it passes clean. Its line is the design brief: **"fabrication is both forbidden and detectable."** Don't just write the vision check — feed it a wrong translation and prove it catches it.

**Thesis for mentor.** Baseline invents what it can't verify and certifies itself. GSD verifies genuinely and executably — but its verification is capped at the HTTP/text layer, so it faithfully ships stale truth, silently omits what it cannot see, and routes every irreducible check to a human. **In this run, every piece of ground truth came from a person in a browser.** A task-specific harness with browser-rendered, vision-based, completeness-checked gates catches what both miss — cheaply, and automatically. That's the 10x argument: not a bigger framework, but the handful of gates a general-purpose one structurally cannot have.

---

## Before this goes anywhere public

Findings above are recorded as observed, but three things need hardening:

1. **Instrument the cost figures.** Time/tokens/touchpoints are eyeballed from the transcript. Measure them properly or state them as rough.
2. **Confirm the 龍 character** in baseline's actual HTML, not from a screenshot.
3. **Confirm whether RED-testing-the-test is standard GSD behavior** or emergent in this run — the claim is load-bearing for the harness spec and currently rests on one observation.

---

## Open questions for mentor

1. **Address:** the source contradicts itself — body text says "470 Schooleys Mountain Rd.", its own embedded Maps card says "**#3**". Which is canonical? (Both arms took the text.)
2. **Authoritative menu source?** No arm can reproduce a priced menu that isn't published as text. Is there a real menu (PDF/export) you can supply? Blocks both arms equally.
3. Does the 鸿园 handling matter for scoring, given it's image-only? Note baseline invented a *different* character (龍) rather than omitting.
4. Is RED-testing-the-test standard GSD behavior or emergent here? (Worth confirming from the docs before claiming it.)
5. Given the ~110x time cost, is the right next step building the harness, or first defining what "10x better" is measured *on*?

## Verification completed `[me]`

- [x] Chinese name on live site — YES, 鸿园, storefront hero image only, not page text.
- [x] Gallery photos inspected in DevTools — alt text is filenames, no dish names missed; GSD's count of 3 confirmed accurate.
- [x] Mobile nav — PASS at 402px and 430px, no defects; GSD's static claims held.
- [x] Ordering links click-tested — 2/3 dead (410); replacements click-confirmed live and address-matched.
- [x] Hours format — confirmed **spaced** form against the live source.
- [x] Live site publishes no prices and no menu page — confirmed.
- [ ] JS-disabled progressive-enhancement check (not performed — toggle not located in this Safari version).
