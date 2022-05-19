// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BLJCoin.sol";
import "hardhat/console.sol";

contract Blackjack is BLJCoin{
    // The "dealer" is the address who provides funds (BLJCoin) and keeps
    // players losses
    address public dealer;
    mapping(address => bool) public players;
    mapping(address => uint256) public playerBalances;
    mapping(address => bool) public isHandActive;
    mapping(address => uint[]) public playersHand;
    mapping(address => uint[]) public dealersHand;

    uint public lastAwardGiven;

    // Mint 10 million BlackjackCoins
    constructor() BLJCoin(10000000) {
        dealer = msg.sender;
    }

    event StartHand(address player, uint betAmount, uint[] playersHand, uint[] dealersHand);

    modifier onlyExistingPlayers {
        require(players[msg.sender] == true, "Error: Player has not entered the tournament");
        _;
    }

    modifier onlyNewPlayers {
        require(players[msg.sender] == false, "Error: Player has already entered");
        _;
    }

    modifier onlyDuringHand {
        require(isHandActive[msg.sender] == true, "Error: Hand is not active/being played");
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

    // Generate 2 random numbers each between 1-11
    function generatePlayersHand() private view returns(uint[] memory){
        uint[] memory arr = new uint[](2);
        for(uint i = 0; i < 2; i++){
            uint seed = uint256(keccak256(abi.encodePacked(
                i + block.timestamp + block.difficulty +
                ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
                block.gaslimit + 
                ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
                block.number
            )));
            arr[i] = ((seed - ((seed / 11) * 11)) + 1);
        }
        return arr;
    }

    // Generate 2 random numbers each between 1-11
    function generateDealersHand() private view returns(uint[] memory) {
        uint[] memory arr = new uint[](2);
        for(uint i = 0; i < 2; i++){
            // We add generatePlayersHand()[i] to add even more "randomness"
            uint seed = uint256(keccak256(abi.encodePacked(
                generatePlayersHand()[i] + i + block.timestamp + block.difficulty +
                ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
                block.gaslimit + 
                ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
                block.number
            )));
            arr[i] = ((seed - ((seed / 11) * 11)) + 1);
        }
        return arr;
    }

    // Generate 1 random numbers between 1-11
    function generateRandomCard() onlyDuringHand private view returns(uint) {
            // We add generatePlayersHand()[i] to add even more "randomness"
            uint seed = uint256(keccak256(abi.encodePacked(
                block.timestamp + block.difficulty +
                ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (block.timestamp)) +
                block.gaslimit + 
                ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (block.timestamp)) +
                block.number
            )));
            
        return ((seed - ((seed / 11) * 11)) + 1);
    }

    function hitHand() onlyDuringHand public {
        uint newCard = generateRandomCard();
        playersHand[msg.sender].push(newCard);
    }

    function stayHand() onlyDuringHand public {

    }

    function startHand(uint _betAmount) onlyExistingPlayers public {
        require(playerBalances[msg.sender] >= _betAmount, "Error: Not enough funds to place bet");
        require(isHandActive[msg.sender] == false, "Error: You have already started a hand");
        isHandActive[msg.sender] = true;

        // Store hands in memory to save gas
        playersHand[msg.sender] = generatePlayersHand();
        dealersHand[msg.sender] = generateDealersHand();
        emit StartHand(msg.sender, _betAmount, playersHand[msg.sender], dealersHand[msg.sender]);

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

        // isHandActive[msg.sender] = false;
    }

    function claimAwards() public {
        require(block.timestamp - lastAwardGiven > 1 weeks, "Error: Awards are only given out once per week");
        lastAwardGiven = block.timestamp;

        // Give winners awards
    }
}