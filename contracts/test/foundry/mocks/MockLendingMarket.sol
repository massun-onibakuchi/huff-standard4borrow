// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.10;

import "../../../src/LendingMarketBase.sol";

import {MockERC20} from "./MockERC20.sol";
import {IERC20, IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

contract MockLendingMarket is LendingMarketBase {
    uint256 public constant SCALE = 1e18;

    MockERC20 public immutable asset;
    MockERC20 public immutable ibToken;
    MockERC20 public immutable debtToken;
    uint256 public immutable price;

    constructor(address _asset, uint256 _price) {
        string memory name = IERC20Metadata(_asset).name();
        string memory symbol = IERC20Metadata(_asset).symbol();
        asset = MockERC20(_asset);
        ibToken = new MockERC20(
            string.concat(name, " Interest Bearing Token"),
            string.concat(symbol, "-InterestBearingToken")
        );
        debtToken = new MockERC20(string.concat(name, " Debt Token"), string.concat(symbol, "-DebtToken"));
        price = _price;
    }

    function supply(address asset, uint256 amount, address receiver) external override returns (uint256) {
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        ibToken.mint(receiver, (amount * price) / SCALE);
        return amount;
    }

    function withdraw(address asset, uint256 amount, address receiver) external override returns (uint256) {
        ibToken.burn(msg.sender, (amount * SCALE) / price);
        IERC20(asset).transfer(receiver, amount);
        return amount;
    }

    function borrow(
        address asset,
        uint256 amount,
        address receiver,
        address owner
    ) external override returns (uint256) {
        // _requirePermission(owner, msg.sender);
        MockERC20(asset).mint(receiver, amount);
        debtToken.mint(owner, amount); // NOTE: amount doesn't change for convenience
        return amount;
    }

    function repay(address asset, uint256 amount, address onBehalfOf) external override returns (uint256) {
        IERC20(asset).transferFrom(msg.sender, address(this), amount);
        // debtToken.burn(onBehalfOf, amount);
        return amount;
    }
}
