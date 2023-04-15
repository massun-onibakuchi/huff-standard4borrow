// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Test.sol";

import {IERC20, IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

import {ILendingMarket} from "../../../src/interfaces/ILendingMarket.sol";
import {BorrowFiAggregator} from "../../../src/BorrowFiAggregator.sol";

abstract contract BaseTestBorrowFiAggregator is Test {
    string NETWORK;
    uint256 FORK_BLOCK_NUMBER;

    address market;
    address asset;
    address interestBearingToken;

    /// @dev assume collateral is already deposited to the lending protocol
    ///  weth is used as collateral
    address weth;
    uint256 initialWethCollateral;
    uint256 decimals;
    // address receiver = makeAddr("receiver");

    address aaveV3AddressesProvider;
    BorrowFiAggregator aggregator;

    address owner = makeAddr("owner");

    function setUp() public virtual {
        decimals = IERC20Metadata(asset).decimals();

        _deploy();
        _depositCollateral();

        _afterSetUp();
    }

    function _deploy() internal virtual;

    // deposit weth as collateral to the lending protocol
    function _depositCollateral() internal virtual {
        initialWethCollateral = 10 ether;
        // fund weth to this contract
        deal(weth, address(this), initialWethCollateral, false);
        // approve weth
        IERC20(weth).approve(market, type(uint256).max);
        // deposit weth as collateral
        ILendingMarket(market).supply(weth, initialWethCollateral, address(this));
    }

    function _afterSetUp() internal virtual {
        vm.label(weth, "weth");
        vm.label(asset, "asset");
        vm.label(interestBearingToken, "ibToken");
        vm.label(market, "market");
    }

    function testSetUp_Ok() public virtual;

    function testSetWrapper_Ok(bool value) public virtual {
        // setUp
        // execution
        vm.prank(owner);
        aggregator.setWrapper(address(0xf00),value);
        // assert
        assertEq(aggregator.isWhitelistedWrapper(address(0xf00)), value, "wrapper is not set correctly");
    }

    function testSetWrapper_RevertIfNotOwner() public virtual {
        // setUp
        vm.prank(makeAddr("notOwner"));
        // execution
        // assert
        vm.expectRevert("Ownable: caller is not the owner");
        aggregator.setWrapper(address(0xf00), true);
    }

    function testAggregateBorrow_Ok() public virtual {
        // setUp
        // create param
        uint256 borrowAmount = 1 * (10 ** decimals);
        BorrowFiAggregator.Calldata[] memory data = new BorrowFiAggregator.Calldata[](1);
        data[0] = BorrowFiAggregator.Calldata({wrapper: market, amount: borrowAmount});
        // allow aggregator to borrow
        ILendingMarket(market).allow(address(aggregator), true);
        // get balance before
        uint balBefore = IERC20(asset).balanceOf(address(this));

        // execution
        aggregator.aggregateBorrow(asset, data);

        // assert
        assertEq(IERC20(asset).balanceOf(address(this)), balBefore + borrowAmount, "borrow amount");
    }

    function testAggregateBorrow_RevertIfWrapperIsNotRegistered() public virtual {}

    function testAggregateBorrow_RevertIfAggregatorIsNotAllowed() public virtual {}
}
