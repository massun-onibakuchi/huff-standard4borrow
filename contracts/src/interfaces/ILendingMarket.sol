// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.10;

interface ILendingMarket {
    /**
     * @notice Supplies an `amount` of underlying asset into the reserve, receiving in return overlying interest-bearing tokens.
     * - E.g. User supplies 100 USDC and gets in return 100 / price interest-bearing USDC
     * @param asset The address of the underlying asset to supply
     * @param amount The amount to be supplied
     * @param receiver The address that will receive the interest-bearing tokens, same as msg.sender if the user
     *   wants to receive them on his own wallet, or a different address if the beneficiary of interest-bearing tokens
     *   is a different wallet
     */
    function supply(address asset, uint256 amount, address receiver) external returns (uint256);

    /**
     * @notice Withdraws an `amount` of underlying asset from the reserve, burning the equivalent interest-bearing tokens owned
     * E.g. User has 100 interest-bearing USDC, calls withdraw() and receives 100 * price USDC, burning the 100 interest-bearing USDC
     * @param asset The address of the underlying asset to withdraw
     * @param amount The underlying amount to be withdrawn
     *   - Send the value type(uint256).max in order to withdraw the whole interest-bearing token balance
     * @param to The address that will receive the underlying, same as msg.sender if the user
     *   wants to receive it on his own wallet, or a different address if the beneficiary is a
     *   different wallet
     * @return The final amount withdrawn
     */
    function withdraw(address asset, uint256 amount, address to) external returns (uint256);

    /**
     * @notice Allows users to borrow a specific `amount` of the reserve underlying asset, provided that the borrower
     * already supplied enough collateral, or he was given enough allowance by a credit delegator on the
     * corresponding debt token
     * - E.g. User borrows 100 USDC passing as `receiver` his own address, receiving the 100 USDC in his wallet
     *   and 100 debt tokens
     * @param asset The address of the underlying asset to borrow
     * @param amount The amount to be borrowed
     * @param receiver The address of the user who will receive the debt. Should be the address of the borrower itself
     * calling the function if he wants to borrow against his own collateral, or the address of the credit delegator
     * if he has been given credit delegation allowance
     */
    function borrow(address asset, uint256 amount, address receiver, address owner) external returns (uint256);

    /**
     * @notice Repays a borrowed `amount` on a specific reserve, burning the equivalent debt tokens owned
     * @param asset The address of the borrowed underlying asset previously borrowed
     * @param amount The amount to repay
     * - Send the value type(uint256).max in order to repay the whole debt for `asset` on the specific `debtMode`
     * @param onBehalfOf The address of the user who will get his debt reduced/removed. Should be the address of the
     * user calling the function if he wants to reduce/remove his own debt, or the address of any other
     * other borrower whose debt should be removed
     * @return The final amount repaid
     */
    function repay(address asset, uint256 amount, address onBehalfOf) external returns (uint256);

    function allow(address delegatee, bool allowed) external;

    function isAllowed(address owner, address account) external view returns (bool);
}
