// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {CommonBase} from "forge-std/Base.sol";

contract DeployConfigLocal is CommonBase {
    struct Configuration {
        uint256 safeOwnerPK;
    }

    function getConfiguration() public view returns (Configuration memory) {
        uint256 safeOwnerPK = vm.envUint("ODS_SAFE_OWNER_PK");

        return Configuration({safeOwnerPK: safeOwnerPK});
    }
}
