// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import {BaseTestLendingMarketBase} from "./BaseTestLendingMarketBase.sol";

contract TestLendingMarketBaseHuff is BaseTestLendingMarketBase {
    function setUp() public override {
        market = HuffDeployer.config().deploy("test/LendingMarketBaseHarness");
        _afterSetUp();
    }
}
