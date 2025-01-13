// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.27;

interface IDeployConfig {
    error DeploymentConfigurationError(string);

    struct Configuration {
        address safe;
        uint256 threshold;
        uint256[] identities;
    }

    function getConfiguration() external returns (Configuration memory);
}
