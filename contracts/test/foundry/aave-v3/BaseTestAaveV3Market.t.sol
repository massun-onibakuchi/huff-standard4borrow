// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "../../../src/interfaces/aave-v3/IAaveProtocolDataProvider.sol";
import "../../../src/interfaces/aave-v3/IPoolAddressesProvider.sol";

import {AaveV3Market} from "../../../src/aave-v3/AaveV3Market.sol";

import "../BaseTestLendingMarket.sol";

interface IDebtTokenLike {
    function approveDelegation(address delegatee, uint256 amount) external;
}

abstract contract BaseTestAaveV3Market is BaseTestLendingMarket {
    IPoolAddressesProvider PROVIDER;
    address debtToken;

    function setUp() public virtual override {
        require(asset != address(0), "asset is not set");

        address dataProvider = PROVIDER.getPoolDataProvider();
        (address _aToken, , address _debtToken) = IAaveProtocolDataProvider(dataProvider).getReserveTokensAddresses(
            asset
        );
        interestBearingToken = _aToken;
        debtToken = _debtToken;
        market = _deploy();

        _afterSetUp();

        vm.label(address(PROVIDER), "provider");
        vm.label(PROVIDER.getPool(), "pool");
        vm.label(debtToken, "debtToken");
        vm.label(dataProvider, "poolDataProvider");

        // console2.log("provider", address(PROVIDER));
        // console2.log("poolDataProvider", dataProvider);
        // console2.log("ibToken", interestBearingToken);
    }

    function _deploy() internal virtual returns (address _market) {
        _market = address(new AaveV3Market(PROVIDER));
    }

    function _convertToUnderlying(uint256 amount) internal pure override returns (uint256) {
        return amount;
    }

    function _setUpBeforeTestBorrow() internal override {
        IDebtTokenLike(debtToken).approveDelegation(market, type(uint256).max);
    }
}
