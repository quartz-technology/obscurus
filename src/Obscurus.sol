// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {Module} from "zodiac/core/Module.sol";
import {Safe} from "safe-contracts/Safe.sol";
import {ISemaphore} from "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";
import {LibString} from "solady/utils/LibString.sol";

import {IObscurus} from "@src/interfaces/IObscurus.sol";

contract Obscurus is Module, IObscurus {
    using LibString for bytes;

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     STORAGE                                                          */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    ISemaphore public semaphore;

    uint256 public groupID;

    uint256 public threshold;

    uint256 public numIdentities;

    uint256 public nonce;

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     CONSTRUCTOR                                                      */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    constructor(InitParameters memory params) {
        bytes memory initializeParams = abi.encode(params);
        setUp(initializeParams);
    }

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     MODULE PROXY FACTORY                                             */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    function setUp(bytes memory initializeParams) public override initializer {
        __Ownable_init(msg.sender);
        (InitParameters memory params) = abi.decode(initializeParams, (InitParameters));

        setAvatar(params.safe);
        setTarget(params.safe);
        transferOwnership(params.safe);

        semaphore = ISemaphore(params.semaphore);
        groupID = semaphore.createGroup();

        _addMembers(params.identities);
        _setThreshold(params.threshold);
    }

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     OBSCURUS CORE LOGIC                                              */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    function obscureExec(ObscureExecParameters memory params) external override returns (bool) {
        _preObscureExec(params);

        bool success = exec(
            params.txParameters.to, params.txParameters.value, params.txParameters.data, params.txParameters.operation
        );

        _postObscureExec(success, params);

        return success;
    }

    function obscureExecAndReturnData(ObscureExecParameters memory params)
        external
        override
        returns (bool, bytes memory)
    {
        _preObscureExec(params);

        (bool success, bytes memory returnData) = execAndReturnData(
            params.txParameters.to, params.txParameters.value, params.txParameters.data, params.txParameters.operation
        );

        _postObscureExec(success, params);

        return (success, returnData);
    }

    function computeScope(TxParameters memory params) public view override returns (uint256) {
        Safe safe = Safe(payable(address(avatar)));
        bytes32 safeTxHash = safe.getTransactionHash(
            params.to, params.value, params.data, params.operation, 0, 0, 0, address(0), payable(0), nonce
        );
        bytes32 messageHash = keccak256(
            (bytes.concat("\x19Ethereum Signed Message:\n", "66", bytes(abi.encode(safeTxHash).toHexString())))
        );

        return uint256(messageHash);
    }

    function computeSignal() public view override returns (uint256) {
        address obscurusAddress = address(this);
        uint256 chainID;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            chainID := chainid()
        }

        return uint256(keccak256(abi.encodePacked(obscurusAddress, chainID, nonce)));
    }

    function _preObscureExec(ObscureExecParameters memory params) internal {
        _verifyObscureExec(params);
        nonce += 1;
    }

    function _postObscureExec(bool success, ObscureExecParameters memory params) internal {
        emit ObscureTransactionExecuted(success, params.semaphoreProofs[0].scope);
    }

    function _verifyObscureExec(ObscureExecParameters memory params) internal {
        uint256 scope = computeScope(params.txParameters);
        uint256 signal = computeSignal();

        if (params.semaphoreProofs.length < threshold) {
            revert InvalidExecutionNotEnoughProofs();
        }

        for (uint256 i = 0; i < params.semaphoreProofs.length; i++) {
            if (params.semaphoreProofs[i].scope != scope) {
                revert InvalidExecutionScope();
            }

            if (params.semaphoreProofs[i].message != signal) {
                revert InvalidExecutionSignal();
            }

            semaphore.validateProof(groupID, params.semaphoreProofs[i]);
        }
    }

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     PUBLIC SETTERS                                                   */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    function setThreshold(uint256 _newThreshold) external override onlyOwner {
        _setThreshold(_newThreshold);
    }

    function addMember(uint256 _newMemberIdentityCommitment) external override onlyOwner {
        _addMember(_newMemberIdentityCommitment);
    }

    function addMembers(uint256[] memory _newMembersIdentityCommitments) external override onlyOwner {
        _addMembers(_newMembersIdentityCommitments);
    }

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     INTERNAL SETTERS                                                 */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    function _setThreshold(uint256 _newThreshold) internal {
        if (_newThreshold == 0) {
            revert InvalidThresholdZero();
        }

        if (_newThreshold > numIdentities) {
            revert InvalidThresholdTooHigh();
        }

        threshold = _newThreshold;

        emit ThresholdSet(_newThreshold);
    }

    function _addMember(uint256 _identityCommitment) internal {
        semaphore.addMember(groupID, _identityCommitment);

        numIdentities += 1;

        emit MemberAdded(_identityCommitment);
    }

    function _addMembers(uint256[] memory _identityCommitments) internal {
        semaphore.addMembers(groupID, _identityCommitments);

        numIdentities += _identityCommitments.length;

        emit MembersAdded(_identityCommitments);
    }
}
