// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {Enum as SafeEnum} from "safe-contracts/Safe.sol";
import {ISemaphore} from "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";

interface IObscurus {
    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     STRUCTS                                                          */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    struct InitParameters {
        address safe;
        address semaphore;
        uint256[] identities;
        uint256 threshold;
    }

    struct TxParameters {
        address to;
        uint256 value;
        bytes data;
        SafeEnum.Operation operation;
    }

    struct ObscureExecParameters {
        TxParameters txParameters;
        ISemaphore.SemaphoreProof[] semaphoreProofs;
    }

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     EVENTS                                                           */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    event ThresholdSet(uint256 newThreshold);

    event MemberAdded(uint256 newMemberIdentityCommitment);

    event MembersAdded(uint256[] newMembersIdentityCommitments);

    event ObscureTransactionExecuted(bool success, uint256 scope);

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     ERRORS                                                           */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    error InvalidThresholdZero();

    error InvalidThresholdTooHigh();

    error InvalidExecutionNotEnoughProofs();

    error InvalidExecutionScope();

    error InvalidExecutionSignal();

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     OBSCURUS CORE LOGIC                                              */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    function obscureExec(ObscureExecParameters memory params) external returns (bool);

    function obscureExecAndReturnData(ObscureExecParameters memory params) external returns (bool, bytes memory);

    function computeScope(TxParameters memory params) external view returns (uint256);

    function computeSignal() external view returns (uint256);

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     PUBLIC SETTERS                                                   */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    function setThreshold(uint256 _newThreshold) external;

    function addMember(uint256 _newMemberIdentityCommitment) external;

    function addMembers(uint256[] memory _newMembersIdentityCommitments) external;
}
