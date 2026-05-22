# Deployments

Date: 2026-05-22

## X Layer Testnet (chain ID 1952)

| Item | Value |
|---|---|
| Network | X Layer Testnet (Terigon) |
| Chain ID | `1952` |
| RPC | `https://testrpc.xlayer.tech/terigon` |
| Explorer | `https://www.okx.com/web3/explorer/xlayer-test` |
| Deployer | `0xBc25F65EC030f2A889556c92d2A2D91612Dd1F66` |

### Deployed Contracts

| Contract | Address | Tx Hash |
|---|---|---|
| `EscrowCourt` | `0x21B42FA48eD4674D285A1Ac5F93e3FF3aE425408` | `0x1d90e64fbb276320e0d26adf7d72c6c25ae38e08bc90079f2ff34f3913f8ba24` |

### Verification

`eth_getCode` returned 10,774 bytes for `EscrowCourt`. Contract is live and queryable via the explorer above.

## Reproduce Deployment

```bash
export XLAYER_RPC_URL=https://testrpc.xlayer.tech/terigon
export XLAYER_PRIVATE_KEY=<funded testnet private key>

forge create \
  --rpc-url "$XLAYER_RPC_URL" \
  --private-key "$XLAYER_PRIVATE_KEY" \
  --broadcast \
  contracts/EscrowCourt.sol:EscrowCourt
```

## X Layer Mainnet

Status: not attempted. Hackathon submission is testnet-only.
