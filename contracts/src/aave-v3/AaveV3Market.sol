// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

// interfaces
import {IAaveProtocolDataProvider} from "../interfaces/aave-v3/IAaveProtocolDataProvider.sol";
import {IPool} from "../interfaces/aave-v3/IPool.sol";
import {IPoolAddressesProvider} from "../interfaces/aave-v3/IPoolAddressesProvider.sol";

// libraries
import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

import {LendingMarketBase} from "../LendingMarketBase.sol";

contract AaveV3Market is LendingMarketBase {
    using SafeERC20 for IERC20;

    uint16 internal constant REFERRAL_CODE = 0;

    /// @dev Aave V3 Addresses register of the protocol
    IPoolAddressesProvider internal immutable _provider;

    constructor(IPoolAddressesProvider _poolAddressesProvider) {
        _provider = _poolAddressesProvider;
    }

    /// @notice the contract must have allowance to spend funds on behalf of msg.sender for the asset being supplied
    ///  before calling this function
    function supply(address asset, uint256 amount, address receiver) external returns (uint256) {
        // according to the Aave docs,
        // whenever the `Pool` contract is needed, fetchingthe correct address from the `PoolAddressesProvider` is recommended
        address pool = _provider.getPool();

        IERC20(asset).safeTransferFrom(msg.sender, address(this), amount);
        IERC20(asset).safeApprove(pool, amount);

        IPool(pool).deposit(asset, amount, receiver, REFERRAL_CODE);
        // tbh we shouldn't trust external contracts.
        return amount;
    }

    /// @notice `owner` must have approved the contract to spend funds for aToken before calling this function
    ///         if `owner` is not msg.sender, msg.sender must have delegated credit to this contract via `allow`
    function withdraw(address asset, uint256 amount, address receiver) external returns (uint256) {
        address pool = _provider.getPool();
        (address aToken, , ) = IAaveProtocolDataProvider(_provider.getPoolDataProvider()).getReserveTokensAddresses(
            asset
        );

        IERC20(aToken).safeTransferFrom(msg.sender, address(this), amount);
        IERC20(aToken).safeApprove(pool, amount);

        IPool(pool).withdraw(asset, amount, receiver);
        return amount;
    }

    /// @notice owner must have delegated credit to this contract via debtToken.approveDelegation() before calling this function
    ///         if `owner` is not msg.sender, msg.sender must have delegated credit to this contract via `allow`
    function borrow(address asset, uint256 amount, address receiver, address owner) external returns (uint256) {
        _requirePermission(owner, msg.sender);

        address pool = _provider.getPool();
        IPool(pool).borrow(asset, amount, 2, REFERRAL_CODE, owner);

        IERC20(asset).safeTransfer(receiver, amount);
        return amount;
    }

    /// @notice msg.sender must have approved the contract to spend funds for asset before calling this function
    function repay(address asset, uint256 amount, address onBehalfOf) external returns (uint256) {
        address pool = _provider.getPool();

        IERC20(asset).safeTransferFrom(msg.sender, address(this), amount);
        IERC20(asset).safeApprove(pool, amount);

        IPool(pool).repay(asset, amount, 2, onBehalfOf);
        return amount;
    }
}
