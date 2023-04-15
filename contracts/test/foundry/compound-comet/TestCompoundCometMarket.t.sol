// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import {BaseTestLendingMarket} from "../BaseTestLendingMarket.sol";
import {CompoundCometMarket} from "../../../src/compound-comet/CompoundCometMarket.sol";
import {CometMainInterface} from "../../../src/interfaces/compound-v3/CometMainInterface.sol";

contract TestCompoundCometInterface is BaseTestLendingMarket {
    CometMainInterface comet;

    function setUp() public override {
        NETWORK = "mainnet";
        FORK_BLOCK_NUMBER = 16990000;

        comet = CometMainInterface(0xc3d688B66703497DAA19211EEdff47f25384cdc3);
        interestBearingToken = comet;
        asset = comet.baseToken();
    }

    function _deploy() internal {
        market = address(new CompoundCometMarket(comet));
    }

    function _convertToUnderlying(uint256 amount) internal override returns (uint256) {
        return amount;
    }
}
