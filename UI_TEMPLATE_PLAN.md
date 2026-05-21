# UI Template Plan

## Template Sources Read
- `/Users/gabrielantonyxaviour/Documents/templates/INDEX.md`
- `/Users/gabrielantonyxaviour/Documents/templates/.motionsites-prompts/saas-software.md`
- `/Users/gabrielantonyxaviour/Documents/templates/.motionsites-prompts/securify-data-security.md`
- `/Users/gabrielantonyxaviour/Documents/templates/.motionsites-prompts/ai-workflow-hero.md`

## Selected Inspiration
- Primary structure: `saas-software` dashboard preview pattern.
  - Use the centered operational tray and compact dense panels for judge-scannable state.
  - Adapt the gauge/card idea into verdict confidence, escrow status, and proof completeness modules.
- Visual tone: `securify-data-security` high-contrast security SaaS.
  - Use stark black/white/neutral foundation with one controlled signal color.
  - Avoid generic AI blue/purple gradients.
- Interaction pattern: `ai-workflow-hero`.
  - First screen should feel like a live workflow replay, not a marketing hero.

## First-Screen Judge Moment
The first viewport shows the whole case in one pass:
- Left: "Escrow Court" title and one-line thesis.
- Center: four-step court timeline: escrow opened -> work submitted -> buyer disputed -> signed verdict settled.
- Right: proof panel with evidence hash, arbitrator signature status, receipt hash, wallet address, and X Layer readiness.
- Primary actions: `Run local proof`, `View contract`, `Copy submission packet` as real commands/links where possible.

## Visual Rules
- Build the actual usable demo surface, not a landing page.
- No feature-card grid, no bento section, no stat-card hero.
- Cards only for individual evidence modules; no cards nested inside cards.
- Stable dimensions for timeline nodes, proof rows, and buttons to avoid layout shift.
- Use lucide icons for states/actions.
- Use realistic representative data from the generated proof bundle.
- Wallet UI should use a real chain/token logo if balance is shown.
- Text must fit at 375, 768, and 1440 widths.

## Proof Path
- Use Codex in-app/public browser or Playwright-style screenshots for local UI.
- Run `/polish` after implementation. If M2 routing is unavailable, record the blocker and still capture a local browser screenshot for sanity, without claiming the Polish Gate passed.
