// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {Test, console} from "forge-std/Test.sol";
import "safe-tools/SafeTestTools.sol";
import {SemaphoreCheats} from "./SemaphoreCheats.sol";
import {SemaphoreCheatsUtils} from "./SemaphoreCheatsUtils.sol";
import {ModuleProxyFactory} from "zodiac/factory/ModuleProxyFactory.sol";
import {SemaphoreVerifier} from "@semaphore-protocol/contracts/base/SemaphoreVerifier.sol";
import {ISemaphore} from "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";
import {Strings} from "openzeppelin/contracts/utils/Strings.sol";

import {DeployScript} from "../script/Deploy.s.sol";
import "../src/Obscurus.sol";
import "../src/Errors.sol";

contract ObscurusTest is Test, SafeTestTools, SemaphoreCheats, SemaphoreCheatsUtils {
    using SafeTestLib for SafeInstance;

    SemaphoreVerifier semaphoreVerifier;
    ISemaphore semaphore;
    Obscurus private obscurusSingleton;
    ModuleProxyFactory private moduleProxyFactory;

    function setUp() public {
        (semaphoreVerifier, semaphore, obscurusSingleton, moduleProxyFactory) = (new DeployScript()).run();
    }

    function _setupObscurus(
        uint256[] memory safeOwnerPKs,
        address _semaphore,
        uint256 _threshold,
        uint256[] memory _identities
    ) internal returns (Obscurus) {
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
            obscurusSingleton.setUp.selector,
            abi.encode(address(safeInstance.safe), _semaphore, _threshold, _identities)
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
        uint256 numIdentities = 3;

        (SemaphoreCheatIdentity[] memory identities, uint256[] memory identitiesCommitments) =
            generateIdentitiesFull(numIdentities);

        Obscurus obscurus = _setupObscurus(ownerPKs, address(semaphore), obscurusThreshold, identitiesCommitments);

        address recipient = address(0xA11c3);
        uint256 value = 1 ether;

        uint256 scope = obscurus.computeScope(recipient, value, "", Enum.Operation.Call);
        uint256 signal = obscurus.computeSignal();

        SemaphoreCheatProof[] memory cheatProofs = new SemaphoreCheatProof[](numIdentities);
        ISemaphore.SemaphoreProof[] memory proofs = new ISemaphore.SemaphoreProof[](numIdentities);

        for (uint256 i = 0; i < numIdentities; i++) {
            cheatProofs[i] = generateProof(identities[i], identities, Strings.toString(signal), Strings.toString(scope));
            proofs[i] = ISemaphore.SemaphoreProof({
                merkleTreeDepth: cheatProofs[i].merkleTreeDepth,
                merkleTreeRoot: cheatProofs[i].merkleTreeRoot,
                nullifier: cheatProofs[i].nullifier,
                message: cheatProofs[i].message,
                scope: scope,
                points: cheatProofs[i].points
            });
        }

        obscurus.obscureExecAndReturnData({
            to: recipient,
            value: value,
            data: "",
            operation: Enum.Operation.Call,
            proofs: proofs
        });

        assertEq(recipient.balance, value);
    }

    function test_cannot_obscureExecAndReturnDataWithNotEnoughProofs() public {
        uint256[] memory ownerPKs = new uint256[](1);
        ownerPKs[0] = 12345;

        uint256 obscurusThreshold = 2;
        uint256 numIdentities = 3;

        (SemaphoreCheatIdentity[] memory identities, uint256[] memory identitiesCommitments) =
            generateIdentitiesFull(numIdentities);

        Obscurus obscurus = _setupObscurus(ownerPKs, address(semaphore), obscurusThreshold, identitiesCommitments);

        address recipient = address(0xA11c3);
        uint256 value = 1 ether;

        uint256 scope = obscurus.computeScope(recipient, value, "", Enum.Operation.Call);
        uint256 signal = obscurus.computeSignal();

        SemaphoreCheatProof[] memory cheatProofs = new SemaphoreCheatProof[](1);
        ISemaphore.SemaphoreProof[] memory proofs = new ISemaphore.SemaphoreProof[](1);

        for (uint256 i = 0; i < 1; i++) {
            cheatProofs[i] = generateProof(identities[i], identities, Strings.toString(signal), Strings.toString(scope));
            proofs[i] = ISemaphore.SemaphoreProof({
                merkleTreeDepth: cheatProofs[i].merkleTreeDepth,
                merkleTreeRoot: cheatProofs[i].merkleTreeRoot,
                nullifier: cheatProofs[i].nullifier,
                message: cheatProofs[i].message,
                scope: scope,
                points: cheatProofs[i].points
            });
        }

        vm.expectRevert(NotEnoughProofs.selector);
        obscurus.obscureExecAndReturnData({
            to: recipient,
            value: value,
            data: "",
            operation: Enum.Operation.Call,
            proofs: proofs
        });
    }

    function test_cannot_obscureExecAndReturnDataWithInvalidProof() public {
        uint256[] memory ownerPKs = new uint256[](1);
        ownerPKs[0] = 12345;

        uint256 obscurusThreshold = 2;
        uint256 numIdentities = 3;

        (SemaphoreCheatIdentity[] memory identities, uint256[] memory identitiesCommitments) =
            generateIdentitiesFull(numIdentities);

        Obscurus obscurus = _setupObscurus(ownerPKs, address(semaphore), obscurusThreshold, identitiesCommitments);

        address recipient = address(0xA11c3);
        uint256 value = 1 ether;

        uint256 scope = obscurus.computeScope(recipient, value, "", Enum.Operation.Call);
        uint256 signal = obscurus.computeSignal();

        SemaphoreCheatProof[] memory cheatProofs = new SemaphoreCheatProof[](numIdentities);
        ISemaphore.SemaphoreProof[] memory proofs = new ISemaphore.SemaphoreProof[](numIdentities);

        for (uint256 i = 0; i < numIdentities; i++) {
            cheatProofs[i] = generateProof(identities[i], identities, Strings.toString(signal), Strings.toString(scope));
            proofs[i] = ISemaphore.SemaphoreProof({
                merkleTreeDepth: cheatProofs[i].merkleTreeDepth,
                merkleTreeRoot: cheatProofs[i].merkleTreeRoot,
                nullifier: cheatProofs[i].nullifier,
                message: cheatProofs[i].message,
                scope: scope,
                points: cheatProofs[i].points
            });
        }

        // corrupt the first proof
        cheatProofs[0].points[0] += 1;

        vm.expectRevert(ISemaphore.Semaphore__InvalidProof.selector);
        obscurus.obscureExecAndReturnData({
            to: recipient,
            value: value,
            data: "",
            operation: Enum.Operation.Call,
            proofs: proofs
        });
    }
}
