// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.10;

interface IAaveProtocolDataProvider {
    /// @param asset The address of the underlying asset of the reserve
    function getReserveTokensAddresses(
        address asset
    ) external view returns (address aTokenAddress, address stableDebtTokenAddress, address variableDebtTokenAddress);
}
