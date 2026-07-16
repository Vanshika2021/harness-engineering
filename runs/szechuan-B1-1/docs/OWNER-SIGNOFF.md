# Owner content-fidelity sign-off — Szechuan Royale website (FIDL-02)

**Purpose.** This is the authoritative content-fidelity control for the rebuilt
Szechuan Royale website. Every real business value shown on the site is listed
below exactly as it currently ships. Please confirm each one is correct, resolve
the two open exceptions, and complete the sign-off block at the bottom.

**The site is NOT considered shippable until the owner completes the sign-off
block at the end of this document.** Until then, the project blocker "owner final
confirmation pending" remains open.

Core rule of the project: every piece of real business content (name, address,
phone, hours, ordering links) must match the source exactly — never invented,
omitted, or altered. A prettier site that gets a phone number or price wrong is a
failure.

---

## 1. Verified business content — confirm each is exact

Each value below is copied character-for-character from the shipped site. Check
the box once you have confirmed it is correct.

| ✓ | Item | Exact value as shipped |
|---|------|------------------------|
| [ ] | Restaurant name | Szechuan Royale |
| [ ] | Address | 470 Schooleys Mountain Rd., Hackettstown, NJ 07840 |
| [ ] | Phone | 908-850-4558 / 908-850-6062 |
| [ ] | Hours | Mon Closed · Tue – Sun 11:30 AM – 9:00 PM |
| [ ] | Ordering label (primary) | Order Online Now |
| [ ] | Ordering label (Grubhub) | Grubhub Order |
| [ ] | Ordering label (Seamless) | Seamless Order |

Notes on the exact forms above (so nothing is ambiguous when you compare against
the site):

- **Hours** uses a middle-dot separator ( · ) between the Monday and the
  Tue–Sun parts, en-dashes ( – ) in "Tue – Sun" and "11:30 AM – 9:00 PM", and a
  single space on both sides of each en-dash. This is the exact form confirmed
  against the live source szechuanroyalechinese.com during Plan 01 review. It
  appears identically on the contact page, in all three page footers, and in the
  fidelity smoke-check.
- **Phone** shows both numbers separated by a space, a slash, and a space.

---

## 2. Click-to-call & directions

- The phone on the contact page is a **tap-to-call** link. Tapping it dials
  **908-850-4558** (the first of the two listed numbers).
- The address on the contact page is a link that opens **Google Maps**
  directions to **470 Schooleys Mountain Rd., Hackettstown, NJ 07840** in a new
  tab.

| ✓ | Confirm |
|---|---------|
| [ ] | Tapping the phone dials 908-850-4558 |
| [ ] | Clicking the address opens Google Maps to the correct location |

---

## 3. Open fidelity exceptions — owner must confirm or reject

These two items were carried into this phase for your explicit decision. Please
confirm or reject each.

### 3a. Ordering listing swap (Grubhub / Seamless)

The source site's own Grubhub and Seamless links pointed at an **old listing**
(listing ID **402532**, an address written as "ste-3"). Those links were found to
be **dead — HTTP 410 Gone** (the source's own listings are retired). Under prior
authorization, they were swapped to the restaurant's **current live listings**
(listing ID **6858288**) at the **same address, 470 Schooleys Mountain Rd.**,
with marketing tracking parameters dropped. The visible button labels ("Grubhub
Order", "Seamless Order") are unchanged; only the destinations were updated to the
current live listings.

Current live ordering destinations now in use:

- Grubhub: `https://www.grubhub.com/restaurant/szechuan-royale-470-schooleys-mountain-rd-hackettstown/6858288`
- Seamless: `https://www.seamless.com/menu/szechuan-royale-470-schooleys-mountain-rd-hackettstown/6858288`

| ✓ | Decision |
|---|----------|
| [ ] | **Confirm** — these current live listings (6858288) are the ones I want customers to reach |
| [ ] | **Reject** — use different ordering links (specify below) |

If rejected, specify the correct ordering links: ______________________________

### 3b. Hero tagline (home page)

The home page hero shows this tagline:

> Szechuan & Chinese cuisine in Hackettstown, NJ.

It uses **verified facts only** (cuisine type + town) — no invented claims,
awards, or slogans.

| ✓ | Decision |
|---|----------|
| [ ] | **Confirm** — this tagline is acceptable as shown |
| [ ] | **Reject** — change the tagline (specify below) |

If rejected, specify the preferred tagline: ______________________________

---

## 4. Owner sign-off

By completing this block you confirm that every value in Section 1 is exact, that
the click-to-call and directions in Section 2 work, and that you have made a
decision on both exceptions in Section 3. **Until this block is completed, the
project blocker "owner final confirmation pending" remains open and the site is
not shippable.**

- Owner name: ______________________________
- Date: ______________________________
- [ ] I confirm every value above is exact and approve the site for shipping.

If any item is rejected, list the items to fix here instead of approving:

______________________________
______________________________
