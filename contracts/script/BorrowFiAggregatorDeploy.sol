// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {BorrowFiAggregator} from "../src/BorrowFiAggregator.sol";
import {AaveV3MarketDeploy} from "./AaveV3MarketDeploy.sol";
import {MockLendingProtocolDeploy} from "./MockLendingProtocolDeploy.sol";

contract BorrowFiAggregatorDeploy is Script {
    BorrowFiAggregator public aggregator;

    AaveV3MarketDeploy public aaveDeployer;
    MockLendingProtocolDeploy public mockDeployer;

    /// @notice
    /// Watch out for frontrunning.
    /// Forge simulates your script, generates transaction data from the simulation results, then broadcasts the transactions.
    /// Make sure your script is robust against chain-state changing between the simulation and broadcast
    function run() public {
        vm.startBroadcast();

        aggregator = new BorrowFiAggregator();

        aaveDeployer = new AaveV3MarketDeploy();
        vm.allowCheatcodes(address(aaveDeployer));
        aaveDeployer.run();
        mockDeployer = new MockLendingProtocolDeploy();
        vm.allowCheatcodes(address(mockDeployer));
        mockDeployer.run();

        aggregator.setWrapper(address(aaveDeployer.market()), true);
        aggregator.setWrapper(address(mockDeployer.market()), true);

        console2.log("BorrowFiAggregator:>> ", address(aggregator));
        console2.log("AaveV3Market:>> ", address(aaveDeployer.market()));
        console2.log("MockLendingProtocol:>> ", address(mockDeployer.market()));
        vm.stopBroadcast();
    }
}
