// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {console} from "forge-std/Test.sol";
import {CommonBase} from "forge-std/Base.sol";
import {Strings} from "openzeppelin/contracts/utils/Strings.sol";
import {ISemaphore} from "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";

import {SemaphoreIdentityTestTools} from "@test-utils/SemaphoreIdentityTestTools.sol";

library SemaphoreProofCast {
    function cast(SemaphoreProofTestTools.SemaphoreProof memory proof)
        public
        pure
        returns (ISemaphore.SemaphoreProof memory)
    {
        return ISemaphore.SemaphoreProof(
            proof.merkleTreeDepth, proof.merkleTreeRoot, proof.nullifier, proof.message, proof.scope, proof.points
        );
    }
}

contract SemaphoreProofTestTools is CommonBase {
    struct SemaphoreProof {
        uint256 merkleTreeDepth;
        uint256 merkleTreeRoot;
        uint256 nullifier;
        uint256 message;
        uint256 scope;
        uint256[8] points;
    }

    function generateProof(
        string memory _proverPrivateKey,
        uint256[] memory _identityCommitments,
        uint256 _message,
        uint256 _scope
    ) public returns (SemaphoreProof memory) {
        string[] memory inputs = new string[](11 + _identityCommitments.length);

        inputs[0] = "node";
        inputs[1] = "tools/obscurus-cli/dist/index.js";
        inputs[2] = "gen-local-proof";
        inputs[3] = "--verbose";
        inputs[4] = "--prover-private-key";
        inputs[5] = _proverPrivateKey;
        inputs[6] = "--scope";
        inputs[7] = Strings.toString(_scope);
        inputs[8] = "--message";
        inputs[9] = Strings.toString(_message);
        inputs[10] = "--identities";

        for (uint256 i = 0; i < _identityCommitments.length; i++) {
            inputs[11 + i] = Strings.toString(_identityCommitments[i]);
        }

        bytes memory json = vm.ffi(inputs);

        uint256 merkleTreeDepth = vm.parseJsonUint(string(json), ".merkleTreeDepth");
        uint256 merkleTreeRoot = vm.parseJsonUint(string(json), ".merkleTreeRoot");
        uint256 nullifier = vm.parseJsonUint(string(json), ".nullifier");
        uint256 message = vm.parseJsonUint(string(json), ".message");
        uint256 scope = vm.parseJsonUint(string(json), ".scope");
        uint256[] memory jsonPoints = vm.parseJsonUintArray(string(json), ".points");
        uint256[8] memory points;

        for (uint256 i = 0; i < jsonPoints.length; i++) {
            points[i] = jsonPoints[i];
        }

        return SemaphoreProof({
            merkleTreeDepth: merkleTreeDepth,
            merkleTreeRoot: merkleTreeRoot,
            nullifier: nullifier,
            message: message,
            scope: scope,
            points: points
        });
    }
}
