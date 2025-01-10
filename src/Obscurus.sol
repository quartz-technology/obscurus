// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

import {Module} from "zodiac/core/Module.sol";
import {Safe, Enum as SafeEnum} from "safe-contracts/Safe.sol";

import "./Errors.sol";

contract Obscurus is Module {
    uint256 threshold;

    constructor(address _safe, uint256 _threshold) {
        bytes memory initializeParams = abi.encode(_safe, _threshold);
        setUp(initializeParams);
    }

    function setUp(bytes memory initializeParams) public override initializer {
        __Ownable_init(msg.sender);
        (address _safe, uint256 _threshold) = abi.decode(initializeParams, (address, uint256));

        setAvatar(_safe);
        setTarget(_safe);
        transferOwnership(_safe);

        _setThreshold(_threshold);
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

    function obscureExecAndReturnData(address to, uint256 value, bytes calldata data, SafeEnum.Operation operation)
        external
        returns (bool success, bytes memory returnData)
    {
        (success, returnData) = execAndReturnData(to, value, data, operation);
    }
}
