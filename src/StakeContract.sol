// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakeContract {
  error TransferFailed();

  mapping(address => mapping(address => uint)) public s_balances;

  function stake(uint256 amount, address token) external returns(bool) {
    s_balances[msg.sender][token] += amount;

    bool success = IERC20(token).transferFrom(msg.sender, address(this), amount);
    if (!success) revert TransferFailed();

    return success;
  }
}
