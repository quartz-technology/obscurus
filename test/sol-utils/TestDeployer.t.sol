// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {Test, console} from "forge-std/Test.sol";
import "safe-tools/SafeTestTools.sol";
import {ModuleProxyFactory} from "zodiac/factory/ModuleProxyFactory.sol";
import {ISemaphoreVerifier} from "@semaphore-protocol/contracts/interfaces/ISemaphoreVerifier.sol";
import {SemaphoreVerifier} from "@semaphore-protocol/contracts/base/SemaphoreVerifier.sol";
import {ISemaphore} from "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";
import {Semaphore} from "@semaphore-protocol/contracts/Semaphore.sol";

import "@src/Obscurus.sol";

contract TestDeployer is Test, SafeTestTools {
    using SafeTestLib for SafeInstance;

    uint256[] private safeOwnerPKs;
    SafeInstance public safeInstance;

    SemaphoreVerifier private semaphoreVerifier;
    ISemaphore private semaphore;
    Obscurus public obscurus;
    ModuleProxyFactory private moduleProxyFactory;

    function deploy(uint256 _threshold, uint256[] memory _identities) public {
        uint256[] memory _safeOwnerPKs = new uint256[](1);
        _safeOwnerPKs[0] = 12345;

        safeOwnerPKs = _safeOwnerPKs;

        _deploySafe(safeOwnerPKs);
        _deployObscurus(address(safeInstance.safe), _threshold, _identities);
        _deployModule(safeInstance, address(obscurus));
    }

    function _deploySafe(uint256[] memory _ownerPKs) private {
        safeInstance = _setupSafe({
            ownerPKs: _ownerPKs,
            threshold: 1,
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

    function _deployObscurus(address _safe, uint256 _threshold, uint256[] memory _identities) private {
        semaphoreVerifier = new SemaphoreVerifier();
        semaphore = new Semaphore(ISemaphoreVerifier(address(semaphoreVerifier)));

        obscurus = new Obscurus({
            _safe: _safe,
            _semaphore: address(semaphore),
            _threshold: _threshold,
            _identities: _identities
        });
    }

    function _deployModule(SafeInstance memory _safeInstance, address _obscurus) private {
        _safeInstance.enableModule(_obscurus);
    }
}
