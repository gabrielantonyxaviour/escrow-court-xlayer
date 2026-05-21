# Execution Packet

## Project
- Name: Escrow Court
- Track: X Layer Arena primary; Receipt Publisher can be broken out as Skills Arena if a live two-arena window reopens.
- One-line description: AI agents hire each other, dispute bad work, and enforce a signed release-or-refund verdict on X Layer.

## README Thesis
Autonomous agents cannot safely hire each other if payment is just a blind transfer. Escrow Court gives agents a tiny civil-court primitive: escrow funds, commit work evidence, dispute, sign an arbitrator verdict, verify it onchain, and publish a receipt bundle an AI judge can replay.

## Judging Criteria Mapping
- Technical novelty: Solidity dispute state machine plus onchain ECDSA verdict verification.
- Protocol depth: X Layer deployment path, Agentic Wallet address, OKX Agent Payments Protocol compatibility notes, receipt hashes.
- Demo clarity: one buyer, one seller, one arbitrator, one disputed research report.
- Anti-generic differentiation: not a dashboard and not a generic trading bot; the contract enforces the core mechanic.
- Reproducibility: `pnpm demo` and `forge test` run without Gabriel private fleet access.

## Demo Script
1. Show first screen: buyer, seller, arbitrator, escrow amount, evidence hash.
2. Run the local reproducer.
3. Show transaction/state log: job created, work submitted, dispute opened, verdict signed, escrow settled.
4. Open proof bundle: evidence hash, result hash, dispute hash, signature, receipt hash.
5. Explain X Layer deployment config and current blocker: Agentic Wallet has zero OKB/testnet OKB until faucet/wallet-connect funding succeeds.
6. If live deployment later works, replace local tx placeholders with X Layer explorer links.

## Video Script
"Escrow Court is a court for autonomous agents. The buyer agent escrows a payment for a risk report. The seller agent submits work, but the buyer disputes it and commits the evidence hash. The arbitrator agent signs a binary verdict. The smart contract verifies that signature onchain before releasing or refunding the escrow. Every transition becomes a receipt hash, so an AI judge can rerun the whole case from the repo without relying on private agent infrastructure. This is the missing trust primitive for agent-to-agent commerce on X Layer."

## Submission Fields Draft
- Project Name & One-Line Description: `Escrow Court - AI agents hire each other, dispute bad work, and enforce signed verdicts on X Layer.`
- Track: `X Layer Arena`
- Team Members & Contact: `Gabriel Antony Xaviour - solo builder - gabrielantony56@gmail.com`
- Agentic Wallet Address: `0x4150bc36f6c8f7fb5dd129cf3b88dc1babe06a61`
- GitHub Repository Link: `https://github.com/gabrielantonyxaviour/escrow-court-xlayer`.
- OnchainOS Usage: `Installed OKX OnchainOS skills; verified Agentic Wallet login/address; designed compatibility with OKX Agent Payments Protocol; live broadcast blocked by zero balance/faucet wallet-connect limitation.`
- Demo Video Link: pending.
- X Post Link: pending; opt-in only.

## Final Checklist
- [x] Public GitHub repo created; final push pending.
- [x] Foundry tests pass.
- [x] Reproducer writes `outputs/proof-bundle.json`.
- [x] Frontend builds.
- [x] Browser UI screenshot captured.
- [x] Polish gate attempted and result recorded.
- [x] Builder report written.
- [ ] No final submission or social post without explicit approval.
