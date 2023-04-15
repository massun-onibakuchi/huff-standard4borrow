// SPDX-License-Identifier: BSD-3-Clause
pragma solidity 0.8.17;

// interfaces
import {CometMainInterface} from "../interfaces/compound-v3/CometMainInterface.sol";
import {CometExtInterface} from "../interfaces/compound-v3/CometExtInterface.sol";

// libraries
import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {Address} from "@openzeppelin/contracts/utils/Address.sol";

import {LendingMarketBase} from "../LendingMarketBase.sol";

contract CometMarket is LendingMarketBase {
  using SafeERC20 for IERC20;

  CometMainInterface internal immutable _comet;

  constructor(CometMainInterface _cometMainInterface) {
    _comet = _cometMainInterface;
  }

  function supply (address asset, uint256 amount, address receiver) external returns (uint256){
    require(asset!=_comet.baseToken(),"asset-shoudldn't-be-baseToken");
    _comet.supplyFrom(msg.sender, receiver, asset, amount);
    return amount;
  }
  
  ///Users are supposed to `allow`ed this market contract so that this can withdraw assets on behalf of users.
  function withdraw (address asset, uint256 amount, address receiver) external returns (uint256) {
    require(asset!=_comet.baseToken(),"asset-shouldn't-be-baseToken");
    _comet.withdrawFrom(msg.sender, receiver, asset, amount);
    return amount;
  }

  function borrow(address asset, uint256 amount, address receiver, address) external returns(uint256) {
    require(asset==_comet.baseToken(),"asset-should-be-baseToken");
    _comet.withdrawFrom(msg.sender, receiver, asset, amount);
    return amount;
  }


  function repay(address asset, uint256 amount, address onBehalfOf) external returns (uint256) {
    require(asset==_comet.baseToken(),"asset-should-be-baseToken");
    _comet.supplyFrom(onBehalfOf, msg.sender, asset, amount);
    return amount;
  }
}
