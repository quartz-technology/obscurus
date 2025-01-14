// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

/// @dev This error is emitted when trying to set the threshold for Obscurus to zero.
error ThresholdZero();

error InvalidScope();

error InvalidSignal();

/// @dev This error is emitted when trying to execute a transaction and the number of submitted proofs is less than the threshold.
error NotEnoughProofs();
