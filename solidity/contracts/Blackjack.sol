// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BLJCoin.sol";
contract Blackjack is BLJCoin{
    // The "dealer" is the address who provides funds (BLJCoin) and keeps
    // players losses
    address public dealer;
    mapping(address => bool) public players;
    mapping(address => uint256) public playerBalances;
    uint public lastAwardGiven;

    // Mint 10 million BlackjackCoins
    constructor() BLJCoin(10000000) {
        dealer = msg.sender;
    }

    function enterTournament() public {
        require(msg.sender != dealer, "Error: Dealer can't enter tournament");
        require(players[msg.sender] == false, "Error: Player has already entered");
        require(playerBalances[msg.sender] == 0, "Error: Player already has coins");
        players[msg.sender] = true;

        // Provide player with tokens once they enter the tournament
        uint amount = 10000;
        BLJCoin.fundPlayer(msg.sender, amount);
        playerBalances[msg.sender] += amount;
    }

    function giveAwards() public {
        require(block.timestamp - lastAwardGiven > 1 weeks, "Error: Awards are only given out once per week");
        lastAwardGiven = block.timestamp;

        // Give winners awards
    }
}
