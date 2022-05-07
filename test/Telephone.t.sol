pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/levels/Telephone/TelephoneFactory.sol";
import "../src/core/Ethernaut.sol";

import "../src/levels/Telephone/TelephoneHack.sol";

contract TelephoneTest is Test {
    Ethernaut ethernaut;
    address attacker = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(attacker, 5 ether);
    }

    function testTelephoneHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        TelephoneFactory factory = new TelephoneFactory();
        ethernaut.registerLevel(factory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(factory);
        Telephone target = Telephone(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // (...)
        TelephoneHack attackContract = new TelephoneHack(levelAddress);
        emit log_named_address("tx.origin", tx.origin);
        emit log_named_address("msg.sender", attacker);

        attackContract.attack();

        assertEq(target.owner(), attacker);


        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////


        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
