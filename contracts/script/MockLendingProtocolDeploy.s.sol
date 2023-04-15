// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {MockLendingMarket, MockERC20} from "../test/foundry/mocks/MockLendingMarket.sol";

contract MockLendingProtocolDeploy is Script {
    MockLendingMarket public market;
    MockERC20 public asset;

    /// @notice
    /// Watch out for frontrunning.
    /// Forge simulates your script, generates transaction data from the simulation results, then broadcasts the transactions.
    /// Make sure your script is robust against chain-state changing between the simulation and broadcast
    function run() public {
        vm.startBroadcast();
        uint256 price = 1.2 * 1e18;

        asset = new MockERC20();

        asset.mint(address(this), 100000 * 1e18);
        asset.mint(msg.sender, 100000 * 1e18);

        market = new MockLendingMarket(price);

        console2.log("asset :>>", address(asset));
        console2.log("market :>>", address(market));
        console2.log("ibToken :>>", address(market.ibToken()));
        console2.log("debtToken :>>", address(market.debtToken()));
        vm.stopBroadcast();
    }
}
