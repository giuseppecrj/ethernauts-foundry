pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/levels/Force/ForceFactory.sol";
import "../src/core/Ethernaut.sol";
import "../src/levels/Force/ForceHack.sol";

contract ForceTest is Test {
    Ethernaut ethernaut;
    address attacker = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(attacker, 5 ether);
    }

    function testForceHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        ForceFactory factory = new ForceFactory();
        ethernaut.registerLevel(factory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(factory);
        Force targetContract = Force(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        (new ForceHack){value: 0.1 ether}(payable(levelAddress));

        assertEq(address(targetContract).balance, 0.1 ether);


        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////


        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
