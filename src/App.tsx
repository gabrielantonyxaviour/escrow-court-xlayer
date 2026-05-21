import {
  BadgeCheck,
  CircleDollarSign,
  Copy,
  FileCheck2,
  Gavel,
  GitBranch,
  RadioTower,
  ShieldCheck,
  TriangleAlert,
} from 'lucide-react';
import type { ReactNode } from 'react';
import proofBundle from './data/proof-bundle.json';

type ProofBundle = typeof proofBundle;

const bundle = proofBundle as ProofBundle;

const timeline = [
  {
    label: 'Escrow opened',
    actor: 'buyer',
    detail: 'Job funded and evidence committed before work began.',
    hash: bundle.hashes.evidenceHash,
    icon: CircleDollarSign,
  },
  {
    label: 'Work submitted',
    actor: 'seller',
    detail: 'Seller returned a report, then committed its result hash.',
    hash: bundle.hashes.resultHash,
    icon: FileCheck2,
  },
  {
    label: 'Dispute opened',
    actor: 'buyer',
    detail: 'Buyer challenged missing X Layer proof requirements.',
    hash: bundle.hashes.disputeHash,
    icon: TriangleAlert,
  },
  {
    label: 'Verdict settled',
    actor: 'arbitrator',
    detail: 'Signed refund verdict is ready for onchain verification.',
    hash: bundle.verdict.digest,
    icon: Gavel,
  },
];

export function App() {
  const copyPacket = async () => {
    await navigator.clipboard.writeText(
      [
        'Escrow Court',
        'AI agents hire each other, dispute bad work, and enforce signed verdicts on X Layer.',
        `Agentic Wallet: ${bundle.agents.buyer}`,
        `Receipt root: ${bundle.hashes.receiptRoot}`,
      ].join('\n'),
    );
  };

  return (
    <main className="shell">
      <section className="court-panel" aria-label="Escrow Court proof dashboard">
        <nav className="topbar" aria-label="Project">
          <div className="brand-lockup">
            <div className="brand-mark">
              <Gavel size={18} strokeWidth={2.2} />
            </div>
            <span>Escrow Court</span>
          </div>
          <div className="nav-pills">
            <a href="https://github.com/gabrielantonyxaviour/escrow-court-xlayer">GitHub</a>
            <a href="/proof-bundle.json">Proof JSON</a>
          </div>
        </nav>

        <div className="hero-grid">
          <section className="opening">
            <div className="eyebrow">
              <RadioTower size={15} />
              X Layer agent commerce
            </div>
            <h1>Agents can go to court.</h1>
            <p>
              Buyer, seller, and arbitrator agents run a release-or-refund dispute with committed
              evidence, signed verdicts, and receipt hashes an AI judge can replay.
            </p>
            <div className="action-row">
              <a className="primary-action" href="/proof-bundle.json">
                <FileCheck2 size={16} />
                View proof
              </a>
              <button className="ghost-action" type="button" onClick={copyPacket}>
                <Copy size={16} />
                Copy packet
              </button>
            </div>
          </section>

          <section className="case-file" aria-label="Current case">
            <div className="section-heading">
              <span>Case 001</span>
              <strong>Refund verdict</strong>
            </div>
            <div className="case-row">
              <span>Chain</span>
              <strong>
                {bundle.chain.name} · {bundle.chain.chainId}
              </strong>
            </div>
            <div className="case-row">
              <span>Contract</span>
              <strong>{bundle.contract.localName}</strong>
            </div>
            <div className="case-row warning">
              <span>Live status</span>
              <strong>Funding blocked</strong>
            </div>
            <div className="mini-meter" aria-label="Proof completeness">
              <span />
              <span />
              <span />
              <span />
              <span className="muted" />
            </div>
          </section>
        </div>

        <section className="timeline" aria-label="Escrow timeline">
          {timeline.map((item, index) => {
            const Icon = item.icon;
            return (
              <article className="timeline-card" key={item.label}>
                <div className="timeline-index">{String(index + 1).padStart(2, '0')}</div>
                <div className="timeline-icon">
                  <Icon size={18} />
                </div>
                <div>
                  <p className="timeline-actor">{item.actor}</p>
                  <h2>{item.label}</h2>
                  <p>{item.detail}</p>
                </div>
                <code>{shortHash(item.hash)}</code>
              </article>
            );
          })}
        </section>

        <section className="proof-grid" aria-label="Proof evidence">
          <EvidencePanel
            icon={<ShieldCheck size={18} />}
            title="Signed verdict"
            label="Arbitrator"
            value={shortAddress(bundle.verdict.signer)}
            detail={shortHash(bundle.verdict.signature)}
          />
          <EvidencePanel
            icon={<GitBranch size={18} />}
            title="Receipt chain"
            label="Root"
            value={shortHash(bundle.hashes.receiptRoot)}
            detail={`${bundle.receipts.length} linked receipts`}
          />
          <EvidencePanel
            icon={<BadgeCheck size={18} />}
            title="Judge replay"
            label="Command"
            value="pnpm demo"
            detail="No private fleet required"
          />
        </section>
      </section>
    </main>
  );
}

function EvidencePanel({
  detail,
  icon,
  label,
  title,
  value,
}: {
  detail: string;
  icon: ReactNode;
  label: string;
  title: string;
  value: string;
}) {
  return (
    <article className="evidence-panel">
      <div className="panel-icon">{icon}</div>
      <div>
        <p>{title}</p>
        <span>{label}</span>
      </div>
      <strong>{value}</strong>
      <code>{detail}</code>
    </article>
  );
}

function shortHash(value: string) {
  return `${value.slice(0, 10)}...${value.slice(-8)}`;
}

function shortAddress(value: string) {
  return `${value.slice(0, 6)}...${value.slice(-4)}`;
}
