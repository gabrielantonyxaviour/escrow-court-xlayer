# Escrow Court

AI agents hire each other, dispute bad work, and enforce signed release-or-refund verdicts on X Layer.

Escrow Court is a narrow agent-commerce primitive for the OKX/X Layer Build X style workflow. A buyer agent posts a paid job, a seller agent commits work evidence, the buyer can dispute, and an arbitrator agent signs a verdict that `EscrowCourt.sol` verifies before releasing or refunding escrow.

## Why It Exists

Agent payments need more than "send money to another bot." They need a way to prove what was requested, what was delivered, why it was disputed, and who authorized settlement. Escrow Court turns that into a tiny state machine:

1. Buyer escrows payment and commits an evidence hash.
2. Seller submits work and commits a result hash.
3. Buyer accepts or disputes.
4. Arbitrator signs a binary verdict.
5. Contract verifies the signature onchain and settles funds.
6. Receipt Publisher emits a hash-chained proof bundle.

## Repo Map

- `contracts/EscrowCourt.sol` - minimal escrow/dispute/verdict contract.
- `test/EscrowCourt.t.sol` - Foundry coverage for happy path, refund path, signature failures, and contract-buyer refunds.
- `packages/receipt-publisher` - reusable receipt/proof hash package.
- `scripts/demo.ts` - public reproducer that generates `outputs/proof-bundle.json`.
- `src/` - Vite React proof dashboard.
- `BUILD_PLAN.md`, `PLUGIN_PLAN.md`, `BACKEND_PLAN.md`, `EXECUTION_PACKET.md` - submission packet.

## Run It

```bash
pnpm install
pnpm test
pnpm dev
```

Useful individual checks:

```bash
forge test -vvv
pnpm demo
pnpm build
```

The local app runs at `http://127.0.0.1:5174/` in the current execution environment.

## X Layer Integration

- Target mainnet chain ID: `196`
- Target testnet chain ID: `1952`
- Testnet RPC: `https://testrpc.xlayer.tech/terigon`
- Testnet explorer: `https://www.okx.com/web3/explorer/xlayer-test`
- Agentic Wallet address verified through OnchainOS: `0x4150bc36f6c8f7fb5dd129cf3b88dc1babe06a61`

Current live deployment status: blocked by zero X Layer and X Layer testnet balance. The official faucet page was reachable but required a browser wallet connection and did not accept the Agentic Wallet CLI address directly.

## OKX / OnchainOS Usage

Installed and inspected OKX OnchainOS skills:

- `okx-agentic-wallet` - verified login, address, and balances.
- `okx-agent-payments-protocol` - documented compatibility with OKX Agent Payments Protocol/x402 patterns.
- `okx-dex-swap` - optional non-team-funded counterparty leg if wallet funding appears.
- `okx-security` - candidate for pre-broadcast scans.

Escrow Court does not claim native OKX escrow support. The escrow/dispute mechanic is implemented directly in Solidity because the council research found native escrow/payment futures should not be overclaimed without live proof.

## Submission Status

Public repo: `https://github.com/gabrielantonyxaviour/escrow-court-xlayer`

Build X form fields are mapped in `SUBMISSION_PORTAL_PLAN.md`, but no form was submitted. Demo video and X post are intentionally pending because they require explicit approval.
