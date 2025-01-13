// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {Script} from "forge-std/Script.sol";
import {ISemaphoreVerifier} from "@semaphore-protocol/contracts/interfaces/ISemaphoreVerifier.sol";
import {SemaphoreVerifier} from "@semaphore-protocol/contracts/base/SemaphoreVerifier.sol";
import {ISemaphore} from "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";
import {Semaphore} from "@semaphore-protocol/contracts/Semaphore.sol";
import {Safe, Enum as SafeEnum} from "safe-contracts/Safe.sol";
import "safe-tools/SafeTestTools.sol";
import "forge-std/Test.sol";

import "./DeployConfig.holesky.sol";
import "./IDeployConfig.sol";
import "@src/Obscurus.sol";

contract DeployForkHolesky is Script, Test, SafeTestTools {
    using SafeTestLib for SafeInstance;

    IDeployConfig internal dc;
    IDeployConfig.Configuration internal cfg;

    function setUp() external {
        dc = new DeployConfigHolesky();
        cfg = dc.getConfiguration();
    }

    function run() external {
        vm.startBroadcast();
        ISemaphore semaphore = _deploySemaphore();
        Obscurus obscurus = _deployObscurus(semaphore);
        _deployModule(obscurus);
        vm.stopBroadcast();
    }

    function _deploySemaphore() internal returns (ISemaphore semaphore) {
        SemaphoreVerifier semaphoreVerifier = new SemaphoreVerifier();
        semaphore = new Semaphore(ISemaphoreVerifier(address(semaphoreVerifier)));
    }

    function _deployObscurus(ISemaphore _semaphore) internal returns (Obscurus obscurus) {
        obscurus = new Obscurus({
            _safe: cfg.safe,
            _semaphore: address(_semaphore),
            _threshold: cfg.threshold,
            _identities: cfg.identities
        });
    }

    function _deployModule(Obscurus _obscurus) internal {
        bytes32 txHash = Safe(payable(cfg.safe)).getTransactionHash(
            address(cfg.safe),
            0,
            abi.encodeWithSelector(Safe(payable(cfg.safe)).enableModule.selector, address(_obscurus)),
            Enum.Operation.Call,
            0,
            0,
            0,
            address(0),
            address(0),
            Safe(payable(cfg.safe)).nonce()
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(vm.envUint("ODS_SAFE_OWNER_PK"), txHash);

        bytes memory signatures;
        signatures = bytes.concat(signatures, abi.encodePacked(r, s, v));

        address signer = ecrecover(txHash, v, r, s);
        console.log("Signer: %s", signer);
        console.log("V: %s", v);

        (v, r, s) = signatureSplit(signatures, 0);
        signer = ecrecover(txHash, v, r, s);
        console.log("Signer: %s", signer);
        console.log("V: %s", v);

        address lastOwner = address(0);
        require(signer > lastOwner && true, "GS026");

        Safe(payable(cfg.safe)).execTransaction(
            address(cfg.safe),
            0,
            abi.encodeWithSelector(Safe(payable(cfg.safe)).enableModule.selector, address(_obscurus)),
            Enum.Operation.Call,
            0,
            0,
            0,
            address(0),
            payable(0),
            signatures
        );
    }

    function signatureSplit(bytes memory signatures, uint256 pos)
        internal
        pure
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            let signaturePos := mul(0x41, pos)
            r := mload(add(signatures, add(signaturePos, 0x20)))
            s := mload(add(signatures, add(signaturePos, 0x40)))
            /**
             * Here we are loading the last 32 bytes, including 31 bytes
             * of 's'. There is no 'mload8' to do this.
             * 'byte' is not working due to the Solidity parser, so lets
             * use the second best option, 'and'
             */
            v := and(mload(add(signatures, add(signaturePos, 0x41))), 0xff)
        }
    }
}
