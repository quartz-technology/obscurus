// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {Script} from "forge-std/Script.sol";
import {ModuleProxyFactory} from "zodiac/factory/ModuleProxyFactory.sol";

import {Obscurus} from "../src/Obscurus.sol";

contract DeployScript is Script {
    function run() public returns (Obscurus obscurusSingleton, ModuleProxyFactory moduleProxyFactory) {
        vm.startBroadcast();

        obscurusSingleton = new Obscurus({_safe: address(0x01), _threshold: 1});
        moduleProxyFactory = new ModuleProxyFactory();

        vm.stopBroadcast();
    }
}
