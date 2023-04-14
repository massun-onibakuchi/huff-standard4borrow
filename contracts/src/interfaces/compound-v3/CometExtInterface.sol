// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.10;

/**
 * @title Compound's Comet Ext Interface
 * @notice An efficient monolithic money market protocol
 * @author Compound
 */
interface CometExtInterface {
    error BadAmount();
    error BadNonce();
    error BadSignatory();
    error InvalidValueS();
    error InvalidValueV();
    error SignatureExpired();

    function allow(address manager, bool isAllowed) external;

    function allowBySig(
        address owner,
        address manager,
        bool isAllowed,
        uint256 nonce,
        uint256 expiry,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function collateralBalanceOf(address account, address asset) external view returns (uint128);

    function baseTrackingAccrued(address account) external view returns (uint64);
}
