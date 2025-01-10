// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {Test, console} from "forge-std/Test.sol";
import "safe-tools/SafeTestTools.sol";
import {ModuleProxyFactory} from "zodiac/factory/ModuleProxyFactory.sol";

import {DeployScript} from "../script/Deploy.s.sol";
import "../src/Obscurus.sol";

contract ObscurusTest is Test, SafeTestTools {
    using SafeTestLib for SafeInstance;

    Obscurus private obscurusSingleton;
    ModuleProxyFactory private moduleProxyFactory;

    function setUp() public {
        (obscurusSingleton, moduleProxyFactory) = (new DeployScript()).run();
    }

    function _setupObscurus(uint256[] memory safeOwnerPKs, uint256 obscurusThreshold) internal returns (Obscurus) {
        SafeInstance memory safeInstance = _setupSafe({
            ownerPKs: safeOwnerPKs,
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

        bytes memory obscurusModuleSetupCall = abi.encodeWithSelector(
            obscurusSingleton.setUp.selector, abi.encode(address(safeInstance.safe), obscurusThreshold)
        );

        address obscurusModule = moduleProxyFactory.deployModule({
            masterCopy: address(obscurusSingleton),
            initializer: obscurusModuleSetupCall,
            saltNonce: 0
        });

        safeInstance.enableModule(obscurusModule);

        return Obscurus(obscurusModule);
    }

    function test_obscureExecAndReturnData() public {
        uint256[] memory ownerPKs = new uint256[](1);
        ownerPKs[0] = 12345;

        uint256 obscurusThreshold = 1;

        Obscurus obscurus = _setupObscurus(ownerPKs, obscurusThreshold);

        address recipient = address(0xA11c3);
        uint256 value = 1 ether;

        obscurus.obscureExecAndReturnData({to: recipient, value: value, data: "", operation: Enum.Operation.Call});

        assertEq(recipient.balance, value);
    }
}
