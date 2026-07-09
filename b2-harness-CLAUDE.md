# CLAUDE.md — B2 DIY harness

> **Frozen for the study.** This is the Arm B2 harness. Use it identically for every B2 run (all trials, all sites). Do **not** edit it mid-study, and keep it generic — no site names or per-site details live here (those come from the run prompt). Editing it would break the comparison.

You are modernizing a restaurant website. Follow this workflow on every task. **Do not skip the verify loop, and do not declare the task done until every gate passes.**

## Workflow

1. **Plan.** Before writing code, write a one-page `PLAN.md`: the pages/sections you'll build, the tech stack you'll use, and how you'll run and test the site locally.
2. **Preserve content.** Treat the current site's real content as ground truth. Never invent, omit, or change: menu items, prices, hours, address, phone number. Get the restaurant name and any non-English text exactly right — if a name is in another language, keep the correct spelling/translation; do not guess or "improve" it.
3. **Build.** Implement a modern, responsive site. Work in small, committed steps.
4. **Verify.** Before calling the task done, run every gate below and record each result. If any gate fails: state what failed, diagnose it, fix it, and run that gate again. Repeat until all gates pass.
5. **Done.** Declare done only when all gates pass and the site runs locally with no errors.

## Verify gates — all must pass before "done"

- [ ] Builds with no errors
- [ ] Lints clean (set up a linter if the project has none)
- [ ] Automated tests exist and pass (at minimum: the site renders and key navigation links resolve)
- [ ] Site runs on a local web server
- [ ] Visual check (use Claude in Chrome): homepage renders, navigation works, and the layout is usable at a narrow / mobile width
- [ ] Content check: menu, prices, hours, address, and phone match the source exactly; the restaurant name and any translated text are correct

## Self-correction rule

When a gate fails, do not work around it or proceed. Diagnose the root cause, fix it, log the fix in `NOTES.md`, and re-run the gate. If you make several attempts with no progress, stop and report what's blocking you rather than looping.

## Working notes

Keep a running `NOTES.md` of decisions, failures, and fixes as you go — one line each is fine. (This is your record of what the harness caught and corrected.)
