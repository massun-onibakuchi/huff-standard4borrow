// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity 0.8.17;

import "./interfaces/ILendingMarket.sol";

import {BitMaps} from "@openzeppelin/contracts/utils/structs/BitMaps.sol";
import {AddressCast} from "./utils/AddressCast.sol";

abstract contract LendingMarketBase is ILendingMarket {
    using BitMaps for BitMaps.BitMap;
    using AddressCast for address;

    mapping(address => BitMaps.BitMap) private _allowedAccounts;

    function allow(address account, bool allowed) external {
        _allowedAccounts[msg.sender].setTo(account.toUint256(), allowed);
    }

    function isAllowed(address owner, address account) public view returns (bool) {
        return _allowedAccounts[owner].get(account.toUint256());
    }

    function _requirePermission(address owner, address caller) internal view {
        require(owner == caller || isAllowed(owner, caller), "LendingMarketBase: not allowed");
    }
}
