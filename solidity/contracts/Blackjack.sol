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

    event BeginHand(address player, uint betAmount);

    modifier onlyExistingPlayers {
        require(players[msg.sender] == true, "Error: Player has not entered the tournament");
        _;
    }

    modifier onlyNewPlayers {
        require(players[msg.sender] == false, "Error: Player has already entered");
        _;
    }

    function enterTournament() onlyNewPlayers public {
        require(msg.sender != dealer, "Error: Dealer can't enter tournament");
        require(playerBalances[msg.sender] == 0, "Error: Player already has coins");
        players[msg.sender] = true;

        // Provide player with tokens once they enter the tournament
        uint amount = 10000;
        BLJCoin.fundPlayer(msg.sender, amount);
        playerBalances[msg.sender] += amount;
    }

    function playHand(uint _betAmount) onlyExistingPlayers public {
        require(playerBalances[msg.sender] >= _betAmount, "Error: Not enough funds to place bet");
        
        emit BeginHand(msg.sender, _betAmount);

        /*
        1. Player places bet
        2. Player & dealer are randomly dealt 2 cards each (player can only see 1 of the dealers cards)
        3. Player given option to double down or not
        4. Player can hit or stay
        5. If stay, reveal dealers hidden card & keep hitting until values are greater than or equal to
           the player's cards. If exceeds 21, player wins.
        6. If hit, randomly add card to players hand. If exceeds 21, dealer wins.
        7. Whichever person has the bigger hand wins, if exceeds 21, other player wins.
        */
    }

    function giveAwards() public {
        require(block.timestamp - lastAwardGiven > 1 weeks, "Error: Awards are only given out once per week");
        lastAwardGiven = block.timestamp;

        // Give winners awards
    }
}