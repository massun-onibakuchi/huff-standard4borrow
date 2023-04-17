// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {BorrowFiAggregator} from "../src/BorrowFiAggregator.sol";
import {AaveV3MarketDeploy} from "./AaveV3MarketDeploy.sol";
import {MockLendingProtocolDeploy} from "./MockLendingProtocolDeploy.sol";

import {IERC20, IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import {ILendingMarket} from "../src/interfaces/ILendingMarket.sol";

import {IPoolAddressesProvider} from "../src/interfaces/aave-v3/IPoolAddressesProvider.sol";
import {IAaveProtocolDataProvider} from "../src/interfaces/aave-v3/IAaveProtocolDataProvider.sol";
import {ICreditDelegationTokenLike} from "../src/interfaces/aave-v3/ICreditDelegationTokenLike.sol";

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
        address user = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        vm.allowCheatcodes(user);

        // vm.deal(user, 1000 ether);
        address asset = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // DAI

        aggregator = new BorrowFiAggregator();

        vm.allowCheatcodes(address(aaveDeployer));
        vm.allowCheatcodes(address(mockDeployer));
        
        aaveDeployer = new AaveV3MarketDeploy();
        mockDeployer = new MockLendingProtocolDeploy();
        aaveDeployer.deploy();
        mockDeployer.deploy();

        aggregator.setWrapper(address(aaveDeployer.market()), true);
        aggregator.setWrapper(address(mockDeployer.market()), true);

        address weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        address aaveV3AddressesProvider = 0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e;

        uint256 initialWethCollateral = 10 ether;
        // fund weth to this contract
        // deal(weth, address(this), initialWethCollateral, false);
        (bool success, ) = weth.call{value: 10 * initialWethCollateral}("");
        require(success, "failed to fund weth");
        // approve weth
        IERC20(weth).approve(address(aaveDeployer.market()), type(uint256).max);
        // deposit weth as collateral
        aaveDeployer.market().supply(weth, initialWethCollateral, address(this));
        // NOTE: allow aggregator to borrow
        aaveDeployer.market().allow(address(aggregator), true);
        // NOTE: collateral owner MUST approve credit delegatin to `market`.
        address dataProvider = IPoolAddressesProvider(aaveV3AddressesProvider).getPoolDataProvider();
        (address aToken, , address debtToken) = IAaveProtocolDataProvider(dataProvider).getReserveTokensAddresses(
            asset
        );
        ICreditDelegationTokenLike(debtToken).approveDelegation(address(aaveDeployer.market()), type(uint128).max);

        console2.log("BorrowFiAggregator:>> ", address(aggregator));
        console2.log("AaveV3Market:>> ", address(aaveDeployer.market()));
        console2.log("MockLendingProtocol:>> ", address(mockDeployer.market()));
        vm.stopBroadcast();
    }
}
