# Backend Plan

## Interpreted Scope
The execution override maps "backend services" to the actual product backend: Solidity contracts, local proof generation, OnchainOS wallet/payment integration, and a typed app data layer. No MeDo backend services are used.

## Data Storage
- Onchain contract storage:
  - `Job`: buyer, seller, arbitrator, amount, status, evidence hash, result hash, dispute hash, verdict hash, timestamps.
  - Native escrow balance held by `EscrowCourt`.
- Offchain repo/demo storage:
  - `data/demo-scenario.json`: deterministic scripted buyer/seller/arbitrator scenario.
  - `outputs/proof-bundle.json`: generated proof bundle from the reproducer.
  - `outputs/receipts/*.json`: hash-chained receipts from the receipt publisher.
- UI data:
  - Reads static generated proof bundle for local demo.
  - Later can read contract events from X Layer RPC.

## User Management
- No login for the public demo.
- Agents are represented by EVM addresses and labels: Buyer Agent, Seller Agent, Arbitrator Agent.
- Gabriel's Agentic Wallet is recorded as the submitter wallet for form readiness but is not used for live fund-moving actions without funding/approval.

## Backend Functions
- `scripts/demo.ts`: deploy or connect, run local scripted agents, create/dispute/resolve a job, and write proof bundle.
- `packages/receipt-publisher`: canonical receipt hashing, parent hash chaining, proof bundle serialization.
- `scripts/deploy-xlayer.ts`: deploy to X Layer mainnet/testnet when funded.
- Optional `scripts/onchainos-preflight.ts`: records Agentic Wallet status and balance as evidence.

## Smart Contracts
- `contracts/EscrowCourt.sol`: minimal escrow/dispute/verdict state machine.
- `test/EscrowCourt.t.sol`: Foundry unit tests and edge cases.

## Secrets
- No private keys, OTPs, cookies, API keys, or wallet credentials are committed.
- Live deployment supports:
  - `XLAYER_RPC_URL`
  - `XLAYER_PRIVATE_KEY` only in local `.env`, never committed.
  - Optional `ONCHAINOS_API_KEY` if a live API key is later available.
- `.env` must be in `.gitignore`.

## Current Live Backend Evidence
- `onchainos --version`: `3.3.6`, checksum matched `onchainos-aarch64-apple-darwin`.
- `onchainos wallet status`: logged in as `gabrielantony56@gmail.com`, one account.
- X Layer address: `0x4150bc36f6c8f7fb5dd129cf3b88dc1babe06a61`.
- X Layer and X Layer testnet balances: `0.00`.
- OKX faucet page was opened in Gabriel profile; faucet requires browser wallet connection and did not accept the Agentic Wallet CLI address directly.

## Done-When
- Local contracts and proof generation pass.
- Live deployment is attempted only after wallet/faucet funding exists.
- If live deployment remains blocked, blocker is recorded exactly with zero live-chain overclaiming.
