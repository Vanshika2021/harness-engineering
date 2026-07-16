#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# check-contact.sh — Phase 4 (Contact & content fidelity) smoke-check
#
# Static site: no npm/test runner (CLAUDE.md forbids a build step). This is a
# plain bash script of grep/diff assertions. Run from the repo root:
#     bash scripts/check-contact.sh
#
# Exits non-zero on the FIRST failed assertion, printing which check failed.
# Uses fixed-string matching (grep -F) so business-content fidelity is exact:
# a wrong digit, an altered street number, or a drifted hours glyph fails the
# check. This is the mechanical half of the project's defining content-fidelity
# control; the human/owner review (Phase 4 FIDL-02) is the authoritative half.
#
# All fidelity literals live INSIDE the assertion commands only (never in a
# comment a later negative grep could read). Where a value must be named in
# prose it is described by concept, not spelled out.
#
# CANONICAL HOURS FORM: held in the single HOURS variable below so a later task
# (the human-verify checkpoint) can update ONE line if the source-confirmed
# character form differs from the working default.
# ---------------------------------------------------------------------------
set -euo pipefail

CONTACT="contact.html"
INDEX="index.html"
MENU="menu.html"

# Single source-of-truth hours string (working default: unspaced en-dashes,
# middle dot U+00B7). Task 4 updates THIS line if the live source differs.
HOURS="Mon Closed · Tue – Sun 11:30 AM – 9:00 PM"

fail() {
  echo "FAIL: $1" >&2
  exit 1
}

# --- (a) CONT-01 address present: the verbatim street address, fixed-string.
grep -Fq '470 Schooleys Mountain Rd., Hackettstown, NJ 07840' "$CONTACT" \
  || fail "(a) CONT-01 verbatim address missing from $CONTACT"

# --- (b) CONT-02 phone present: each verbatim number AND the exact combined
#         space-slash-space form.
grep -Fq '908-850-4558' "$CONTACT" || fail "(b) CONT-02 first verbatim phone number missing from $CONTACT"
grep -Fq '908-850-6062' "$CONTACT" || fail "(b) CONT-02 second verbatim phone number missing from $CONTACT"
grep -Fq '908-850-4558 / 908-850-6062' "$CONTACT" \
  || fail "(b) CONT-02 verbatim combined phone (space-slash-space) missing from $CONTACT"

# --- (c) CONT-03 hours present: the canonical HOURS string (single variable).
grep -Fq "$HOURS" "$CONTACT" || fail "(c) CONT-03 canonical hours string missing from $CONTACT"

# --- (d) CONT-04 tap-to-call anchor: the E.164 tel: href fragment.
grep -Fq 'href="tel:+19088504558"' "$CONTACT" || fail "(d) CONT-04 tel: click-to-call anchor missing from $CONTACT"

# --- (e) CONT-05 directions anchor: a maps-host link carrying the
#         URL-encoded street-address token.
grep -Fq 'google.com/maps' "$CONTACT" || fail "(e) CONT-05 google.com/maps directions anchor missing from $CONTACT"
grep -Fq '470+Schooleys+Mountain+Rd' "$CONTACT" \
  || fail "(e) CONT-05 URL-encoded address token missing from the map anchor in $CONTACT"

# --- (f) FIDL-01 footers filled + no placeholder: each page carries the
#         verbatim address, a phone token, and the HOURS string; and the
#         fixed string below must NOT appear anywhere (a match IS the failure).
for f in "$INDEX" "$MENU" "$CONTACT"; do
  grep -Fq '470 Schooleys Mountain Rd., Hackettstown, NJ 07840' "$f" \
    || fail "(f) FIDL-01 verbatim address missing from footer content in $f"
  grep -Fq '908-850-4558' "$f" || fail "(f) FIDL-01 phone token missing from footer content in $f"
  grep -Fq "$HOURS" "$f" || fail "(f) FIDL-01 canonical hours string missing from footer content in $f"
  if grep -Fq 'coming soon' "$f"; then
    fail "(f) FIDL-01 placeholder text still present in $f — footer not reconciled"
  fi
done

# --- (g) FIDL-01 chrome byte-identity: the FOOTER block must be byte-identical
#         across all three pages (proves the footer fill was applied identically);
#         the HEADER block matches too except the per-page active nav marker.
hdr() {
  sed -n '/SHARED CHROME: HEADER/,/END SHARED CHROME: HEADER/p' "$1" \
    | sed -E 's/ is-active//g; s/ aria-current="page"//g'
}
ftr() {
  sed -n '/SHARED CHROME: FOOTER/,/END SHARED CHROME: FOOTER/p' "$1"
}

[ -n "$(ftr "$CONTACT")" ] || fail "(g) could not extract FOOTER chrome block from $CONTACT (markers missing?)"
[ -n "$(hdr "$CONTACT")" ] || fail "(g) could not extract HEADER chrome block from $CONTACT (markers missing?)"

diff <(ftr "$CONTACT") <(ftr "$INDEX") >/dev/null \
  || fail "(g) FOOTER chrome in $CONTACT drifted from $INDEX (must be byte-identical)"
diff <(ftr "$CONTACT") <(ftr "$MENU") >/dev/null \
  || fail "(g) FOOTER chrome in $CONTACT drifted from $MENU (must be byte-identical)"
diff <(hdr "$CONTACT") <(hdr "$INDEX") >/dev/null \
  || fail "(g) HEADER chrome in $CONTACT drifted from $INDEX (only the per-page active marker may differ)"
diff <(hdr "$CONTACT") <(hdr "$MENU") >/dev/null \
  || fail "(g) HEADER chrome in $CONTACT drifted from $MENU (only the per-page active marker may differ)"

# --- (h) external-link safety: the new map/directions anchor carries the
#         reverse-tabnabbing + referrer-leak guard attribute string.
grep -Fq 'target="_blank" rel="noopener noreferrer"' "$CONTACT" \
  || fail "(h) external-link safety attribute missing from $CONTACT (map/directions anchor)"

echo "PASS: all assertions passed — verbatim address/phone/hours on contact.html, tel: + google.com/maps anchors, all three footers filled (no 'coming soon'), footer chrome byte-identical across the three pages, external-link guard present."
