// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import {BaseTestBorrowFiAggregator} from "./BaseTestBorrowFiAggregator.t.sol";

import {MockLendingMarket} from "../mocks/MockLendingMarket.sol";

import {BorrowFiAggregator} from "../../../src/BorrowFiAggregator.sol";

contract TestBorrowFiAggregatorForMock is BaseTestBorrowFiAggregator {
    address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

    function setUp() public override {
        NETWORK = "mainnet";
        FORK_BLOCK_NUMBER = 16990000;
        asset = DAI;
        aaveV3AddressesProvider = 0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e;
        weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        vm.createSelectFork(NETWORK, FORK_BLOCK_NUMBER);

        super.setUp();
    }

    function _deploy() internal override {
        // NOTE: deployer is owner
        vm.prank(owner);
        aggregator = new BorrowFiAggregator(aaveV3AddressesProvider);
        market = address(new MockLendingMarket(asset, 1.2 * 1e18));

        vm.prank(owner);
        aggregator.setWrapper(address(market), BorrowFiAggregator.WrapperType.Mock);

        deal(asset, market, 10000 * (1e18), true);
    }
    
    function testSetUp_Ok() public override {
        assertEq(aggregator.owner(), owner, "owner is not set correctly");
        assertEq(
            uint8(aggregator.getWrapperType(market)),
            uint8(BorrowFiAggregator.WrapperType.Mock),
            "wrapperType is not set correctly"
        );
    }
}
