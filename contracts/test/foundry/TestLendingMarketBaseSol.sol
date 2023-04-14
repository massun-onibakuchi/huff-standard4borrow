// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "forge-std/Test.sol";

import "../../src/interfaces/ILendingMarket.sol";
import "../../src/LendingMarketBase.sol";
import {LendingMarketBaseHarness, BaseTestLendingMarketBase} from "./BaseTestLendingMarketBase.sol";

contract TestLendingMarketBaseSol is BaseTestLendingMarketBase {
    function setUp() public override {
        market = address(new LendingMarketBaseHarness());
        _afterSetUp();
    }
}
