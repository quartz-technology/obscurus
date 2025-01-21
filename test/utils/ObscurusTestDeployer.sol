// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {SafeTestTools, SafeInstance, AdvancedSafeInitParams, SafeTestLib} from "safe-tools/SafeTestTools.sol";
import {ISemaphoreVerifier} from "@semaphore-protocol/contracts/interfaces/ISemaphoreVerifier.sol";
import {SemaphoreVerifier} from "@semaphore-protocol/contracts/base/SemaphoreVerifier.sol";
import {ISemaphore} from "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";
import {Semaphore} from "@semaphore-protocol/contracts/Semaphore.sol";

import {Obscurus} from "@src/Obscurus.sol";
import {IObscurus} from "@src/interfaces/IObscurus.sol";

contract ObscurusTestDeployer is SafeTestTools {
    using SafeTestLib for SafeInstance;

    SemaphoreVerifier private semaphoreVerifier;
    Semaphore private semaphore;

    SafeInstance internal safeInstance;
    Obscurus internal obscurus;

    function deploySafeAndObscurus(
        uint256[] memory _safeOwnerPKs,
        uint256 _safeThreshold,
        uint256[] memory _obscurusIdentities,
        uint256 _obscurusThreshold
    ) public {
        _deploySafe(_safeOwnerPKs, _safeThreshold);
        _deploySemaphore();
        _deployObscurus(_obscurusIdentities, _obscurusThreshold);
        _enableModule();
    }

    function _deploySafe(uint256[] memory _safeOwnerPKs, uint256 _safeThreshold) internal {
        safeInstance = _setupSafe({
            ownerPKs: _safeOwnerPKs,
            threshold: _safeThreshold,
            initialBalance: 1 ether,
            advancedParams: AdvancedSafeInitParams({
                includeFallbackHandler: true,
                initData: "",
                saltNonce: 100,
                setupModulesCall_to: address(0),
                setupModulesCall_data: "",
                refundAmount: 0,
                refundToken: address(0),
                refundReceiver: payable(address(0))
            })
        });
    }

    function _deploySemaphore() internal {
        semaphoreVerifier = new SemaphoreVerifier();
        semaphore = new Semaphore(ISemaphoreVerifier(address(semaphoreVerifier)));
    }

    function _deployObscurus(uint256[] memory _obscurusIdentities, uint256 _obscurusThreshold) internal {
        IObscurus.InitParameters memory obscurusParams = IObscurus.InitParameters({
            safe: address(safeInstance.safe),
            semaphore: address(semaphore),
            threshold: _obscurusThreshold,
            identities: _obscurusIdentities
        });

        obscurus = new Obscurus(obscurusParams);
    }

    function _enableModule() internal {
        safeInstance.enableModule(address(obscurus));
    }
}
