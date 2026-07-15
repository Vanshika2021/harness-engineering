#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# check-home-ordering.sh — Phase 2 (Home & Ordering) fidelity/scope smoke-check
#
# Static site: no npm/test runner (CLAUDE.md forbids a build step). This is a
# plain bash script of grep/diff assertions. Run from the repo root:
#     bash scripts/check-home-ordering.sh
#
# Exits non-zero on the FIRST failed assertion, printing which check failed.
# Uses fixed-string matching (grep -F) so ordering label/URL fidelity is exact:
# a rename or an altered URL fails the check. All assertions are positive
# (must-exist) except assertion (5), which is an exact count.
# ---------------------------------------------------------------------------
set -euo pipefail

INDEX="index.html"
MENU="menu.html"
STYLES="styles.css"

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

# --- (1) Hero H1 identity present: an <h1> whose text includes Szechuan + Royale
#         Extract the <h1>...</h1> region and confirm both identity tokens appear.
H1_LINE="$(grep -F '<h1' "$INDEX" || true)"
[ -n "$H1_LINE" ] || fail "(1) no <h1> found in $INDEX (hero identity missing)"
echo "$H1_LINE" | grep -Fq 'Szechuan' || fail "(1) <h1> does not contain identity token 'Szechuan'"
echo "$H1_LINE" | grep -Fq 'Royale'   || fail "(1) <h1> does not contain identity token 'Royale'"

# --- (2) The three exact ordering LABELS are present (verbatim, fixed-string).
grep -Fq 'Order Online Now' "$INDEX" || fail "(2) primary CTA label 'Order Online Now' missing from $INDEX"
grep -Fq 'Grubhub Order'    "$INDEX" || fail "(2) label 'Grubhub Order' missing from $INDEX"
grep -Fq 'Seamless Order'   "$INDEX" || fail "(2) label 'Seamless Order' missing from $INDEX"

# --- (3) The three exact destination host+id fragments are present (verbatim).
grep -Fq 'order.mealkeyway.com/merchant/697a4f754551584c38385230584f427631595a526e413d3d/main' "$INDEX" \
  || fail "(3) MealKeyway merchant destination fragment missing/altered in $INDEX"
grep -Fq 'grubhub.com/restaurant/szechuan-royale-470-schooleys-mountain-rd-ste-3-hackettstown/402532' "$INDEX" \
  || fail "(3) Grubhub destination fragment missing/altered in $INDEX"
grep -Fq 'seamless.com/menu/szechuan-royale-470-schooleys-mountain-rd-ste-3-hackettstown/402532' "$INDEX" \
  || fail "(3) Seamless destination fragment missing/altered in $INDEX"

# --- (4) utm params survive, HTML-encoded ampersands, present >= twice (Grubhub + Seamless).
UTM_COUNT="$(grep -cF 'utm_source=google&amp;utm_medium=organic&amp;utm_campaign=place-action-link' "$INDEX" || true)"
[ "$UTM_COUNT" -ge 2 ] || fail "(4) HTML-encoded utm params found $UTM_COUNT time(s); expected >= 2 (Grubhub + Seamless, ampersands not stripped)"

# --- (5) External-link safety: exactly three target=_blank rel=noopener noreferrer anchors.
BLANK_COUNT="$(grep -cF 'target="_blank" rel="noopener noreferrer"' "$INDEX" || true)"
[ "$BLANK_COUNT" -eq 3 ] || fail "(5) found $BLANK_COUNT external-link safety attributes; expected exactly 3"

# --- (6) Chrome scope: header + footer chrome in index.html match menu.html verbatim,
#         proving nothing outside <main> drifted. The header differs only in the
#         per-page active marker (is-active / aria-current="page"), so normalize
#         that out before comparing the header; compare the footer strictly.
hdr() {
  sed -n '/SHARED CHROME: HEADER/,/END SHARED CHROME: HEADER/p' "$1" \
    | sed -E 's/ is-active//g; s/ aria-current="page"//g'
}
ftr() {
  sed -n '/SHARED CHROME: FOOTER/,/END SHARED CHROME: FOOTER/p' "$1"
}

[ -n "$(hdr "$INDEX")" ] || fail "(6) could not extract HEADER chrome block from $INDEX (markers missing?)"
[ -n "$(ftr "$INDEX")" ] || fail "(6) could not extract FOOTER chrome block from $INDEX (markers missing?)"

diff <(hdr "$INDEX") <(hdr "$MENU") >/dev/null \
  || fail "(6) HEADER chrome in $INDEX drifted from $MENU (only the per-page active marker may differ)"
diff <(ftr "$INDEX") <(ftr "$MENU") >/dev/null \
  || fail "(6) FOOTER chrome in $INDEX drifted from $MENU (must be byte-identical)"

# --- (7) Reusable .btn component exists in the stylesheet.
grep -Fq '.btn' "$STYLES" || fail "(7) reusable '.btn' component not found in $STYLES"

echo "PASS: all 7 assertions passed — hero identity, 3 verbatim labels, 3 verbatim URLs, utm params intact, 3 external-link guards, chrome scope unchanged, .btn component present."
