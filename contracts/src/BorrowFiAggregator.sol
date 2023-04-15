// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {ILendingMarket} from "./interfaces/ILendingMarket.sol";

import {IAaveProtocolDataProvider} from "./interfaces/aave-v3/IAaveProtocolDataProvider.sol";
import {IPoolAddressesProvider} from "./interfaces/aave-v3/IPoolAddressesProvider.sol";
import {ICreditDelegationTokenLike} from "./interfaces/aave-v3/ICreditDelegationTokenLike.sol";

contract BorrowFiAggregator is Ownable {
    enum WrapperType {
        UnRegistered,
        AaveV2,
        AaveV3,
        Mock
    }
    struct Calldata {
        address wrapper;
        uint256 amount;
    }

    /// @dev Aave V3 Addresses register of the protocol
    IPoolAddressesProvider internal immutable _provider;

    mapping(address => WrapperType) internal _wrapperTypes;

    event SetWrapper(address indexed wrapper, WrapperType indexed wType);

    constructor(address _poolAddressesProvider) {
        _provider = IPoolAddressesProvider(_poolAddressesProvider);
    }

    /// @notice users have to `ILendingMarket(wrapper).allow(asset, aggre)` for each wrappers
    /// before calling this function
    function aggregateBorrow(address asset, Calldata[] calldata data) external {
        uint256 length = data.length;
        for (uint256 i; i < length; ) {
            address wrapper = data[i].wrapper;
            uint amountBorrow = data[i].amount;

            require(_wrapperTypes[wrapper] != WrapperType.UnRegistered, "aggregator: Wrapper is not whitelisted");

            ILendingMarket(wrapper).borrow(asset, amountBorrow, msg.sender, msg.sender);

            unchecked {
                ++i;
            }
        }
    }

    function getWrapperType(address wrapper) external view returns (WrapperType) {
        return _wrapperTypes[wrapper];
    }

    function setWrapper(address wrapper, WrapperType wType) external onlyOwner {
        _wrapperTypes[wrapper] = wType;

        emit SetWrapper(wrapper, wType);
    }
}
