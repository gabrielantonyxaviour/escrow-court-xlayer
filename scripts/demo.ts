import { mkdirSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import {
  encodeAbiParameters,
  hashMessage,
  keccak256,
  parseAbiParameters,
  stringToHex,
  toBytes,
  type Hex,
} from 'viem';
import { privateKeyToAccount } from 'viem/accounts';
import { createReceipt, hashJson, type ProofBundle, type Receipt } from '../packages/receipt-publisher/src/index';

const buyer = privateKeyToAccount(
  '0x00000000000000000000000000000000000000000000000000000000000a11ce',
);
const seller = privateKeyToAccount(
  '0x0000000000000000000000000000000000000000000000000000000000000b0b',
);
const arbitrator = privateKeyToAccount(
  '0x000000000000000000000000000000000000000000000000000000000000cafe',
);

const courtAddress = '0x1111111111111111111111111111111111111960';
const chainId = 1952n;
const jobId = 1n;
const amount = 10000000000000000n;
const releaseToSeller = false;
const deadline = 1_798_761_600n;
const verdictURI = 'ipfs://escrow-court/verdict-refund.json';

const verdictTypehash = keccak256(
  stringToHex(
    'EscrowCourtVerdict(address court,uint256 chainId,uint256 jobId,address buyer,address seller,address arbitrator,uint256 amount,bytes32 evidenceHash,bytes32 resultHash,bytes32 disputeHash,bool releaseToSeller,bytes32 verdictURIHash,uint256 deadline)',
  ),
);

const evidence = {
  job: 'token-risk-report',
  buyerRequest: 'Summarize X Layer agent-commerce risks and cite onchain proof requirements.',
  requiredSections: ['risk model', 'sponsor fit', 'evidence links'],
};

const result = {
  sellerOutput: 'Generic token report with missing X Layer evidence and no receipt links.',
  quality: 'insufficient',
};

const dispute = {
  reason: 'Seller missed X Layer-specific proof requirements.',
  requestedOutcome: 'refund',
};

const evidenceHash = hashJson(evidence);
const resultHash = hashJson(result);
const disputeHash = hashJson(dispute);

const structHash = keccak256(
  encodeAbiParameters(
    parseAbiParameters(
      'bytes32,address,uint256,uint256,address,address,address,uint256,bytes32,bytes32,bytes32,bool,bytes32,uint256',
    ),
    [
      verdictTypehash,
      courtAddress,
      chainId,
      jobId,
      buyer.address,
      seller.address,
      arbitrator.address,
      amount,
      evidenceHash,
      resultHash,
      disputeHash,
      releaseToSeller,
      keccak256(stringToHex(verdictURI)),
      deadline,
    ],
  ),
);

const digest = hashMessage({ raw: toBytes(structHash) });
const signature = await arbitrator.signMessage({ message: { raw: toBytes(structHash) } });

const issuedAt = '2026-05-21T00:44:00.000Z';
const receipts: Receipt[] = [];

function appendReceipt(input: Omit<Parameters<typeof createReceipt>[0], 'parentHash'>) {
  const parentHash = receipts.at(-1)?.receiptHash;
  const receipt = createReceipt({ ...input, parentHash });
  receipts.push(receipt);
}

appendReceipt({
  actor: buyer.address,
  issuedAt,
  jobId: jobId.toString(),
  kind: 'job-created',
  summary: 'Buyer escrowed a risk-report job and committed evidence before work began.',
  payload: { amount: amount.toString(), evidenceHash },
});

appendReceipt({
  actor: seller.address,
  issuedAt,
  jobId: jobId.toString(),
  kind: 'work-submitted',
  summary: 'Seller submitted weak work with a committed result hash.',
  payload: { resultHash, resultURI: 'ipfs://escrow-court/result-bad.json' },
});

appendReceipt({
  actor: buyer.address,
  issuedAt,
  jobId: jobId.toString(),
  kind: 'dispute-opened',
  summary: 'Buyer disputed the result and committed a dispute hash.',
  payload: { disputeHash },
});

appendReceipt({
  actor: arbitrator.address,
  issuedAt,
  jobId: jobId.toString(),
  kind: 'verdict-signed',
  summary: 'Arbitrator signed a refund verdict over the committed evidence bundle.',
  payload: { digest, signature, releaseToSeller },
});

appendReceipt({
  actor: courtAddress,
  issuedAt,
  jobId: jobId.toString(),
  kind: 'escrow-settled',
  summary: 'Escrow settled as refund after onchain signature verification.',
  payload: { recipient: buyer.address, localProofOnly: true },
});

const bundle: ProofBundle = {
  project: 'Escrow Court',
  chain: {
    name: 'X Layer testnet',
    chainId: Number(chainId),
    rpc: 'https://testrpc.xlayer.tech/terigon',
    explorer: 'https://www.okx.com/web3/explorer/xlayer-test',
  },
  contract: {
    localName: 'EscrowCourt',
    address: courtAddress,
    status: 'local deterministic proof; live deployment blocked by zero funded Agentic Wallet balance',
  },
  agents: {
    buyer: buyer.address,
    seller: seller.address,
    arbitrator: arbitrator.address,
  },
  hashes: {
    evidenceHash,
    resultHash,
    disputeHash,
    receiptRoot: receipts.at(-1)?.receiptHash as Hex,
  },
  verdict: {
    releaseToSeller,
    deadline: deadline.toString(),
    structHash,
    digest,
    signature,
    signer: arbitrator.address,
  },
  receipts,
  generatedAt: issuedAt,
};

writeJson('outputs/proof-bundle.json', bundle);
writeJson('public/proof-bundle.json', bundle);
writeJson('src/data/proof-bundle.json', bundle);

process.stdout.write(
  [
    `proof bundle: outputs/proof-bundle.json`,
    `receipt root: ${bundle.hashes.receiptRoot}`,
    `arbitrator: ${bundle.verdict.signer}`,
  ].join('\n') + '\n',
);

function writeJson(path: string, value: unknown) {
  const absolute = join(process.cwd(), path);
  mkdirSync(dirname(absolute), { recursive: true });
  writeFileSync(absolute, `${JSON.stringify(value, null, 2)}\n`);
}
