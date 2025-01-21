// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {Test} from "forge-std/Test.sol";
import {Strings} from "openzeppelin/contracts/utils/Strings.sol";

import {ObscurusTestDeployer} from "@test-utils/ObscurusTestDeployer.sol";

contract ObscurusTestTools is Test, ObscurusTestDeployer {
    function generateAccount(string memory name) public returns (address, uint256) {
        (address account, uint256 privateKey) = makeAddrAndKey(name);

        return (account, privateKey);
    }

    function generateAccounts(uint256 n) public returns (address[] memory, uint256[] memory) {
        address[] memory accounts = new address[](n);
        uint256[] memory privateKeys = new uint256[](n);

        for (uint256 i = 0; i < n; i++) {
            (accounts[i], privateKeys[i]) = generateAccount(string.concat("account_", Strings.toString(i)));
        }

        return (accounts, privateKeys);
    }
}
