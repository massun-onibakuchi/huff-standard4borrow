// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "forge-std/Test.sol";

import "../../../src/interfaces/aave-v3/IPoolAddressesProvider.sol";
import {AaveV3Market} from "../../../src/aave-v3/AaveV3Market.sol";

import {BaseTestAaveV3Market} from "./BaseTestAaveV3Market.t.sol";

contract TestAaveV3MarketSol is BaseTestAaveV3Market {
    function setUp() public override {
        NETWORK = "mainnet";
        FORK_BLOCK_NUMBER = 16990000;
        PROVIDER = IPoolAddressesProvider(0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e);
        asset = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // DAI
        vm.createSelectFork(NETWORK, FORK_BLOCK_NUMBER);

        super.setUp();
    }

    function _deploy() internal override returns (address _market) {
        _market = address(new AaveV3Market(PROVIDER));
    }
}
