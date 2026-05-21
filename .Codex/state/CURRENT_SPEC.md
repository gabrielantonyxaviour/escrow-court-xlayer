# Current Spec: Escrow Court

## Goal
Build a public, reproducible X Layer hackathon project named Escrow Court: AI agents hire each other, escrow payment, dispute bad work, and settle a signed arbitrator verdict through a Solidity state machine.

## Decided
- Primary submitter and repo owner: Gabriel, Chrome dir `Default`, Chrome profile `Gabriel`, email `gabrielantony56@gmail.com`.
- This is an OKX/X Layer Build X style execution, not a Build with MeDo project.
- Scope is one job type, one buyer, one seller, one arbitrator, one binary release-or-refund dispute path.
- V1 contract must commit the evidence bundle hash before arbitrator resolution and verify the arbitrator signed verdict onchain.
- Public reproducer must run from this repo without Gabriel private fleet dependencies.

## Open
- G0.a: confirm whether a current Build X / X Cup submission window is accepting entries on May 21, 2026.
- G0.b: confirm whether separate X Layer Arena and Skills Arena submissions are allowed.
- G0.c: confirm live/stackable side bounties such as Uniswap.
- Live X Layer deployment depends on faucet funds/RPC/wallet access; local Foundry proof ships regardless.

## Out Of Scope
- MeDo app generation.
- Final submission, legal attestations, social posting, or irreversible account actions without explicit Gabriel approval.
- Generalized marketplace, multi-arbitrator court, staking/slashing, reputation scoring, and native x402 escrow claims unless live docs and transactions prove them.

## Done When
- Required planning docs exist: TEAM, BUILD_PLAN, PLUGIN_PLAN, BACKEND_PLAN, UI_TEMPLATE_PLAN, REPO_PLAN, SUBMISSION_PORTAL_PLAN, EXECUTION_PACKET.
- Contracts, scripted agents, receipt publisher, frontend demo, and README exist.
- Foundry tests prove happy path, dispute/refund path, signature failure, evidence-hash mismatch, and refund receiver behavior.
- App builds and a browser UI check is recorded.
- Builder report is written to `outputs/builder-report.md` with repo, portal, plugin/backend, UI/template, build, blockers, and next actions.
