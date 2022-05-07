pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/levels/CoinFlip/CoinFlipFactory.sol";
import "../src/core/Ethernaut.sol";

import "../src/levels/CoinFlip/CoinFlipHack.sol";

contract CoinFlipTest is Test {
    Ethernaut ethernaut;
    address attacker = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(attacker, 5 ether);
    }

    function testCoinFlipHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        CoinFlipFactory factory = new CoinFlipFactory();
        ethernaut.registerLevel(factory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(factory);
        CoinFlip target = CoinFlip(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // (...)
        vm.roll(5);

        CoinFlipHack attackContract = new CoinFlipHack(levelAddress);

        for (uint i = 0; i <= 10; i++) {
          vm.roll(6 + i); // cheatcode to simulate running the attack on each subsequent ethereum block
          attackContract.attack();
        }

        assertEq(target.consecutiveWins(), 11);



        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////


        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
