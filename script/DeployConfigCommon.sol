// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {CommonBase} from "forge-std/Base.sol";
import {Strings} from "openzeppelin/contracts/utils/Strings.sol";

contract DeployConfigCommon is CommonBase {
    struct Configuration {
        address safe;
        uint256 threshold;
        uint256[] identityCommitments;
    }

    function getConfiguration() public view returns (Configuration memory) {
        address safe = vm.envAddress("ODS_SAFE_ADDRESS");
        uint256 threshold = vm.envUint("ODS_OBSCURUS_THRESHOLD");
        uint256 numIdentities = vm.envUint("ODS_OBSCURUS_NUM_IDENTITIES");

        uint256[] memory identityCommitments = new uint256[](numIdentities);

        for (uint256 i = 0; i < numIdentities; i++) {
            identityCommitments[i] = vm.envUint(string.concat("ODS_OBSCURUS_IDENTITY_", Strings.toString(i)));
        }

        return Configuration({safe: safe, threshold: threshold, identityCommitments: identityCommitments});
    }
}
