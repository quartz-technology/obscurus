// SPDX-License-Identifier: Apache 2.0
pragma solidity 0.8.27;

import {CommonBase} from "forge-std/Base.sol";
import "openzeppelin/contracts/utils/Strings.sol";

contract SemaphoreCheats is CommonBase {
    struct SemaphoreCheatIdentity {
        uint256 commitment;
        string privateKey;
    }

    struct SemaphoreCheatGroup {
        uint256 root;
    }

    struct SemaphoreCheatProof {
        uint256 merkleTreeDepth;
        uint256 merkleTreeRoot;
        uint256 nullifier;
        uint256 message;
        uint256[8] points;
    }

    function generateIdentity()
        internal
        returns (SemaphoreCheatIdentity memory)
    {
        string[] memory inputs = new string[](4);

        inputs[0] = "npx";
        inputs[1] = "tsx";
        inputs[2] = "test/utils/semaphore-cheat-cli.ts";
        inputs[3] = "generate-identity";

        bytes memory json = vm.ffi(inputs);

        uint256 commitment = vm.parseJsonUint(string(json), ".commitment");
        string memory privateKey = vm.parseJsonString(
            string(json),
            ".privateKey"
        );

        return
            SemaphoreCheatIdentity({
                commitment: commitment,
                privateKey: privateKey
            });
    }

    function generateIdentitiesFull(
        uint256 n
    ) internal returns (SemaphoreCheatIdentity[] memory, uint256[] memory) {
        SemaphoreCheatIdentity[]
            memory identities = new SemaphoreCheatIdentity[](n);
        uint256[] memory identitiesValue = new uint256[](n);

        for (uint256 i; i < n; i++) {
            identities[i] = generateIdentity();
            identitiesValue[i] = identities[i].commitment;
        }

        return (identities, identitiesValue);
    }

    function generateIdentityFromSecret(
        string memory _secret
    ) internal returns (SemaphoreCheatIdentity memory) {
        string[] memory inputs = new string[](6);

        inputs[0] = "npx";
        inputs[1] = "tsx";
        inputs[2] = "test/utils/semaphore-cheat-cli.ts";
        inputs[3] = "generate-group";
        inputs[4] = "--secret";
        inputs[5] = _secret;

        bytes memory json = vm.ffi(inputs);

        uint256 commitment = vm.parseJsonUint(string(json), ".commitment");
        string memory privateKey = vm.parseJsonString(
            string(json),
            ".privateKey"
        );

        return
            SemaphoreCheatIdentity({
                commitment: commitment,
                privateKey: privateKey
            });
    }

    function generateGroup(
        SemaphoreCheatIdentity[] memory _identities
    ) internal returns (SemaphoreCheatGroup memory) {
        string[] memory inputs = new string[](5 + _identities.length);

        inputs[0] = "npx";
        inputs[1] = "tsx";
        inputs[2] = "test/utils/semaphore-cheat-cli.ts";
        inputs[3] = "generate-group";
        inputs[4] = "--identities";

        for (uint256 i = 0; i < _identities.length; i++) {
            inputs[5 + i] = Strings.toString(_identities[i].commitment);
        }

        bytes memory json = vm.ffi(inputs);

        uint256 root = vm.parseJsonUint(string(json), ".root");

        return SemaphoreCheatGroup({root: root});
    }

    function generateProof(
        SemaphoreCheatIdentity memory _prover,
        SemaphoreCheatIdentity[] memory _groupIdentities,
        string memory _message,
        string memory _scope
    ) internal returns (SemaphoreCheatProof memory) {
        string[] memory inputs = new string[](11 + _groupIdentities.length);

        inputs[0] = "npx";
        inputs[1] = "tsx";
        inputs[2] = "test/utils/semaphore-cheat-cli.ts";
        inputs[3] = "generate-proof";
        inputs[4] = "--prover";
        inputs[5] = _prover.privateKey;
        inputs[6] = "--scope";
        inputs[7] = _scope;
        inputs[8] = "--message";
        inputs[9] = _message;
        inputs[10] = "--identities";

        for (uint256 i = 0; i < _groupIdentities.length; i++) {
            inputs[11 + i] = Strings.toString(_groupIdentities[i].commitment);
        }

        bytes memory json = vm.ffi(inputs);

        uint256 merkleTreeDepth = vm.parseJsonUint(
            string(json),
            ".merkleTreeDepth"
        );
        uint256 merkleTreeRoot = vm.parseJsonUint(
            string(json),
            ".merkleTreeRoot"
        );
        uint256 nullifier = vm.parseJsonUint(string(json), ".nullifier");
        uint256 message = vm.parseJsonUint(string(json), ".message");
        uint256[] memory jsonPoints = vm.parseJsonUintArray(
            string(json),
            ".points"
        );
        uint256[8] memory points;

        for (uint256 i = 0; i < jsonPoints.length; i++) {
            points[i] = jsonPoints[i];
        }

        return
            SemaphoreCheatProof({
                merkleTreeDepth: merkleTreeDepth,
                merkleTreeRoot: merkleTreeRoot,
                nullifier: nullifier,
                message: message,
                points: points
            });
    }
}
