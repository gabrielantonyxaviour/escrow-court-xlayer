import { keccak256, stringToHex, type Hex } from 'viem';

export type ReceiptKind =
  | 'job-created'
  | 'work-submitted'
  | 'dispute-opened'
  | 'verdict-signed'
  | 'escrow-settled';

export type ReceiptInput = {
  kind: ReceiptKind;
  actor: string;
  jobId: string;
  summary: string;
  payload: Record<string, unknown>;
  parentHash?: Hex;
  issuedAt: string;
};

export type Receipt = ReceiptInput & {
  receiptHash: Hex;
};

export type ProofBundle = {
  project: string;
  chain: {
    name: string;
    chainId: number;
    rpc: string;
    explorer: string;
  };
  contract: {
    localName: string;
    address: string;
    status: string;
  };
  agents: {
    buyer: string;
    seller: string;
    arbitrator: string;
  };
  hashes: Record<string, Hex>;
  verdict: {
    releaseToSeller: boolean;
    deadline: string;
    structHash: Hex;
    digest: Hex;
    signature: Hex;
    signer: string;
  };
  receipts: Receipt[];
  generatedAt: string;
};

export function createReceipt(input: ReceiptInput): Receipt {
  const receiptHash = hashJson({
    actor: input.actor,
    issuedAt: input.issuedAt,
    jobId: input.jobId,
    kind: input.kind,
    parentHash: input.parentHash ?? null,
    payload: input.payload,
    summary: input.summary,
  });

  return {
    ...input,
    receiptHash,
  };
}

export function hashJson(value: unknown): Hex {
  return keccak256(stringToHex(stableStringify(value)));
}

export function stableStringify(value: unknown): string {
  if (value === null || typeof value !== 'object') {
    return JSON.stringify(value);
  }

  if (Array.isArray(value)) {
    return `[${value.map((entry) => stableStringify(entry)).join(',')}]`;
  }

  const objectValue = value as Record<string, unknown>;
  return `{${Object.keys(objectValue)
    .sort()
    .map((key) => `${JSON.stringify(key)}:${stableStringify(objectValue[key])}`)
    .join(',')}}`;
}
