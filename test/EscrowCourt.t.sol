// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { EscrowCourt } from "../contracts/EscrowCourt.sol";

interface Vm {
  function addr(uint256 privateKey) external returns (address);
  function deal(address account, uint256 newBalance) external;
  function expectRevert(bytes4 selector) external;
  function prank(address sender) external;
  function sign(uint256 privateKey, bytes32 digest) external returns (uint8 v, bytes32 r, bytes32 s);
}

contract BuyerHarness {
  EscrowCourt private immutable court;

  constructor(EscrowCourt court_) {
    court = court_;
  }

  function createJob(
    address seller,
    address arbitrator,
    bytes32 evidenceHash,
    string calldata metadataURI
  ) external payable returns (uint256) {
    return court.createJob{ value: msg.value }(seller, arbitrator, evidenceHash, metadataURI);
  }

  function accept(uint256 jobId) external {
    court.accept(jobId);
  }

  function dispute(uint256 jobId, bytes32 disputeHash) external {
    court.dispute(jobId, disputeHash);
  }

  receive() external payable {}
}

contract EscrowCourtTest {
  Vm private constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

  uint256 private constant BUYER_PK = 0xA11CE;
  uint256 private constant SELLER_PK = 0xB0B;
  uint256 private constant ARBITRATOR_PK = 0xCAFE;
  uint256 private constant STRANGER_PK = 0xBAD;

  EscrowCourt private court;
  address private buyer;
  address private seller;
  address private arbitrator;
  address private stranger;

  receive() external payable {}

  function setUp() public {
    court = new EscrowCourt();
    buyer = vm.addr(BUYER_PK);
    seller = vm.addr(SELLER_PK);
    arbitrator = vm.addr(ARBITRATOR_PK);
    stranger = vm.addr(STRANGER_PK);
    vm.deal(buyer, 10 ether);
    vm.deal(seller, 1 ether);
  }

  function testAcceptReleasesEscrowToSeller() public {
    uint256 jobId = _createJob(buyer, seller, arbitrator, 1 ether);

    vm.prank(seller);
    court.submitWork(jobId, _hash("good work"), "ipfs://result-good");

    uint256 beforeBalance = seller.balance;
    vm.prank(buyer);
    court.accept(jobId);

    EscrowCourt.Job memory job = court.getJob(jobId);
    _assertEq(uint256(job.status), uint256(EscrowCourt.Status.Accepted), "accepted status");
    _assertTrue(job.releasedToSeller, "released to seller");
    _assertEq(seller.balance, beforeBalance + 1 ether, "seller paid");
  }

  function testResolveRefundsBuyerWithSignedVerdict() public {
    uint256 jobId = _createDisputedJob(buyer);
    bytes memory signature = _signVerdict(jobId, false, "ipfs://verdict-refund", block.timestamp + 1 days);

    uint256 beforeBalance = buyer.balance;
    court.resolve(jobId, false, "ipfs://verdict-refund", block.timestamp + 1 days, signature);

    EscrowCourt.Job memory job = court.getJob(jobId);
    _assertEq(uint256(job.status), uint256(EscrowCourt.Status.Resolved), "resolved status");
    _assertTrue(!job.releasedToSeller, "refunded buyer");
    _assertEq(buyer.balance, beforeBalance + 1 ether, "buyer refunded");
  }

  function testRejectsWrongArbitratorSignature() public {
    uint256 jobId = _createDisputedJob(buyer);
    bytes32 digest = court.verdictDigest(jobId, false, "ipfs://verdict-refund", block.timestamp + 1 days);
    (uint8 v, bytes32 r, bytes32 s) = vm.sign(STRANGER_PK, digest);

    vm.expectRevert(EscrowCourt.BadSignature.selector);
    court.resolve(jobId, false, "ipfs://verdict-refund", block.timestamp + 1 days, abi.encodePacked(r, s, v));
  }

  function testRejectsMismatchedVerdictPayload() public {
    uint256 jobId = _createDisputedJob(buyer);
    bytes memory signature = _signVerdict(jobId, false, "ipfs://verdict-refund", block.timestamp + 1 days);

    vm.expectRevert(EscrowCourt.BadSignature.selector);
    court.resolve(jobId, true, "ipfs://verdict-release", block.timestamp + 1 days, signature);
  }

  function testContractBuyerCanReceiveRefund() public {
    BuyerHarness harness = new BuyerHarness(court);
    vm.deal(address(harness), 2 ether);

    uint256 jobId = harness.createJob{ value: 1 ether }(
      seller,
      arbitrator,
      _hash("evidence"),
      "ipfs://job"
    );

    vm.prank(seller);
    court.submitWork(jobId, _hash("bad work"), "ipfs://result-bad");
    harness.dispute(jobId, _hash("dispute"));

    uint256 beforeBalance = address(harness).balance;
    bytes memory signature = _signVerdict(jobId, false, "ipfs://verdict-refund", block.timestamp + 1 days);
    court.resolve(jobId, false, "ipfs://verdict-refund", block.timestamp + 1 days, signature);

    _assertEq(address(harness).balance, beforeBalance + 1 ether, "harness received refund");
  }

  function _createDisputedJob(address buyerAddress) private returns (uint256 jobId) {
    jobId = _createJob(buyerAddress, seller, arbitrator, 1 ether);
    vm.prank(seller);
    court.submitWork(jobId, _hash("bad work"), "ipfs://result-bad");
    vm.prank(buyerAddress);
    court.dispute(jobId, _hash("dispute"));
  }

  function _createJob(
    address buyerAddress,
    address sellerAddress,
    address arbitratorAddress,
    uint256 amount
  ) private returns (uint256) {
    vm.prank(buyerAddress);
    return court.createJob{ value: amount }(
      sellerAddress,
      arbitratorAddress,
      _hash("evidence"),
      "ipfs://job"
    );
  }

  function _signVerdict(
    uint256 jobId,
    bool releaseToSeller,
    string memory verdictURI,
    uint256 deadline
  ) private returns (bytes memory) {
    bytes32 digest = court.verdictDigest(jobId, releaseToSeller, verdictURI, deadline);
    (uint8 v, bytes32 r, bytes32 s) = vm.sign(ARBITRATOR_PK, digest);
    return abi.encodePacked(r, s, v);
  }

  function _hash(string memory value) private pure returns (bytes32) {
    return keccak256(bytes(value));
  }

  function _assertEq(uint256 actual, uint256 expected, string memory message) private pure {
    if (actual != expected) revert(message);
  }

  function _assertEq(address actual, address expected, string memory message) private pure {
    if (actual != expected) revert(message);
  }

  function _assertTrue(bool value, string memory message) private pure {
    if (!value) revert(message);
  }
}
