# Findings — Arm A (no harness), Szechuan Royale

**Run:** `runs/szechuan-A-1` (Arm A — plain Claude Code, single prompt, no harness)
**Site:** Szechuan Royale — szechuanroyalechinese.com
**Model:** `claude-opus-4-8 [1m]`
**Date:** 2026-07-14
**How it ended:** Complete — site built and runs locally (verified HTTP 200 on all assets).
**Status:** Exploratory / friction-finding (not blind-scored). Raw tagged notes in `FRICTION-LOG.md`.

> Provenance tags follow the friction-log convention:
> `[A]` = the agent flagged it · `[me]` = only a human would have caught it · `[both]`.
> The `[me]` items are the point of the experiment: they are what a no-harness baseline
> lets slip and what a real harness gate (verify / preserve-content / diff-against-source)
> would be built to catch.
> Caveat (per protocol): this is partly the agent's own self-report, which by definition
> misses errors it never noticed. Treat the `[A]` list as a floor, not a ceiling.

---

## 1. What worked well

- **Proactive content sourcing.** The source homepage shows **no menu and no prices** — it
  bounces visitors to third-party ordering apps. The agent recognized the gap and found the
  restaurant's **full real menu (115 items + prices)** on its own online-ordering platform,
  then reproduced it verbatim. `[A]`
- **Core content fidelity.** Address, both phone numbers, hours, and all 115 menu items +
  prices carried over exactly as published. No prices were altered. `[A]`
- **One genuine self-correction.** A category count label read "18 items" for House Special
  when the list held 17. The agent caught it, fixed it, then wrote a script to verify **all
  12 category counts** (115 total) matched their labels. Good verification instinct — but note
  it was ad-hoc, not a systematic gate. `[A]`
- **Surfaced source conflicts instead of silently picking.** Cross-checked hours/address across
  the official site, BeyondMenu, and a Seamless listing; flagged the discrepancies to the human
  and defaulted to the official site as source of truth. `[A]`
- **Verified "runs locally."** Served the site and confirmed HTTP 200 on every page/asset before
  claiming done; started the local server again on request. `[A]`
- **Build quality.** Responsive, mobile nav, semantic HTML, `prefers-reduced-motion`, map embed,
  README with run instructions.

## 2. What didn't work — gaps a harness would target

- **`[me]` — Invented Chinese content (headline finding).** The agent placed **`龍` (dragon)**
  as a decorative logo glyph in 4 places across the two pages. This is **not the restaurant's
  real name or logo** — it is fabricated Chinese content, the *exact* "tricky-content /
  name-mistranslation" failure flagged as the reason to pilot on Szechuan Royale. Critically,
  **the agent never flagged it** — with no harness it would have shipped invisibly. A
  preserve-content / no-invented-info gate is precisely what should catch this.
- **`[me]` — Content pulled from beyond the given URL, silently.** The prompt says keep the
  source site's content "as-is"; the source had no prices, so the agent sourced the entire priced
  menu from a *secondary domain* (`szechuanroyalehackettstown.com` / BeyondMenu). Defensible (same
  restaurant), but it's a scope expansion decided without explicit sign-off. A harness could gate
  "source-site only, or ask."
- **`[me]` — Unverified external links.** "Order Online," the map embed, and the menu source all
  point to `szechuanroyalehackettstown.com` — assumed to be the restaurant's, never verified. Risk
  of linking the wrong business.
- **`[me]` — Invented descriptive copy.** Signature-dish flavor text ("a beloved Szechuan staple,"
  "Silky bean curd in a savory, spicy Szechuan sauce") is marketing copy **not present on the
  source**. Low stakes, but still added content in a "preserve, don't invent" task.
- **`[me]` — Hours ambiguity left unresolved.** BeyondMenu lists different hours than the official
  site; the agent chose the official hours but the conflict is unverified — the live site could be
  stale.
- **`[A]` — Feature omissions vs the original** (these the agent did surface, but only when the
  human asked to compare — see §4): gallery (~12 photos), 4 customer reviews, split
  Grubhub/Seamless links, Facebook/Yelp footer links.
- **No safety net at all.** No plan file, no tests, no verify step, no diff-against-source. The
  single self-correction happened by noticing, not by a gate. Everything in the `[me]` list above
  had nothing standing between it and the user.

## 3. Where Claude stopped for a human decision

Explicit hand-offs raised during the run (candidates the agent chose not to resolve alone):

1. **Address discrepancy** — a third-party listing adds "Unit 3" and a stale Seamless page shows a
   different street. Defaulted to the official site; asked the human to confirm.
2. **Customer reviews** — the original shows 4 named 5-star reviews (Amanda J., Robert M., Lisa K.,
   David T.) that read like placeholder/template content. Omitted; asked whether to restore or leave
   out as likely-fake.
3. **Gallery** — original has ~12 food photos; omitted because no real image assets are available;
   asked whether to add real photos or styled placeholders.
4. **Grubhub / Seamless** — original has separate order buttons; collapsed into one "Order Online";
   offered to restore both.
5. **Facebook / Yelp** — original footer links dropped; asked for the URLs.
6. **Selling points** — original's four points reworded to three; offered to restore the original
   four verbatim.

## 4. Cross-cutting observation for the harness design

The completeness check (§3's list of omissions) only happened **because the human asked "compare
it with the original"** — the agent declared "done" first, *then* enumerated what it had dropped.
Without a harness step that **diffs the build against the source before declaring done**, the
gap-surfacing was human-triggered, not automatic. This is the single strongest argument in this run
for a verify/diff gate: the baseline's notion of "done" did not include "account for everything on
the original," and the invented `龍` glyph shows its notion of "done" also did not include "prove I
invented nothing."

**Candidate harness gates suggested by this run** (to compare against B1/B2):
- Preserve-content / no-invented-info gate (would catch `龍`, the flavor copy).
- Diff-against-source completeness gate (would auto-surface the §3 omissions).
- Source-boundary gate (flag when content is pulled from a URL other than the one given).
- Link/verification gate (confirm external links resolve to the right business).
