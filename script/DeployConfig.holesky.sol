// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {Script, console} from "forge-std/Script.sol";
import "openzeppelin/contracts/utils/Strings.sol";

import "./IDeployConfig.sol";

contract DeployConfigHolesky is IDeployConfig, Script {
    function getConfiguration() public view returns (Configuration memory cfg) {
        cfg.safe = vm.envAddress("ODS_SAFE_ADDRESS");
        uint256 numIdentities = vm.envUint("ODS_NUM_IDENTITIES");

        if (numIdentities == 0) {
            revert DeploymentConfigurationError("ODS: number of identities must be greater than 0");
        }

        cfg.threshold = vm.envUint("ODS_THRESHOLD");
        if (cfg.threshold > numIdentities) {
            revert DeploymentConfigurationError("ODS: threshold must be lower than number of identities");
        }

        cfg.identities = new uint256[](numIdentities);

        for (uint256 i = 0; i < numIdentities; i++) {
            cfg.identities[i] = vm.envUint(string.concat("ODS_IDENTITY_COMMITMENT_", Strings.toString(i)));
        }
    }
}
