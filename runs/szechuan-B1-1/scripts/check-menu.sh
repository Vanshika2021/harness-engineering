#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# check-menu.sh — Phase 3 (Menu) fidelity/scope smoke-check
#
# Static site: no npm/test runner (CLAUDE.md forbids a build step). This is a
# plain bash script of grep/diff assertions. Run from the repo root:
#     bash scripts/check-menu.sh
#
# Exits non-zero on the FIRST failed assertion, printing which check failed.
# Uses fixed-string matching (grep -F) so dish-name/URL fidelity is exact: a
# rename, an altered URL, or an invented price fails the check. This is the
# mechanical half of the project's defining content-fidelity control; the
# human/owner review (Phase 4 FIDL-02) is the authoritative half.
#
# All fidelity literals live INSIDE the assertion commands only (never in a
# comment a later negative grep could read).
# ---------------------------------------------------------------------------
set -euo pipefail

MENU="menu.html"
INDEX="index.html"
STYLES="styles.css"

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

# --- (a) MENU-01 dish presence: exactly the three verified dish names, verbatim.
#         Fixed-string so casing/hyphenation cannot drift ("Szechuan-style
#         noodles" stays hyphenated + lowercase; "Spicy" is kept).
for d in "Spicy Kung Pao Chicken" "Mapo Tofu" "Szechuan-style noodles"; do
  grep -Fq "$d" "$MENU" || fail "(a) MENU-01 dish name missing from $MENU: $d"
done

# --- (b) MENU-01 no-price fidelity: the source has NO prices. A match here IS
#         the failure (dollar-sign-plus-digit OR a bare decimal-cents token).
if grep -Eq '\$[0-9]|[0-9]+\.[0-9]{2}' "$MENU"; then
  fail "(b) MENU-01 price/currency token found in $MENU — fidelity violation (source has no prices)"
fi

# --- (c) MENU-02 dead-listing absence: the retired Grubhub/Seamless listing id
#         must never appear. A match IS the failure.
if grep -Fq '402532' "$MENU"; then
  fail "(c) MENU-02 retired listing fragment present in $MENU — use the verified 6858288 listings"
fi

# --- (d) MENU-02 ordering URLs present: the three verbatim host+id fragments.
grep -Fq 'order.mealkeyway.com/merchant/697a4f754551584c38385230584f427631595a526e413d3d/main' "$MENU" \
  || fail "(d) MealKeyway ordering destination fragment missing/altered in $MENU"
grep -Fq 'grubhub.com/restaurant/szechuan-royale-470-schooleys-mountain-rd-hackettstown/6858288' "$MENU" \
  || fail "(d) Grubhub ordering destination fragment missing/altered in $MENU"
grep -Fq 'seamless.com/menu/szechuan-royale-470-schooleys-mountain-rd-hackettstown/6858288' "$MENU" \
  || fail "(d) Seamless ordering destination fragment missing/altered in $MENU"

# --- (e) MENU-02 external-link safety: exactly three target=_blank rel=noopener
#         noreferrer anchors (reverse-tabnabbing + referrer-leak guard).
BLANK_COUNT="$(grep -cF 'target="_blank" rel="noopener noreferrer"' "$MENU" || true)"
[ "$BLANK_COUNT" -eq 3 ] || fail "(e) found $BLANK_COUNT external-link safety attributes in $MENU; expected exactly 3"

# --- (f) Chrome scope: header + footer chrome in menu.html match index.html
#         verbatim, proving nothing outside <main> drifted. The header differs
#         only in the per-page active marker (is-active / aria-current="page"),
#         so normalize that out before comparing; compare the footer strictly.
hdr() {
  sed -n '/SHARED CHROME: HEADER/,/END SHARED CHROME: HEADER/p' "$1" \
    | sed -E 's/ is-active//g; s/ aria-current="page"//g'
}
ftr() {
  sed -n '/SHARED CHROME: FOOTER/,/END SHARED CHROME: FOOTER/p' "$1"
}

[ -n "$(hdr "$INDEX")" ] || fail "(f) could not extract HEADER chrome block from $INDEX (markers missing?)"
[ -n "$(ftr "$INDEX")" ] || fail "(f) could not extract FOOTER chrome block from $INDEX (markers missing?)"

diff <(hdr "$INDEX") <(hdr "$MENU") >/dev/null \
  || fail "(f) HEADER chrome in $MENU drifted from $INDEX (only the per-page active marker may differ)"
diff <(ftr "$INDEX") <(ftr "$MENU") >/dev/null \
  || fail "(f) FOOTER chrome in $MENU drifted from $INDEX (must be byte-identical)"

echo "PASS: all assertions passed — 3 verbatim dish names, no price tokens, no retired 402532 listing, 3 verbatim ordering URLs (6858288 listings), 3 external-link guards, chrome scope unchanged."
