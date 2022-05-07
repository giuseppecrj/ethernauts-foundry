// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/StakeContract.sol";
import "./mocks/MockERC20.sol";

contract StakeContractTest is Test {
    StakeContract public stakeContract;
    MockERC20 public mockToken;

    function setUp() public {
      stakeContract = new StakeContract();
      mockToken = new MockERC20();
    }

    function testStake(uint72 amount) public {
      mockToken.approve(address(stakeContract), amount);
      vm.roll(55);
      bool stakePassed = stakeContract.stake(amount, address(mockToken));
      assertTrue(stakePassed);
    }
}
