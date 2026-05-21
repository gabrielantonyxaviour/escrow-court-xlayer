# Build Plan

## Product
Escrow Court is an agent-to-agent commerce primitive on X Layer. A buyer agent posts a paid job, a seller agent commits work evidence, the buyer can accept or dispute, and an arbitrator agent signs a binary release-or-refund verdict that the contract verifies onchain.

## G0 Status
- G0.a live event: blocked for active prize-window certainty. Official Build X page says `Event ended`, current season `Apr 1, 23:59 - Apr 15, 23:59 UTC`. X-Agent page says `May 11-18`; the current date is 2026-05-21.
- G0.b two arenas: official Build X page lists X Layer Arena and Skills Arena as separate arenas, but no live current window was confirmed.
- G0.c side bounties: Build X page lists X Layer active-agent and popularity prizes plus Skills Arena best Uniswap integration and popularity prizes. No current stackable side-bounty window was confirmed for May 21, 2026.
- Execution stance: continue as a portfolio/submission-ready OKX primitive with honest blockers, not as a final-submitted live prize entry.

## Stack
- Solidity + Foundry for `EscrowCourt.sol` and tests.
- TypeScript + Vite + React for the demo app.
- Node scripts for public reproducer and proof bundle generation.
- Viem for EVM address/signature utilities in the demo.
- OKX OnchainOS skills installed for wallet, payment, DEX, and security references.

## Contract Scope
- `createJob(seller, arbitrator, evidenceHash, metadataURI)` payable.
- `submitWork(jobId, resultHash, resultURI)` by seller.
- `accept(jobId)` by buyer releases escrow to seller.
- `dispute(jobId, disputeHash)` by buyer.
- `resolve(jobId, releaseToSeller, verdictURI, deadline, signature)` verifies arbitrator ECDSA over a typed digest and releases/refunds.
- Commit-before-resolve rule: `evidenceHash` and `resultHash` must be present before dispute resolution.
- Events are first-class: every state transition emits enough data for the UI and receipt publisher.

## Demo Flow
1. Buyer agent creates a `risk-report` job with tiny escrow.
2. Seller agent submits a deliberately weak report and commits its result hash.
3. Buyer disputes with a dispute hash.
4. Arbitrator signs a verdict struct over `jobId`, evidence hash, result hash, dispute hash, decision, deadline, and contract address.
5. Contract verifies signature and refunds/release funds.
6. Receipt publisher writes a JSON proof bundle with job hashes, state transitions, arbitrator signature, and explorer/local transaction placeholders.

## Milestones
- T0 planning packet: TEAM, BUILD_PLAN, PLUGIN_PLAN, BACKEND_PLAN, UI_TEMPLATE_PLAN, REPO_PLAN, SUBMISSION_PORTAL_PLAN, EXECUTION_PACKET, PROGRESS.
- T1 contracts: EscrowCourt + Foundry tests.
- T2 public reproducer: scripted buyer/seller/arbitrator proof bundle.
- T3 UI: first-screen judge moment with state-machine timeline, evidence hash, signature, and transaction/proof links.
- T4 packaging: README, repo, report, submission field map.
- T5 verification: `forge test`, TypeScript tests/build, browser UI screenshots, report.

## Live Chain Strategy
- X Layer mainnet: chain ID `196`, RPC `https://rpc.xlayer.tech`, explorer `https://www.okx.com/web3/explorer/xlayer`.
- X Layer testnet: chain ID `1952`, RPC `https://testrpc.xlayer.tech/terigon`, explorer `https://www.okx.com/web3/explorer/xlayer-test`.
- Gabriel Agentic Wallet address: `0x4150bc36f6c8f7fb5dd129cf3b88dc1babe06a61`.
- Current OnchainOS balance on X Layer and testnet is `0.00`; live deployment waits on funding/faucet access.

## Fallback
- If live deployment remains blocked, the repo still ships Foundry local proof and a deployment script configured for X Layer.
- If signed-verdict verification fails, fallback is Standoff Co-Signer. Current contract plan avoids that by making signature verification the first hard contract test.
