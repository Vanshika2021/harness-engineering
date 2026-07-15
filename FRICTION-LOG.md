# Friction log — exploratory runs (Szechuan Royale)

**Status:** Exploratory, per mentor — not scored. Goal: surface failure modes and process friction, and spec a harness that beats GSD/baseline. Model pinned: `claude-opus-4-8` (1M) throughout. Runs executed in a separate terminal from this bookkeeping session.

Provenance: `[A]` = agent reported · `[me]` = human caught (agent did not flag) · `[both]`.

---

## ★ HEADLINE FINDINGS

**1. Baseline fabricated an entire priced menu while claiming fidelity. GSD refused to.**
Same prompt, same model. Baseline Run 1 declared it reproduced "115 items across 12 categories, all prices verbatim, nothing invented." GSD, verifying against the live site, proved **the priced menu does not exist on the source** — no Menu page, no prices; the real menu lives only on ordering platforms. It stated plainly: "I won't fabricate one." Run 1's claim was fabrication presented as fidelity. `[me]` — caught by cross-run comparison.

**2. The baseline is a distribution, not a behavior.**
Two baseline runs, identical inputs, opposite conduct: Run 1 guessed and built immediately; Run 2 fetched, hit a 403 on the ordering site, recognized it "can't safely default," and stopped to ask. Confirms mentor's warning: a single A-vs-B comparison is noise. Also localizes the unreliability — ambiguous content sourcing. `[me]`

**3. Two of three "verified" ordering links were dead (HTTP 410) — every automated gate passed them.** `[me]`
GSD fetched the ordering URLs from the live source, asserted them character-for-character with `grep -F`, passed 7/7 assertions, passed plan-check, passed phase verification. Human clicked the buttons: Grubhub and Seamless both returned **410 Gone**. The source site's own listings are retired. **Perfect fidelity to a broken source.** GSD then searched, found the live listing (ID 6858288, address-matched to 470 Schooleys Mountain Rd), rejected a wrong-address candidate (24 Hastings Dr), and swapped them in — recorded as a user-authorized fidelity exception, flagged for Phase 4 owner sign-off.

**4. GSD's fidelity verification is architecturally capped by its tooling — and it said so.** `[A]`
Asked to confirm the replacement listings, GSD reported: Grubhub/Seamless are JavaScript apps that serve the same shell to its fetcher for **every** URL — live or 410 — so WebFetch received **200 OK for a page that shows a 410 to a human**. Its words: *"The reliable test is a real browser, which is exactly the tool that caught the original 410s: yours."* It fell back to a heuristic (dead listings carry a generic "Prepare your taste buds..." title; live ones carry real titles) to narrow candidates, then required human click-testing to confirm.
**Consequence for the harness spec: an HTTP-status check is insufficient. Liveness verification must be browser-based (render + read).**

**5. Chinese name — opposite failure modes, neither correct.** `[me]`
The restaurant's Chinese name **鸿园** appears only inside the storefront hero image (pixels, not text). Baseline mistranslated/invented it. GSD never perceived it: it extracts text only, so 鸿园 appears nowhere in PROJECT.md, REQUIREMENTS.md, or the built site — and, critically, **it is not a requirement, so no verifier checks for it.** Requirements derived from text-only extraction inherit the text-only blind spot. **Baseline hallucinates; GSD omits.** Neither is correct. mentor flagged this as the known failure point.

---

## Run A1 — baseline, `runs/szechuan-A-1`

- **Ended:** complete. ~5-6 min to a finished, self-verified site. 5 files (index, menu, styles, script, README). 3 permission approvals, **0** substantive content corrections requested.
- **Genuine strengths `[A]`:** started a local server unprompted and curled every page for 200; wrote scripts to check category counts vs. labels; caught and fixed a mismatch (House Special 18→17); flagged the price-sourcing problem and an address discrepancy after the fact.
- **The failure `[me]`:** claimed 115 priced items from a source that publishes none. The "18→17" self-correction was *internal-consistency* only — it matched the page to itself, never to reality, and may have concealed a dropped item rather than fixed a bug.
- **Process friction:** made unilateral content-sourcing decisions silently; disclosed only after building.

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

---

## The ledger (through Phase 2 of 4 — 50%)

| | Baseline (A1) | GSD (B1) |
|---|---|---|
| Time to a finished-looking site | ~5-6 min | 4.5+ hrs, 50% done |
| Human touchpoints | ~3 approvals | ~25 (decisions, approvals, 2 blocking human-verify gates) |
| Tokens | modest | ~600k+ and counting |
| Artifacts | 5 site files | 5 site files + ~14 planning docs |
| Content honesty | fabricated 115 priced items | refused 4 invention traps; 0 fabrications |
| What shipped | complete site, plausible, partly false | hero + ordering only; every claim verified |

**The uncomfortable comparison for the blog:** baseline's 5-minute output *looks* like a finished restaurant site with a full priced menu. GSD's 4.5-hour output says "coming soon" on two of three pages. **The dishonest artifact looks better.** That is precisely why "which site looks nicer" is the wrong metric.

---

## Harness spec — what "beats GSD/baseline" requires

Each item is a gate neither system has, derived from an observed failure:

1. **Browser-based liveness gate.** Render every outbound URL in a real browser and assert it isn't 404/410/error. **HTTP status is insufficient** — GSD's fetcher got 200 OK on a 410 page (JS shell). *Evidence: 2/3 links dead, all gates passed.*
2. **Vision/OCR gate.** Extract text from hero/storefront imagery and surface it for verification. *Evidence: 鸿园 invisible to GSD, hallucinated by baseline. Neither system addresses it.*
3. **Real visual/mobile check.** Render at target widths and verify layout — not just that files exist and return 200. *Evidence: GSD explicitly returns `human_needed` here.*
4. **Correspondence-to-reality, not just to-source.** GSD verifies the build matches what it fetched; nothing verifies the fetched data is still true. *Evidence: faithful reproduction of retired listings.*
5. **Stop-on-ambiguity gate.** Halt and ask when a required fact can't be sourced. *Evidence: baseline A1 fabricated; A2 did it by luck; GSD does it by design — make it structural.*

**Thesis for mentor:** baseline invents what it can't verify. GSD verifies what it fetches — genuinely, executably — but its verification is capped at the HTTP layer and blind to images, so it faithfully ships stale truth and silently omits what it cannot see. **A task-specific harness with browser-rendered and vision-based gates catches what both miss, cheaply.** That's the 10x argument: not a bigger framework, but the few gates a general-purpose one structurally cannot have.

---

## Open questions for mentor

1. **Authoritative menu source?** No arm can reproduce a priced menu that isn't published as text. Is there a real menu (PDF/export) you can supply? Blocks both arms equally.
2. **Address:** "Unit 3" / "ste-3" appears in third-party listings; the official site says 470 Schooleys Mountain Rd. Which is canonical?
3. Does the Chinese-name (鸿园) handling matter for scoring, given it's image-only?
4. Worth finishing Phases 3-4 (est. 4+ hrs) for a complete artifact, or are these findings sufficient?

## Verification still owed `[me]`

- [x] Chinese name on live site? YES — 鸿园, storefront hero image only, not page text.
- [x] Mobile nav human check — PASS at 402px and 430px, no defects.
- [x] Ordering links click-tested — 2/3 dead (410); replacements click-confirmed live and address-matched.
- [ ] Confirm A1's built `menu.html` actually contains fabricated priced items (would harden headline 1 from strong inference to proof).
- [ ] JS-disabled progressive-enhancement check (not performed — toggle not located in this Safari version).
