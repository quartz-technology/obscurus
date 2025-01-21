// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {Enum as SafeEnum} from "safe-contracts/Safe.sol";
import {ISemaphore} from "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";
import {LeafAlreadyExists} from "@zk-kit/lean-imt.sol/InternalLeanIMT.sol";

import {ObscurusTestTools} from "@test-utils/ObscurusTestTools.sol";
import {SemaphoreTestTools} from "@test-utils/SemaphoreTestTools.sol";
import {SemaphoreIdentityArray} from "@test-utils/SemaphoreIdentityTestTools.sol";
import {SemaphoreProofCast} from "@test-utils/SemaphoreProofTestTools.sol";
import {IObscurus} from "@src/interfaces/IObscurus.sol";

contract ObscurusTest is ObscurusTestTools, SemaphoreTestTools {
    using SemaphoreIdentityArray for SemaphoreIdentity[];
    using SemaphoreProofCast for SemaphoreProof;

    function test_SuccessfullyDeployWithValidConfiguration() public {
        (, uint256[] memory safeOwnerPKs) = generateAccounts(3);
        uint256 safeThreshold = 1;

        SemaphoreIdentity[] memory identities = generateIdentities(3);
        uint256[] memory identityCommitments = identities.commitments();
        uint256 obscurusThreshold = 2;

        deploySafeAndObscurus(safeOwnerPKs, safeThreshold, identityCommitments, obscurusThreshold);

        assertEq(obscurus.threshold(), obscurusThreshold);
        assertEq(obscurus.nonce(), 0);
    }

    function test_RevertWhenDeployingWithThresholdSetToZero() public {
        (, uint256[] memory safeOwnerPKs) = generateAccounts(3);
        uint256 safeThreshold = 1;

        SemaphoreIdentity[] memory identities = generateIdentities(3);
        uint256[] memory identityCommitments = identities.commitments();
        uint256 obscurusThreshold = 0;

        _deploySafe(safeOwnerPKs, safeThreshold);
        _deploySemaphore();

        vm.expectRevert(IObscurus.InvalidThresholdZero.selector);
        _deployObscurus(identityCommitments, obscurusThreshold);
    }

    function test_RevertWhenDeployingWithThresholdGreaterThanNumberOfIdentities() public {
        (, uint256[] memory safeOwnerPKs) = generateAccounts(3);
        uint256 safeThreshold = 1;

        SemaphoreIdentity[] memory identities = generateIdentities(3);
        uint256[] memory identityCommitments = identities.commitments();
        uint256 obscurusThreshold = 4;

        _deploySafe(safeOwnerPKs, safeThreshold);
        _deploySemaphore();

        vm.expectRevert(IObscurus.InvalidThresholdTooHigh.selector);
        _deployObscurus(identityCommitments, obscurusThreshold);
    }

    function test_RevertWhenDeployingWithTheSameIdentityTwice() public {
        (, uint256[] memory safeOwnerPKs) = generateAccounts(3);
        uint256 safeThreshold = 1;

        SemaphoreIdentity[] memory identities = generateIdentities(3);
        identities[1] = identities[0];

        uint256[] memory identityCommitments = identities.commitments();
        uint256 obscurusThreshold = 2;

        _deploySafe(safeOwnerPKs, safeThreshold);
        _deploySemaphore();

        vm.expectRevert(LeafAlreadyExists.selector);
        _deployObscurus(identityCommitments, obscurusThreshold);
    }

    function test_SuccessfullyExecuteAnonymousTransactionUsingMinimumAmountOfProof() public {
        (, uint256[] memory safeOwnerPKs) = generateAccounts(3);
        uint256 safeThreshold = 1;

        SemaphoreIdentity[] memory identities = generateIdentities(3);
        uint256[] memory identityCommitments = identities.commitments();
        uint256 obscurusThreshold = 2;

        deploySafeAndObscurus(safeOwnerPKs, safeThreshold, identityCommitments, obscurusThreshold);

        address to = address(0xdeadbeef);
        vm.deal(to, 0 ether);

        uint256 value = 1 ether;
        vm.deal(address(safeInstance.safe), value);

        IObscurus.TxParameters memory txParameters =
            IObscurus.TxParameters({to: to, value: value, data: "", operation: SafeEnum.Operation.Call});

        uint256 message = obscurus.computeSignal();
        uint256 scope = obscurus.computeScope(txParameters);

        ISemaphore.SemaphoreProof[] memory proofs = new ISemaphore.SemaphoreProof[](obscurusThreshold);

        for (uint256 i = 0; i < proofs.length; i++) {
            proofs[i] = generateProof(identities[i].privateKey, identityCommitments, message, scope).cast();
        }

        IObscurus.ObscureExecParameters memory obscureExecParameters =
            IObscurus.ObscureExecParameters({txParameters: txParameters, semaphoreProofs: proofs});
        (bool success, bytes memory returnData) = obscurus.obscureExecAndReturnData(obscureExecParameters);

        assertTrue(success);
        assertEq(returnData.length, 0);
        assertEq(to.balance, value);
        assertEq(address(safeInstance.safe).balance, 0);
        assertEq(obscurus.nonce(), 1);
    }

    function test_SuccessfullyExecuteAnonymousTransactionUsingMaximumAmountOfProof() public {
        (, uint256[] memory safeOwnerPKs) = generateAccounts(3);
        uint256 safeThreshold = 1;

        SemaphoreIdentity[] memory identities = generateIdentities(3);
        uint256[] memory identityCommitments = identities.commitments();
        uint256 obscurusThreshold = 2;

        deploySafeAndObscurus(safeOwnerPKs, safeThreshold, identityCommitments, obscurusThreshold);

        address to = address(0xdeadbeef);
        vm.deal(to, 0 ether);

        uint256 value = 1 ether;
        vm.deal(address(safeInstance.safe), value);

        IObscurus.TxParameters memory txParameters =
            IObscurus.TxParameters({to: to, value: value, data: "", operation: SafeEnum.Operation.Call});

        uint256 message = obscurus.computeSignal();
        uint256 scope = obscurus.computeScope(txParameters);

        ISemaphore.SemaphoreProof[] memory proofs = new ISemaphore.SemaphoreProof[](identities.length);

        for (uint256 i = 0; i < proofs.length; i++) {
            proofs[i] = generateProof(identities[i].privateKey, identityCommitments, message, scope).cast();
        }

        IObscurus.ObscureExecParameters memory obscureExecParameters =
            IObscurus.ObscureExecParameters({txParameters: txParameters, semaphoreProofs: proofs});
        (bool success, bytes memory returnData) = obscurus.obscureExecAndReturnData(obscureExecParameters);

        assertTrue(success);
        assertEq(returnData.length, 0);
        assertEq(to.balance, value);
        assertEq(address(safeInstance.safe).balance, 0);
        assertEq(obscurus.nonce(), 1);
    }

    function test_SuccessfullyExecuteMultipleAnonymousTransactions() public {
        (, uint256[] memory safeOwnerPKs) = generateAccounts(3);
        uint256 safeThreshold = 1;

        SemaphoreIdentity[] memory identities = generateIdentities(3);
        uint256[] memory identityCommitments = identities.commitments();
        uint256 obscurusThreshold = 2;

        deploySafeAndObscurus(safeOwnerPKs, safeThreshold, identityCommitments, obscurusThreshold);

        address to = address(0xdeadbeef);
        vm.deal(to, 0 ether);

        uint256 safeInitBalance = 3 ether;
        vm.deal(address(safeInstance.safe), safeInitBalance);

        uint256 numTransactions = 3;

        for (uint256 i = 0; i < numTransactions; i++) {
            uint256 value = 1 ether;

            IObscurus.TxParameters memory txParameters =
                IObscurus.TxParameters({to: to, value: value, data: "", operation: SafeEnum.Operation.Call});

            uint256 message = obscurus.computeSignal();
            uint256 scope = obscurus.computeScope(txParameters);
            ISemaphore.SemaphoreProof[] memory proofs = new ISemaphore.SemaphoreProof[](identities.length);

            for (uint256 j = 0; j < proofs.length; j++) {
                proofs[j] = generateProof(identities[j].privateKey, identityCommitments, message, scope).cast();
            }

            IObscurus.ObscureExecParameters memory obscureExecParameters =
                IObscurus.ObscureExecParameters({txParameters: txParameters, semaphoreProofs: proofs});
            (bool success, bytes memory returnData) = obscurus.obscureExecAndReturnData(obscureExecParameters);

            assertTrue(success);
            assertEq(returnData.length, 0);
            assertEq(to.balance, value * (i + 1));
            assertEq(address(safeInstance.safe).balance, safeInitBalance - value * (i + 1));
            assertEq(obscurus.nonce(), i + 1);
        }
    }

    function test_RevertWhenExecutingTransactionUsingNotEnoughProofs() public {
        (, uint256[] memory safeOwnerPKs) = generateAccounts(3);
        uint256 safeThreshold = 1;

        SemaphoreIdentity[] memory identities = generateIdentities(3);
        uint256[] memory identityCommitments = identities.commitments();
        uint256 obscurusThreshold = 2;

        deploySafeAndObscurus(safeOwnerPKs, safeThreshold, identityCommitments, obscurusThreshold);

        address to = address(0xdeadbeef);
        vm.deal(to, 0 ether);

        uint256 value = 1 ether;
        vm.deal(address(safeInstance.safe), value);

        IObscurus.TxParameters memory txParameters =
            IObscurus.TxParameters({to: to, value: value, data: "", operation: SafeEnum.Operation.Call});

        uint256 message = obscurus.computeSignal();
        uint256 scope = obscurus.computeScope(txParameters);

        ISemaphore.SemaphoreProof[] memory proofs = new ISemaphore.SemaphoreProof[](obscurusThreshold - 1);

        for (uint256 i = 0; i < proofs.length; i++) {
            proofs[i] = generateProof(identities[i].privateKey, identityCommitments, message, scope).cast();
        }

        IObscurus.ObscureExecParameters memory obscureExecParameters =
            IObscurus.ObscureExecParameters({txParameters: txParameters, semaphoreProofs: proofs});

        vm.expectRevert(IObscurus.InvalidExecutionNotEnoughProofs.selector);
        (bool success, bytes memory returnData) = obscurus.obscureExecAndReturnData(obscureExecParameters);

        assertFalse(success);
        assertEq(returnData.length, 0);
        assertEq(to.balance, 0);
        assertEq(address(safeInstance.safe).balance, value);
        assertEq(obscurus.nonce(), 0);
    }

    function test_RevertWhenExecutingTransactionUsingInvalidScope() public {
        (, uint256[] memory safeOwnerPKs) = generateAccounts(3);
        uint256 safeThreshold = 1;

        SemaphoreIdentity[] memory identities = generateIdentities(3);
        uint256[] memory identityCommitments = identities.commitments();
        uint256 obscurusThreshold = 2;

        deploySafeAndObscurus(safeOwnerPKs, safeThreshold, identityCommitments, obscurusThreshold);

        address to = address(0xdeadbeef);
        vm.deal(to, 0 ether);

        uint256 value = 1 ether;
        vm.deal(address(safeInstance.safe), value);

        IObscurus.TxParameters memory txParameters =
            IObscurus.TxParameters({to: to, value: value, data: "", operation: SafeEnum.Operation.Call});

        uint256 message = obscurus.computeSignal();
        uint256 scope = obscurus.computeScope(txParameters);

        ISemaphore.SemaphoreProof[] memory proofs = new ISemaphore.SemaphoreProof[](identities.length);

        for (uint256 i = 0; i < proofs.length - 1; i++) {
            proofs[i] = generateProof(identities[i].privateKey, identityCommitments, message, scope).cast();
        }

        proofs[proofs.length - 1] =
            generateProof(identities[proofs.length - 1].privateKey, identityCommitments, message, scope + 1).cast();

        IObscurus.ObscureExecParameters memory obscureExecParameters =
            IObscurus.ObscureExecParameters({txParameters: txParameters, semaphoreProofs: proofs});

        vm.expectRevert(IObscurus.InvalidExecutionScope.selector);
        (bool success, bytes memory returnData) = obscurus.obscureExecAndReturnData(obscureExecParameters);

        assertFalse(success);
        assertEq(returnData.length, 0);
        assertEq(to.balance, 0);
        assertEq(address(safeInstance.safe).balance, value);
        assertEq(obscurus.nonce(), 0);
    }

    function test_RevertWhenExecutingTransactionUsingInvalidSignal() public {
        (, uint256[] memory safeOwnerPKs) = generateAccounts(3);
        uint256 safeThreshold = 1;

        SemaphoreIdentity[] memory identities = generateIdentities(3);
        uint256[] memory identityCommitments = identities.commitments();
        uint256 obscurusThreshold = 2;

        deploySafeAndObscurus(safeOwnerPKs, safeThreshold, identityCommitments, obscurusThreshold);

        address to = address(0xdeadbeef);
        vm.deal(to, 0 ether);

        uint256 value = 1 ether;
        vm.deal(address(safeInstance.safe), value);

        IObscurus.TxParameters memory txParameters =
            IObscurus.TxParameters({to: to, value: value, data: "", operation: SafeEnum.Operation.Call});

        uint256 message = obscurus.computeSignal();
        uint256 scope = obscurus.computeScope(txParameters);

        ISemaphore.SemaphoreProof[] memory proofs = new ISemaphore.SemaphoreProof[](identities.length);

        for (uint256 i = 0; i < proofs.length - 1; i++) {
            proofs[i] = generateProof(identities[i].privateKey, identityCommitments, message, scope).cast();
        }

        proofs[proofs.length - 1] =
            generateProof(identities[proofs.length - 1].privateKey, identityCommitments, message + 1, scope).cast();

        IObscurus.ObscureExecParameters memory obscureExecParameters =
            IObscurus.ObscureExecParameters({txParameters: txParameters, semaphoreProofs: proofs});

        vm.expectRevert(IObscurus.InvalidExecutionSignal.selector);
        (bool success, bytes memory returnData) = obscurus.obscureExecAndReturnData(obscureExecParameters);

        assertFalse(success);
        assertEq(returnData.length, 0);
        assertEq(to.balance, 0);
        assertEq(address(safeInstance.safe).balance, value);
        assertEq(obscurus.nonce(), 0);
    }
}
