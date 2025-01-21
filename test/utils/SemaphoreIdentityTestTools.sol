// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {CommonBase} from "forge-std/Base.sol";

library SemaphoreIdentityArray {
    function commitments(SemaphoreIdentityTestTools.SemaphoreIdentity[] memory _identities)
        internal
        pure
        returns (uint256[] memory)
    {
        uint256[] memory identityCommitments = new uint256[](_identities.length);

        for (uint256 i = 0; i < _identities.length; i++) {
            identityCommitments[i] = _identities[i].commitment;
        }

        return identityCommitments;
    }
}

contract SemaphoreIdentityTestTools is CommonBase {
    struct SemaphoreIdentity {
        uint256 commitment;
        string privateKey;
    }

    function generateIdentity() public returns (SemaphoreIdentity memory) {
        string[] memory inputs = new string[](4);

        inputs[0] = "node";
        inputs[1] = "tools/obscurus-cli/dist/index.js";
        inputs[2] = "gen-identity";
        inputs[3] = "--verbose";

        bytes memory json = vm.ffi(inputs);

        uint256 commitment = vm.parseJsonUint(string(json), ".commitment");
        string memory privateKey = vm.parseJsonString(string(json), ".privateKey");

        return SemaphoreIdentity({commitment: commitment, privateKey: privateKey});
    }

    function generateIdentities(uint256 n) public returns (SemaphoreIdentity[] memory) {
        SemaphoreIdentity[] memory identities = new SemaphoreIdentity[](n);

        for (uint256 i = 0; i < n; i++) {
            identities[i] = generateIdentity();
        }

        return identities;
    }
}
