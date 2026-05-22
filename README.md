# X Cup Escrow Court

World Cup prediction markets with AI-referee disputes and signed X Layer settlement proof.

X Cup Escrow Court is a narrow prediction-escrow primitive for the OKX Build X - X Cup hackathon. A fan agent opens a World Cup market, a counterparty stakes into it, disputed match outcomes are committed as evidence, and an AI referee signs a release-or-refund verdict that `EscrowCourt.sol` verifies before funds move.

## Live Deployment

- Network: X Layer Testnet (chain ID `1952`)
- `EscrowCourt`: [`0x21B42FA48eD4674D285A1Ac5F93e3FF3aE425408`](https://www.okx.com/web3/explorer/xlayer-test/address/0x21B42FA48eD4674D285A1Ac5F93e3FF3aE425408)
- Deploy tx: [`0x1d90e64fbb276320e0d26adf7d72c6c25ae38e08bc90079f2ff34f3913f8ba24`](https://www.okx.com/web3/explorer/xlayer-test/tx/0x1d90e64fbb276320e0d26adf7d72c6c25ae38e08bc90079f2ff34f3913f8ba24)

See [`DEPLOYMENTS.md`](./DEPLOYMENTS.md) for full reproduction commands.

## Why It Exists

World Cup attention is enormous, but most prediction products stop at a scoreboard UI. X Cup Escrow Court turns fan predictions into verifiable X Layer activity:

1. A fan agent escrows a match prediction stake and commits market terms.
2. A counterparty submits a settlement claim and commits its result hash.
3. The fan agent accepts or disputes.
4. An AI referee signs a binary verdict over the committed match evidence.
5. The contract verifies the signature onchain and settles funds.
6. Receipt Publisher emits a hash-chained proof bundle for judges.

## Repo Map

- `contracts/EscrowCourt.sol` - minimal prediction escrow/dispute/verdict contract.
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

## X Cup Fit

- Theme: World Cup prediction escrow.
- Tracks: prediction markets, AI Agent, social/fan traffic, X Layer on-chain settlement.
- Market loop: fans post match predictions, counterparties stake, disputed outcomes become signed AI-referee verdicts, receipts prove activity.
- Judging fit: innovation through dispute-resolved prediction markets, market potential through football fan traffic, completion through reproducible contracts/tests/proof JSON.

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
Public demo: `https://gabrielantonyxaviour.github.io/escrow-court-xlayer/`

X Cup form fields are mapped in `X_CUP_SUBMISSION_PACKET.md`, but no form was submitted. Dedicated X account creation, X post, demo video, and final form submit are intentionally pending because they require explicit approval.
