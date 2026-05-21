# Plugin Plan

## Interpreted Scope
The Gabriel override says this is not a Build with MeDo run. Plugin reconnaissance is therefore mapped to OKX Plugin Store, OnchainOS skills, Uniswap AI Skills, x402/OKX Agent Payments Protocol, and local reusable skills.

## Managed Plugin / Skill Reconnaissance
- Official OKX Plugin Store page confirms a Build X hackathon agent-track plugin: `okx-buildx-hackathon-agent-track`.
- Official install command: `npx skills add okx/plugin-store --skill okx-buildx-hackathon-agent-track`.
- The plugin page says Build X used X Layer, OnchainOS, Uniswap, and Moltbook, with 14,000 USDT split across X Layer Arena and Skill Arena.
- Live skill discovery found:
  - `okx/onchainos-skills@okx-agent-payments-protocol`
  - `affaan-m/everything-claude-code@agent-payment-x402`
  - `aicoincom/coinos-skills@aicoin-onchain`
- Installed `okx/onchainos-skills` globally with `npx --yes skills add okx/onchainos-skills -g -y`. It installed 22 OKX skills, including `okx-agentic-wallet`, `okx-agent-payments-protocol`, `okx-dex-swap`, `okx-security`, `okx-audit-log`, and `okx-onchain-gateway`.

## Concrete Integration Path
- Primary: `okx-agentic-wallet`
  - Use as the authoritative wallet lane for Agentic Wallet address, status, balances, signing/broadcasting if funded.
  - Verified status: logged in as `gabrielantony56@gmail.com`, account `Account 1`, X Layer address `0x4150bc36f6c8f7fb5dd129cf3b88dc1babe06a61`.
- Primary: `okx-agent-payments-protocol`
  - Use as the documented x402 / OKX Agent Payments Protocol compatibility layer.
  - Escrow Court will not claim native OKX escrow support because OKX docs mark escrow payment as coming soon. The repo implements escrow directly in Solidity and maps payment-gated service requests to a proof/receipt schema.
- Secondary: `okx-dex-swap` and Uniswap AI Skills
  - Keep as optional non-team-funded counterparty proof: a DEX quote/swap leg can be added if wallet funding appears.
  - No swap will be executed without explicit approval and risk checks.
- Secondary: `okx-security`
  - Candidate for pre-broadcast transaction scan in a live deployment script.

## Custom Plugin / Skill Decision
- Build a repo-local reusable skill/package: `packages/receipt-publisher`.
- Purpose: transform escrow job events, signed verdicts, payment/denial/refund records, and local/live tx hashes into hash-chained JSON receipts and proof bundles.
- Why this is not decorative: Skills Arena and AI judges need a reusable artifact. Receipt Publisher is imported by the app and by the CLI reproducer; it is not a static UI feature.

## Local Skill Mapping
- `ethskills`: used for Solidity/EVM architecture, x402 standards context, and test discipline.
- `agent-browser`: used for profile-safe portal/GitHub/faucet reconnaissance.
- `ui-ux-launch-workflow`: used to set the UI direction and proof path.
- `polish`: mandatory final visual QA gate for the changed UI.
- `find-skills`: used to discover current OKX/x402 skills before locking the plan.

## Avoided Fake Integrations
- No MeDo app.
- No native OnchainOS escrow claim.
- No x402 live-payment claim until a command produces a paid response, transaction hash, or documented blocker.
- No DEX/Uniswap claim unless a live quote or transaction is produced.
