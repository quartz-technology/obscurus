// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {Script} from "forge-std/Script.sol";
import {ISemaphoreVerifier} from "@semaphore-protocol/contracts/interfaces/ISemaphoreVerifier.sol";
import {SemaphoreVerifier} from "@semaphore-protocol/contracts/base/SemaphoreVerifier.sol";
import {ISemaphore} from "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";
import {Semaphore} from "@semaphore-protocol/contracts/Semaphore.sol";
import {Safe, Enum as SafeEnum} from "safe-contracts/Safe.sol";

import {DeployConfigCommon} from "@script/DeployConfigCommon.sol";
import {DeployConfigLocal} from "@script/local/DeployConfig.local.sol";
import {Obscurus} from "@src/Obscurus.sol";
import {IObscurus} from "@src/interfaces/IObscurus.sol";

contract DeployScriptLocal is Script {
    DeployConfigCommon.Configuration public configCommon;
    DeployConfigLocal.Configuration public configLocal;

    function setUp() public {
        configCommon = new DeployConfigCommon().getConfiguration();
        configLocal = new DeployConfigLocal().getConfiguration();
    }

    function run() public {
        vm.startBroadcast();

        ISemaphore semaphore = _deploySemaphore();
        Obscurus obscurus = _deployObscurus(semaphore);
        _deployModule(Obscurus(address(obscurus)));

        vm.stopBroadcast();
    }

    function _deploySemaphore() internal returns (ISemaphore semaphore) {
        SemaphoreVerifier semaphoreVerifier = new SemaphoreVerifier();
        semaphore = new Semaphore(ISemaphoreVerifier(address(semaphoreVerifier)));
    }

    function _deployObscurus(ISemaphore _semaphore) internal returns (Obscurus obscurus) {
        IObscurus.InitParameters memory obscurusParams = IObscurus.InitParameters({
            safe: address(configCommon.safe),
            semaphore: address(_semaphore),
            threshold: configCommon.threshold,
            identities: configCommon.identityCommitments
        });
        obscurus = new Obscurus(obscurusParams);
    }

    function _deployModule(Obscurus _obscurus) internal {
        address safeAddress = address(configCommon.safe);
        address payable safePayableAddress = payable(configCommon.safe);

        bytes32 txHash = Safe(safePayableAddress).getTransactionHash(
            safeAddress,
            0,
            abi.encodeWithSelector(Safe(safePayableAddress).enableModule.selector, address(_obscurus)),
            SafeEnum.Operation.Call,
            0,
            0,
            0,
            address(0),
            address(0),
            Safe(safePayableAddress).nonce()
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(configLocal.safeOwnerPK, txHash);

        bytes memory signatures;
        signatures = bytes.concat(signatures, abi.encodePacked(r, s, v));

        Safe(safePayableAddress).execTransaction(
            safeAddress,
            0,
            abi.encodeWithSelector(Safe(safePayableAddress).enableModule.selector, address(_obscurus)),
            SafeEnum.Operation.Call,
            0,
            0,
            0,
            address(0),
            payable(0),
            signatures
        );
    }
}
