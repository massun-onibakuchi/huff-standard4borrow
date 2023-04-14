// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "forge-std/Test.sol";

import "../../src/interfaces/ILendingMarket.sol";

import {IERC20, IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

abstract contract BaseTestLendingMarket is Test {
    string NETWORK;
    uint256 FORK_BLOCK_NUMBER;

    address market;
    address asset;
    address interestBearingToken;

    uint256 initialBalance;
    uint256 decimals;
    address receiver = makeAddr("receiver");

    function setUp() public virtual;

    function _afterSetUp() internal virtual {
        vm.label(asset, "asset");
        vm.label(interestBearingToken, "ibToken");
        vm.label(market, "market");

        decimals = IERC20Metadata(asset).decimals();
        initialBalance = 10000 * (10 ** decimals);
        deal(asset, address(this), initialBalance, true);
        IERC20(asset).approve(market, type(uint256).max);
        IERC20(interestBearingToken).approve(market, type(uint256).max);
    }

    function testSupply_Ok() public {
        //setUp
        uint256 amount = 100;
        uint256 expectedBal = _convertToUnderlying(amount);
        //execution
        uint256 gas = gasleft();
        uint256 deposited = ILendingMarket(market).supply(asset, amount, receiver);
        console2.log("gasUsed :>>", gas - gasleft()); // https://etherscan.io/tx/0x8f752b2961a9a65cb65f3cce19d508320a03e0d75437ccdd543b2b5c31722ae3
        //assert
        assertEq(deposited, expectedBal, "deposited amount");
        assertEq(IERC20(asset).balanceOf(address(this)), initialBalance - amount, "sender balance");
        assertEq(IERC20(asset).balanceOf(market), 0, "market balance");
    }

    function testWithdraw_Ok() public {
        //setUp
        uint256 amount = 100;
        uint256 expectedBal = _convertToUnderlying(amount);
        ILendingMarket(market).supply(asset, amount, address(this));
        //execution
        // https://www.rareskills.io/ethereum-gas-price-calculator
        uint256 gas = gasleft();
        uint256 withdrawn = ILendingMarket(market).withdraw(asset, amount, receiver);
        console2.log("gasUsed :>>", gas - gasleft());
        //assert
        assertEq(withdrawn, expectedBal, "withdrawn amount");
        assertEq(IERC20(asset).balanceOf(address(this)), initialBalance - amount, "sender balance");
        assertEq(IERC20(asset).balanceOf(receiver), amount, "reciever balance");
        assertEq(IERC20(asset).balanceOf(market), 0, "market balance");
    }

    function testBorrow_WhenSenderIsOwner() public {
        //setUp
        uint256 amount = 10 ** decimals;
        ILendingMarket(market).supply(asset, 1000 * amount, address(this));
        _setUpBeforeTestBorrow();
        //execution
        uint256 gas = gasleft();
        uint256 borrowed = ILendingMarket(market).borrow(asset, amount, receiver, address(this));
        console2.log("gasUsed :>>", gas - gasleft());
        //assert
        assertEq(borrowed, amount, "borrowed amount");
        assertEq(IERC20(asset).balanceOf(address(this)), initialBalance - 1000 * amount, "sender balance");
        assertEq(IERC20(asset).balanceOf(receiver), amount, "reciever balance");
        assertEq(IERC20(asset).balanceOf(market), 0, "market balance");
    }

    function testBorrow_WhenSenderIsNotOwner() public {
        //setUp
        uint256 amount = 10 ** decimals;
        ILendingMarket(market).supply(asset, 1000 * amount, address(this));
        _setUpBeforeTestBorrow();
        vm.prank(address(this));
        ILendingMarket(market).allow(receiver, true);
        //execution
        uint256 gas = gasleft();
        vm.prank(receiver);
        uint256 borrowed = ILendingMarket(market).borrow(asset, amount, receiver, address(this));
        console2.log("gasUsed :>>", gas - gasleft());
        //assert
        assertEq(borrowed, amount, "borrowed amount");
        assertEq(IERC20(asset).balanceOf(address(this)), initialBalance - 1000 * amount, "sender balance");
        assertEq(IERC20(asset).balanceOf(receiver), amount, "reciever balance");
        assertEq(IERC20(asset).balanceOf(market), 0, "market balance");
    }

    function testBorrow_RevertIfSenderIsNotAllowedByOwner() public {
        //setUp
        uint256 amount = 10 ** decimals;
        ILendingMarket(market).supply(asset, 1000 * amount, address(this));
        _setUpBeforeTestBorrow();
        //execution
        vm.prank(address(this));
        // `this` contract is not allowed to borrow on behalf of `owner`
        ILendingMarket(market).allow(receiver, false);
        //assert
        _expectRevert_WhenSenderISNotAllowedByOwner();
        vm.prank(receiver);
        ILendingMarket(market).borrow(asset, amount, receiver, address(this));
    }

    function _expectRevert_WhenSenderISNotAllowedByOwner() internal virtual {
        vm.expectRevert("LendingMarketBase: not allowed");
    }

    function testRepay_Ok() public {
        //setUp
        uint256 amount = 10 ** decimals;
        ILendingMarket(market).supply(asset, 1000 * amount, address(this));
        _setUpBeforeTestBorrow();
        ILendingMarket(market).borrow(asset, amount, receiver, address(this));
        //execution
        uint256 repayed = ILendingMarket(market).repay(asset, amount, address(this));
        //assert
        assertEq(repayed, amount, "repayed amount");
        assertEq(IERC20(asset).balanceOf(address(this)), initialBalance - 1000 * amount - amount, "sender balance");
        assertEq(IERC20(asset).balanceOf(market), 0, "market balance");
    }

    function _setUpBeforeTestBorrow() internal virtual;

    function _convertToUnderlying(uint256 amount) internal virtual returns (uint256);

    // ************************************************************ //
    // allow method
    // ************************************************************ //

    function testAllow_Ok(address delegatee) public {
        //execution
        ILendingMarket(market).allow(delegatee, true);
        //assert
        assertTrue(ILendingMarket(market).isAllowed(address(this), delegatee), "allowed");

        //execution
        ILendingMarket(market).allow(delegatee, false);
        //assert
        assertFalse(ILendingMarket(market).isAllowed(address(this), delegatee), "not allowed");
    }
}
