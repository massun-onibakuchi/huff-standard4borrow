// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "forge-std/Test.sol";

import "../../src/interfaces/ILendingMarket.sol";
import "../../src/LendingMarketBase.sol";

import {IERC20, IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

contract LendingMarketBaseHarness is LendingMarketBase {
    function checkRevertIfNotAllowed(address owner, address account) public view {
        _requirePermission(owner, account);
    }

    function supply(address asset, uint256 amount, address receiver) external override returns (uint256) {}

    function withdraw(address asset, uint256 amount, address receiver) external override returns (uint256) {}

    function borrow(
        address asset,
        uint256 amount,
        address receiver,
        address owner
    ) external override returns (uint256) {}

    function repay(address asset, uint256 amount, address onBehalfOf) external override returns (uint256) {}
}

abstract contract BaseTestLendingMarketBase is Test {
    address market;

    function setUp() public virtual;

    function _afterSetUp() internal virtual {
        vm.label(market, "market");
    }

    function testRevert_IfNotAllowed(address owner, address delegatee) public {
        //setUp
        vm.assume(owner != delegatee);
        vm.assume(!ILendingMarket(market).isAllowed(owner, delegatee));
        // execution & assert
        vm.expectRevert();
        LendingMarketBaseHarness(market).checkRevertIfNotAllowed(owner, delegatee);
    }

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
