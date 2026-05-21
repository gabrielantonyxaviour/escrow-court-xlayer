// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract EscrowCourt {
  enum Status {
    None,
    Open,
    WorkSubmitted,
    Accepted,
    Disputed,
    Resolved
  }

  struct Job {
    address buyer;
    address seller;
    address arbitrator;
    uint256 amount;
    bytes32 evidenceHash;
    bytes32 resultHash;
    bytes32 disputeHash;
    bytes32 verdictHash;
    uint64 createdAt;
    uint64 submittedAt;
    Status status;
    bool releasedToSeller;
    string metadataURI;
    string resultURI;
    string verdictURI;
  }

  error InvalidAddress();
  error InvalidAmount();
  error InvalidHash();
  error InvalidStatus(Status current);
  error NotBuyer();
  error NotSeller();
  error VerdictExpired();
  error BadSignature();
  error TransferFailed();

  bytes32 public constant VERDICT_TYPEHASH = keccak256(
    "EscrowCourtVerdict(address court,uint256 chainId,uint256 jobId,address buyer,address seller,address arbitrator,uint256 amount,bytes32 evidenceHash,bytes32 resultHash,bytes32 disputeHash,bool releaseToSeller,bytes32 verdictURIHash,uint256 deadline)"
  );

  uint256 public nextJobId = 1;
  mapping(uint256 => Job) private jobs;

  event JobCreated(
    uint256 indexed jobId,
    address indexed buyer,
    address indexed seller,
    address arbitrator,
    uint256 amount,
    bytes32 evidenceHash,
    string metadataURI
  );
  event WorkSubmitted(uint256 indexed jobId, bytes32 resultHash, string resultURI);
  event JobAccepted(uint256 indexed jobId, uint256 amountReleased);
  event JobDisputed(uint256 indexed jobId, bytes32 disputeHash);
  event JobResolved(
    uint256 indexed jobId,
    bool releaseToSeller,
    bytes32 verdictHash,
    string verdictURI
  );

  function createJob(
    address seller,
    address arbitrator,
    bytes32 evidenceHash,
    string calldata metadataURI
  ) external payable returns (uint256 jobId) {
    if (seller == address(0) || arbitrator == address(0)) revert InvalidAddress();
    if (seller == msg.sender || arbitrator == msg.sender || seller == arbitrator) {
      revert InvalidAddress();
    }
    if (msg.value == 0) revert InvalidAmount();
    if (evidenceHash == bytes32(0)) revert InvalidHash();

    jobId = nextJobId++;
    jobs[jobId] = Job({
      buyer: msg.sender,
      seller: seller,
      arbitrator: arbitrator,
      amount: msg.value,
      evidenceHash: evidenceHash,
      resultHash: bytes32(0),
      disputeHash: bytes32(0),
      verdictHash: bytes32(0),
      createdAt: uint64(block.timestamp),
      submittedAt: 0,
      status: Status.Open,
      releasedToSeller: false,
      metadataURI: metadataURI,
      resultURI: "",
      verdictURI: ""
    });

    emit JobCreated(jobId, msg.sender, seller, arbitrator, msg.value, evidenceHash, metadataURI);
  }

  function submitWork(uint256 jobId, bytes32 resultHash, string calldata resultURI) external {
    Job storage job = jobs[jobId];
    if (job.status != Status.Open) revert InvalidStatus(job.status);
    if (msg.sender != job.seller) revert NotSeller();
    if (resultHash == bytes32(0)) revert InvalidHash();

    job.resultHash = resultHash;
    job.resultURI = resultURI;
    job.submittedAt = uint64(block.timestamp);
    job.status = Status.WorkSubmitted;

    emit WorkSubmitted(jobId, resultHash, resultURI);
  }

  function accept(uint256 jobId) external {
    Job storage job = jobs[jobId];
    if (job.status != Status.WorkSubmitted) revert InvalidStatus(job.status);
    if (msg.sender != job.buyer) revert NotBuyer();

    uint256 amount = job.amount;
    job.status = Status.Accepted;
    job.releasedToSeller = true;
    job.amount = 0;

    _send(job.seller, amount);
    emit JobAccepted(jobId, amount);
  }

  function dispute(uint256 jobId, bytes32 disputeHash) external {
    Job storage job = jobs[jobId];
    if (job.status != Status.WorkSubmitted) revert InvalidStatus(job.status);
    if (msg.sender != job.buyer) revert NotBuyer();
    if (disputeHash == bytes32(0)) revert InvalidHash();

    job.disputeHash = disputeHash;
    job.status = Status.Disputed;

    emit JobDisputed(jobId, disputeHash);
  }

  function resolve(
    uint256 jobId,
    bool releaseToSeller,
    string calldata verdictURI,
    uint256 deadline,
    bytes calldata arbitratorSignature
  ) external {
    Job storage job = jobs[jobId];
    if (job.status != Status.Disputed) revert InvalidStatus(job.status);
    if (block.timestamp > deadline) revert VerdictExpired();

    bytes32 digest = verdictDigest(jobId, releaseToSeller, verdictURI, deadline);
    if (_recover(digest, arbitratorSignature) != job.arbitrator) revert BadSignature();

    uint256 amount = job.amount;
    address recipient = releaseToSeller ? job.seller : job.buyer;
    job.status = Status.Resolved;
    job.releasedToSeller = releaseToSeller;
    job.amount = 0;
    job.verdictURI = verdictURI;
    job.verdictHash = keccak256(abi.encodePacked(verdictURI));

    _send(recipient, amount);
    emit JobResolved(jobId, releaseToSeller, job.verdictHash, verdictURI);
  }

  function getJob(uint256 jobId) external view returns (Job memory) {
    return jobs[jobId];
  }

  function verdictDigest(
    uint256 jobId,
    bool releaseToSeller,
    string memory verdictURI,
    uint256 deadline
  ) public view returns (bytes32) {
    Job storage job = jobs[jobId];
    bytes32 structHash = keccak256(
      abi.encode(
        VERDICT_TYPEHASH,
        address(this),
        block.chainid,
        jobId,
        job.buyer,
        job.seller,
        job.arbitrator,
        job.amount,
        job.evidenceHash,
        job.resultHash,
        job.disputeHash,
        releaseToSeller,
        keccak256(bytes(verdictURI)),
        deadline
      )
    );
    return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", structHash));
  }

  function _send(address to, uint256 amount) private {
    (bool ok, ) = payable(to).call{ value: amount }("");
    if (!ok) revert TransferFailed();
  }

  function _recover(bytes32 digest, bytes calldata signature) private pure returns (address) {
    if (signature.length != 65) revert BadSignature();
    bytes32 r;
    bytes32 s;
    uint8 v;
    assembly {
      r := calldataload(signature.offset)
      s := calldataload(add(signature.offset, 32))
      v := byte(0, calldataload(add(signature.offset, 64)))
    }
    if (v < 27) v += 27;
    if (v != 27 && v != 28) revert BadSignature();
    address signer = ecrecover(digest, v, r, s);
    if (signer == address(0)) revert BadSignature();
    return signer;
  }
}
