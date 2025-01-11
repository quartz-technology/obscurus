// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {Script} from "forge-std/Script.sol";
import {ModuleProxyFactory} from "zodiac/factory/ModuleProxyFactory.sol";
import {ISemaphore} from "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";
import {ISemaphoreVerifier} from "@semaphore-protocol/contracts/interfaces/ISemaphoreVerifier.sol";
import {SemaphoreVerifier} from "@semaphore-protocol/contracts/base/SemaphoreVerifier.sol";
import {Semaphore} from "@semaphore-protocol/contracts/Semaphore.sol";

import {Obscurus} from "../src/Obscurus.sol";

contract DeployScript is Script {
    function run()
        public
        returns (
            SemaphoreVerifier semaphoreVerifier,
            ISemaphore semaphore,
            Obscurus obscurusSingleton,
            ModuleProxyFactory moduleProxyFactory
        )
    {
        vm.startBroadcast();

        semaphoreVerifier = new SemaphoreVerifier();
        semaphore = new Semaphore(
            ISemaphoreVerifier(address(semaphoreVerifier))
        );

        uint256[] memory identities = new uint256[](1);
        identities[0] = 1;

        obscurusSingleton = new Obscurus({
            _safe: address(0x01),
            _semaphore: address(semaphore),
            _threshold: 1,
            _identities: identities
        });
        moduleProxyFactory = new ModuleProxyFactory();

        vm.stopBroadcast();
    }
}
