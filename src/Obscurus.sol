// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {Module} from "zodiac/core/Module.sol";
import {Safe, Enum as SafeEnum} from "safe-contracts/Safe.sol";
import {ISemaphore} from "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";
import {LibString} from "solady/utils/LibString.sol";

import "./Errors.sol";

/// @title Obscurus Zodiac Module for Safe Wallet.
/// @author 0xpanoramix @ Quartz
/// @notice A module attached to a multisig, managing the group of identities that anonymously approve and execute transactions.
contract Obscurus is Module {
    using LibString for bytes;

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     STORAGE                                                          */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    /// @notice TODO: Add a description.
    ISemaphore public semaphore;

    /// @notice TODO: Add a description.
    uint256 public groupID;

    /// @notice TODO: Add a description.
    uint256 public threshold;

    /// @notice TODO: Add a description.
    uint256 public nonce;

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     EVENTS                                                           */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    /// @notice Emitted when a new threshold is set.
    ///
    /// @param threshold The new threshold value.
    event ThresholdSet(uint256 threshold);

    /// @notice Emitted when a new member is added to the group of identities managing the Obscurus Module.
    ///
    /// @param identityCommitment The identity commitment of the new member managing the Obscurus Module.
    event MemberAdded(uint256 identityCommitment);

    /// @notice Emitted when multiple new members are added to the group of identities managing the Obscurus Module.
    ///
    /// @param identityCommitments The identity commitments of the new members managing the Obscurus Module.
    event MembersAdded(uint256[] identityCommitments);

    /// @notice Emitted when a transaction is executed.
    ///
    /// @param scope The scope of the transaction.
    /// @param success The status of the transaction execution.
    event TransactionExecuted(uint256 scope, bool success);

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     CONSTRUCTOR                                                      */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    /// @notice Initializes the Obscurus module with the provided parameters.
    ///
    /// @param _safe TODO: Add a description.
    /// @param _semaphore TODO: Add a description.
    /// @param _threshold TODO: Add a description.
    /// @param _identities TODO: Add a description.
    constructor(address _safe, address _semaphore, uint256 _threshold, uint256[] memory _identities) {
        bytes memory initializeParams = abi.encode(_safe, _semaphore, _threshold, _identities);
        setUp(initializeParams);
    }

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     MODULE PROXY FACTORY                                             */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    /// @notice TODO: Add a description.
    ///
    /// @param initializeParams TODO: Add a description.
    function setUp(bytes memory initializeParams) public override initializer {
        __Ownable_init(msg.sender);
        (address _safe, address _semaphore, uint256 _threshold, uint256[] memory _identities) =
            abi.decode(initializeParams, (address, address, uint256, uint256[]));

        // TODO: Check if the threshold is <= the number of identities.

        setAvatar(_safe);
        setTarget(_safe);
        transferOwnership(_safe);

        semaphore = ISemaphore(_semaphore);
        _setThreshold(_threshold);
        groupID = semaphore.createGroup();
        _addMembers(_identities);
    }

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     OBSCURUS CORE LOGIC                                              */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    /// @notice TODO: Add a description.
    ///
    /// @param _to Transaction destination address.
    /// @param _value Transaction value.
    /// @param _data Transaction data.
    /// @param _operation Transaction operation type.
    ///
    /// @return TODO: Add a description.
    function computeScope(address _to, uint256 _value, bytes memory _data, SafeEnum.Operation _operation)
        public
        view
        returns (uint256)
    {
        Safe safe = Safe(payable(address(avatar)));
        bytes32 safeTxHash =
            safe.getTransactionHash(_to, _value, _data, _operation, 0, 0, 0, address(0), payable(0), nonce);
        bytes32 messageHash = keccak256(
            (bytes.concat("\x19Ethereum Signed Message:\n", "66", bytes(abi.encode(safeTxHash).toHexString())))
        );

        return uint256(messageHash);
    }

    /// @notice TODO: Add a description.
    function computeSignal() public view returns (uint256) {
        address obscurusAddress = address(this);
        uint256 chainID;

        assembly {
            chainID := chainid()
        }

        return uint256(keccak256(abi.encodePacked(obscurusAddress, chainID, nonce)));
    }

    /// @notice TODO: Add a description.
    ///
    /// @param _to Transaction destination address.
    /// @param _value Transaction value.
    /// @param _data Transaction data.
    /// @param _operation Transaction operation type.
    /// @param _proofs TODO: Add a description.
    ///
    /// @return success TODO: Add a description.
    /// @return returnData TODO: Add a description.
    function obscureExecAndReturnData(
        address _to,
        uint256 _value,
        bytes calldata _data,
        SafeEnum.Operation _operation,
        ISemaphore.SemaphoreProof[] memory _proofs
    ) external returns (bool success, bytes memory returnData) {
        uint256 scope = computeScope(_to, _value, _data, _operation);
        uint256 signal = computeSignal();

        if (_proofs.length < threshold) {
            revert NotEnoughProofs();
        }

        for (uint256 i = 0; i < _proofs.length; i++) {
            if (_proofs[i].scope != scope) {
                revert InvalidScope();
            }

            if (_proofs[i].message != signal) {
                revert InvalidSignal();
            }

            semaphore.validateProof(groupID, _proofs[i]);
        }

        nonce += 1;
        (success, returnData) = execAndReturnData(_to, _value, _data, _operation);

        emit TransactionExecuted(scope, success);
    }

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     PUBLIC SETTERS                                                   */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    function setThreshold(uint256 _threshold) external onlyOwner {
        _setThreshold(_threshold);
    }

    function addMember(uint256 _identityCommitment) external onlyOwner {
        _addMember(_identityCommitment);
    }

    function addMembers(uint256[] memory _identityCommitments) external onlyOwner {
        _addMembers(_identityCommitments);
    }

    /*----------------------------------------------------------------------*/
    /*                                                                      */
    /*     INTERNAL SETTERS                                                 */
    /*                                                                      */
    /*----------------------------------------------------------------------*/

    function _setThreshold(uint256 _threshold) internal {
        if (_threshold == 0) {
            revert ThresholdZero();
        }

        threshold = _threshold;

        emit ThresholdSet(_threshold);
    }

    function _addMember(uint256 _identityCommitment) internal {
        semaphore.addMember(groupID, _identityCommitment);

        emit MemberAdded(_identityCommitment);
    }

    function _addMembers(uint256[] memory _identityCommitments) internal {
        semaphore.addMembers(groupID, _identityCommitments);

        emit MembersAdded(_identityCommitments);
    }
}
