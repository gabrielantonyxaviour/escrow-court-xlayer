#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${XLAYER_RPC_URL:-}" ]]; then
  echo "XLAYER_RPC_URL is required" >&2
  exit 1
fi

if [[ -z "${XLAYER_PRIVATE_KEY:-}" ]]; then
  echo "XLAYER_PRIVATE_KEY is required and must not be committed" >&2
  exit 1
fi

forge create \
  --rpc-url "$XLAYER_RPC_URL" \
  --private-key "$XLAYER_PRIVATE_KEY" \
  contracts/EscrowCourt.sol:EscrowCourt
