// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import "./sol-utils/TestDeployer.t.sol";
import {SemaphoreCheats} from "./sol-utils/SemaphoreCheats.sol";
import {TestUtils} from "./sol-utils/TestUtils.sol";

contract ObscurusTest is TestDeployer, SemaphoreCheats, TestUtils {
    uint256 private threshold;
    SemaphoreCheatIdentity private alice;
    SemaphoreCheatIdentity private bob;
    SemaphoreCheatIdentity private pierre;

    function setUp() public {
        threshold = 2;
        alice = generateIdentity();
        bob = generateIdentity();
        pierre = generateIdentity();

        deploy(threshold, _getAllIdentityCommitments());
    }

    function _getAllIdentities() internal view returns (SemaphoreCheatIdentity[] memory) {
        SemaphoreCheatIdentity[] memory identities = new SemaphoreCheatIdentity[](3);

        identities[0] = alice;
        identities[1] = bob;
        identities[2] = pierre;

        return identities;
    }

    function _getAllIdentityCommitments() internal view returns (uint256[] memory) {
        SemaphoreCheatIdentity[] memory identities = _getAllIdentities();
        uint256[] memory identityCommitments = new uint256[](identities.length);

        for (uint256 i = 0; i < identityCommitments.length; i++) {
            identityCommitments[i] = identities[i].commitment;
        }

        return identityCommitments;
    }

    function test_obscureTransfer() public {
        address recipient = address(0xDEADBEEF);
        vm.deal(recipient, 0);

        uint256 value = 1 ether;

        uint256 signal = obscurus.computeSignal();
        uint256 scope = obscurus.computeScope(recipient, value, "", Enum.Operation.Call);
        ISemaphore.SemaphoreProof[] memory proofs = new ISemaphore.SemaphoreProof[](3);

        proofs[0] = generateProof(alice, _getAllIdentities(), signal, scope);
        proofs[1] = generateProof(bob, _getAllIdentities(), signal, scope);
        proofs[2] = generateProof(pierre, _getAllIdentities(), signal, scope);

        (bool success,) = obscurus.obscureExecAndReturnData({
            _to: recipient,
            _value: value,
            _data: "",
            _operation: Enum.Operation.Call,
            _proofs: proofs
        });

        assertEq(success, true);
        assertEq(recipient.balance, value);
        assertEq(safeInstance.safe.nonce(), 1);
    }

    function test_multiObscureTransfer() public {
        vm.deal(address(safeInstance.safe), 3 ether);

        address recipient = address(0xDEADBEEF);
        vm.deal(recipient, 0);

        uint256 value = 1 ether;

        for (uint256 i = 0; i < 3; i++) {
            uint256 signal = obscurus.computeSignal();
            uint256 scope = obscurus.computeScope(recipient, value, "", Enum.Operation.Call);
            ISemaphore.SemaphoreProof[] memory proofs = new ISemaphore.SemaphoreProof[](3);

            proofs[0] = generateProof(alice, _getAllIdentities(), signal, scope);
            proofs[1] = generateProof(bob, _getAllIdentities(), signal, scope);
            proofs[2] = generateProof(pierre, _getAllIdentities(), signal, scope);

            (bool success,) = obscurus.obscureExecAndReturnData({
                _to: recipient,
                _value: value,
                _data: "",
                _operation: Enum.Operation.Call,
                _proofs: proofs
            });

            assertEq(success, true);
            assertEq(obscurus.nonce(), i + 1);
            assertEq(recipient.balance, value * (i + 1));
        }
    }

    function test_cannot_execWithoutMissingProofs() public {
        address recipient = address(0xDEADBEEF);
        vm.deal(recipient, 0);

        uint256 value = 1 ether;

        uint256 signal = obscurus.computeSignal();
        uint256 scope = obscurus.computeScope(recipient, value, "", Enum.Operation.Call);
        ISemaphore.SemaphoreProof[] memory proofs = new ISemaphore.SemaphoreProof[](1);

        proofs[0] = generateProof(alice, _getAllIdentities(), signal, scope);

        vm.expectRevert(NotEnoughProofs.selector);
        obscurus.obscureExecAndReturnData({
            _to: recipient,
            _value: value,
            _data: "",
            _operation: Enum.Operation.Call,
            _proofs: proofs
        });

        assertEq(recipient.balance, 0);
        assertEq(obscurus.nonce(), 0);
    }

    function test_cannot_execWithInvalidProof() public {
        address recipient = address(0xDEADBEEF);
        vm.deal(recipient, 0);

        uint256 value = 1 ether;

        uint256 signal = obscurus.computeSignal();
        uint256 scope = obscurus.computeScope(recipient, value, "", Enum.Operation.Call);
        ISemaphore.SemaphoreProof[] memory proofs = new ISemaphore.SemaphoreProof[](3);

        proofs[0] = generateProof(alice, _getAllIdentities(), signal, scope);
        proofs[1] = generateProof(bob, _getAllIdentities(), signal, scope);
        proofs[2] = generateProof(pierre, _getAllIdentities(), signal, scope);

        // Invalidate Alice's proof.
        proofs[0].points[0] += 1;

        vm.expectRevert(ISemaphore.Semaphore__InvalidProof.selector);
        obscurus.obscureExecAndReturnData({
            _to: recipient,
            _value: value,
            _data: "",
            _operation: Enum.Operation.Call,
            _proofs: proofs
        });

        assertEq(recipient.balance, 0);
        assertEq(obscurus.nonce(), 0);
    }

    function test_cannot_execWithInvalidScope() public {
        address recipient = address(0xDEADBEEF);
        vm.deal(recipient, 0);

        uint256 value = 1 ether;

        uint256 signal = obscurus.computeSignal();
        uint256 scope = obscurus.computeScope(recipient, value, "", Enum.Operation.Call);
        ISemaphore.SemaphoreProof[] memory proofs = new ISemaphore.SemaphoreProof[](3);

        proofs[0] = generateProof(alice, _getAllIdentities(), signal, scope);
        proofs[1] = generateProof(bob, _getAllIdentities(), signal, scope);
        proofs[2] = generateProof(pierre, _getAllIdentities(), signal, scope + 1);

        vm.expectRevert(InvalidScope.selector);
        obscurus.obscureExecAndReturnData({
            _to: recipient,
            _value: value,
            _data: "",
            _operation: Enum.Operation.Call,
            _proofs: proofs
        });

        assertEq(recipient.balance, 0);
        assertEq(obscurus.nonce(), 0);
    }

    function test_cannot_execWithInvalidSignal() public {
        address recipient = address(0xDEADBEEF);
        vm.deal(recipient, 0);

        uint256 value = 1 ether;

        uint256 signal = obscurus.computeSignal();
        uint256 scope = obscurus.computeScope(recipient, value, "", Enum.Operation.Call);
        ISemaphore.SemaphoreProof[] memory proofs = new ISemaphore.SemaphoreProof[](3);

        proofs[0] = generateProof(alice, _getAllIdentities(), signal, scope);
        proofs[1] = generateProof(bob, _getAllIdentities(), signal, scope);
        proofs[2] = generateProof(pierre, _getAllIdentities(), signal + 1, scope);

        vm.expectRevert(InvalidSignal.selector);
        obscurus.obscureExecAndReturnData({
            _to: recipient,
            _value: value,
            _data: "",
            _operation: Enum.Operation.Call,
            _proofs: proofs
        });

        assertEq(recipient.balance, 0);
        assertEq(obscurus.nonce(), 0);
    }
}
