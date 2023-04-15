// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import {HuffDeployer} from "foundry-huff/HuffDeployer.sol";

import {BaseTestBorrowFiAggregator} from "./BaseTestBorrowFiAggregator.t.sol";

import {BorrowFiAggregator} from "../../../src/BorrowFiAggregator.sol";
import {AaveV3Market} from "../../../src/aave-v3/AaveV3Market.sol";
import {IPoolAddressesProvider} from "../../../src/interfaces/aave-v3/IPoolAddressesProvider.sol";
import {IAaveProtocolDataProvider} from "../../../src/interfaces/aave-v3/IAaveProtocolDataProvider.sol";

import {IERC20, IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

import {ILendingMarket} from "../../../src/interfaces/ILendingMarket.sol";

import {ICreditDelegationTokenLike} from "../../../src/interfaces/aave-v3/ICreditDelegationTokenLike.sol";
import {ILendingMarket} from "../../../src/interfaces/ILendingMarket.sol";

contract TestBorrowFiAggregatorForAave is BaseTestBorrowFiAggregator {
    address constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address debtToken;

    function setUp() public override {
        NETWORK = "mainnet";
        FORK_BLOCK_NUMBER = 16990000;
        asset = DAI;
        aaveV3AddressesProvider = 0x2f39d218133AFaB8F2B819B1066c7E434Ad94E9e;
        weth = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        vm.createSelectFork(NETWORK, FORK_BLOCK_NUMBER);

        super.setUp();

        // label
        address dataProvider = IPoolAddressesProvider(aaveV3AddressesProvider).getPoolDataProvider();
        (address aToken, , address _debtToken) = IAaveProtocolDataProvider(dataProvider).getReserveTokensAddresses(
            asset
        );
        debtToken = _debtToken;

        vm.label(aaveV3AddressesProvider, "provider");
        vm.label(IPoolAddressesProvider(aaveV3AddressesProvider).getPool(), "pool");
        vm.label(aToken, "aToken");
        vm.label(_debtToken, "debtToken");
        vm.label(dataProvider, "poolDataProvider");
    }

    function _deploy() internal virtual override {
        // NOTE: deployer is owner
        vm.prank(owner);
        aggregator = new BorrowFiAggregator();
        market = address(new AaveV3Market(IPoolAddressesProvider(aaveV3AddressesProvider)));

        vm.prank(owner);
        aggregator.setWrapper(address(market), true);
    }

    function testSetUp_Ok() public override {
        assertEq(aggregator.owner(), owner, "owner is not set correctly");
        assertEq(
            aggregator.isWhitelistedWrapper(market),
            true,
            "wrapperType is not set correctly"
        );
    }

    function testAggregateBorrow_Ok() public override {
        // setUp
        // create param
        uint256 borrowAmount = 1000 * (10 ** decimals);
        BorrowFiAggregator.Calldata[] memory data = new BorrowFiAggregator.Calldata[](1);
        data[0] = BorrowFiAggregator.Calldata({wrapper: market, amount: borrowAmount});
        // get balance before
        uint balBefore = IERC20(asset).balanceOf(address(this));
        // NOTE: allow aggregator to borrow
        ILendingMarket(market).allow(address(aggregator), true);
        // NOTE: collateral owner MUST approve credit delegatin to `market`.
        ICreditDelegationTokenLike(debtToken).approveDelegation(market, borrowAmount);

        // execution
        aggregator.aggregateBorrow(asset, data);

        // assert
        assertEq(IERC20(asset).balanceOf(address(this)), balBefore + borrowAmount, "borrow amount");
    }
}

contract TestBorrowFiAggregatorForAaveHuff is TestBorrowFiAggregatorForAave {
    function _deploy() internal override {
        // NOTE: deployer is owner
        vm.prank(owner);
        aggregator = new BorrowFiAggregator();
        market = HuffDeployer
            .config()
            .with_addr_constant("POOL", IPoolAddressesProvider(aaveV3AddressesProvider).getPool())
            .deploy("aave-v3/AaveV3Market");

        vm.prank(owner);
        aggregator.setWrapper(address(market), true);
    }
}
