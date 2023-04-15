// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";

import {AddressCast} from "./utils/AddressCast.sol";

import {ILendingMarket} from "./interfaces/ILendingMarket.sol";

import {IAaveProtocolDataProvider} from "./interfaces/aave-v3/IAaveProtocolDataProvider.sol";
import {IPoolAddressesProvider} from "./interfaces/aave-v3/IPoolAddressesProvider.sol";
import {ICreditDelegationTokenLike} from "./interfaces/aave-v3/ICreditDelegationTokenLike.sol";

contract BorrowFiAggregator is Ownable {
    using BitMaps for BitMaps.BitMap;
    using AddressCast for address;

    struct Calldata {
        address wrapper;
        uint256 amount;
    }

    event SetWrapper(address indexed wrapper, bool indexed value);

    mapping(address => BitMaps.BitMap) private _whitelistedWrappers;

    /// @notice users have to `ILendingMarket(wrapper).allow(asset, aggre)` for each wrappers
    /// before calling this function
    function aggregateBorrow(address asset, Calldata[] calldata data) external {
        uint256 length = data.length;
        for (uint256 i; i < length; ) {
            address wrapper = data[i].wrapper;

            require(isWhitelistedWrapper(wrapper), "aggregator: Wrapper is not whitelisted");
            ILendingMarket(wrapper).borrow(asset, data[i].amount, msg.sender, msg.sender);

            unchecked {
                ++i;
            }
        }
    }

    function isWhitelistedWrapper(address wrapper) public view returns (bool) {
        return _whitelistedWrappers[wrapper].get(wrapper.toUint256());
    }

    function setWrapper(address wrapper, bool value) external onlyOwner {
        _whitelistedWrappers[wrapper].setTo(wrapper.toUint256(), value);
        emit SetWrapper(wrapper, value);
    }
}
