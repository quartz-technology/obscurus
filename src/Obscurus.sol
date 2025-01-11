// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {Module} from "zodiac/core/Module.sol";
import {Safe, Enum as SafeEnum} from "safe-contracts/Safe.sol";
import "@semaphore-protocol/contracts/interfaces/ISemaphore.sol";
import {LibString} from "solady/utils/LibString.sol";

import "./Errors.sol";

contract Obscurus is Module {
    using LibString for bytes;

    ISemaphore public semaphore;
    uint256 threshold;
    uint256 public groupID;

    constructor(
        address _safe,
        address _semaphore,
        uint256 _threshold,
        uint256[] memory _identities
    ) {
        bytes memory initializeParams = abi.encode(
            _safe,
            _semaphore,
            _threshold,
            _identities
        );
        setUp(initializeParams);
    }

    function setUp(bytes memory initializeParams) public override initializer {
        __Ownable_init(msg.sender);
        (
            address _safe,
            address _semaphore,
            uint256 _threshold,
            uint256[] memory _identities
        ) = abi.decode(
                initializeParams,
                (address, address, uint256, uint256[])
            );

        setAvatar(_safe);
        setTarget(_safe);
        transferOwnership(_safe);

        semaphore = ISemaphore(_semaphore);
        _setThreshold(_threshold);
        groupID = semaphore.createGroup();
        _addMembers(_identities);
    }

    function _setThreshold(uint256 _threshold) internal {
        if (_threshold == 0) {
            revert ThresholdZero();
        }

        threshold = _threshold;
    }

    function setThreshold(uint256 _threshold) external onlyOwner {
        _setThreshold(_threshold);
    }

    function _addMember(uint256 identityCommitment) internal {
        semaphore.addMember(groupID, identityCommitment);
    }

    function addMember(uint256 identityCommitment) external onlyOwner {
        _addMember(identityCommitment);
    }

    function _addMembers(uint256[] memory identityCommitments) internal {
        semaphore.addMembers(groupID, identityCommitments);
    }

    function addMembers(
        uint256[] memory identityCommitments
    ) external onlyOwner {
        _addMembers(identityCommitments);
    }

    function computeScope(
        address to,
        uint256 value,
        bytes memory data,
        SafeEnum.Operation operation
    ) public view returns (uint256) {
        Safe safe = Safe(payable(address(avatar)));
        uint256 nonce = safe.nonce();
        bytes32 safeTxHash = safe.getTransactionHash(
            to,
            value,
            data,
            operation,
            0,
            0,
            0,
            address(0),
            payable(0),
            nonce
        );
        bytes32 messageHash = keccak256(
            (
                bytes.concat(
                    "\x19Ethereum Signed Message:\n",
                    "66",
                    bytes(abi.encode(safeTxHash).toHexString())
                )
            )
        );

        return uint256(messageHash);
    }

    function computeSignal() public pure returns (uint256) {
        return 1;
    }

    function obscureExecAndReturnData(
        address to,
        uint256 value,
        bytes calldata data,
        SafeEnum.Operation operation,
        ISemaphore.SemaphoreProof[] memory proofs
    ) external returns (bool success, bytes memory returnData) {
        uint256 scope = computeScope(to, value, data, operation);

        if (proofs.length < threshold) {
            revert NotEnoughProofs();
        }

        for (uint256 i = 0; i < proofs.length; i++) {
            proofs[i].scope = scope;
            semaphore.validateProof(groupID, proofs[i]);
        }

        (success, returnData) = execAndReturnData(to, value, data, operation);
    }
}
