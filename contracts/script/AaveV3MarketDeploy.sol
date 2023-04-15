// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {IPoolAddressesProvider} from "../src/interfaces/aave-v3/IPoolAddressesProvider.sol";
import {AaveV3Market} from "../src/aave-v3/AaveV3Market.sol";

contract AaveV3MarketDeploy is Script {
    IPoolAddressesProvider public provider;

    AaveV3Market public market;

    /// @notice
    /// Watch out for frontrunning.
    /// Forge simulates your script, generates transaction data from the simulation results, then broadcasts the transactions.
    /// Make sure your script is robust against chain-state changing between the simulation and broadcast
    function run() public {
        vm.startBroadcast();
        provider = IPoolAddressesProvider(0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e); // Ethereum mainnet

        market = new AaveV3Market(provider);

        console2.log("AaveV3Market:>> ", address(market));
        vm.stopBroadcast();
    }
}
