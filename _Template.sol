pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/levels/ChangeMe/ChangeMeFactory.sol";
import "../src/core/Ethernaut.sol";

contract ChangeMeTest is Test {
    Ethernaut ethernaut;
    address attacker = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(attacker, 5 ether);
    }

    function testChangeMeHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        ChangeMeFactory factory = new ChangeMeFactory();
        ethernaut.registerLevel(factory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(factory);
        ChangeMe target = ChangeMe(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // (...)


        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////


        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
