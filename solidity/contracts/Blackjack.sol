// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BLJCoin.sol";
// import "hardhat/console.sol";

contract Blackjack is BLJCoin{
    // The "dealer" is the address who provides funds (BLJCoin) and keeps
    // players losses
    address public dealer;
    mapping(address => bool) public players;
    mapping(address => uint256) public playerBalances;
    mapping(address => bool) public isHandActive;
    mapping(address => uint[]) public playersHand;
    mapping(address => uint[]) public dealersHand;
    mapping(address => bool) public hasPlayerStayed;
    mapping(address => bool) public hasPlayerBusted;
    mapping(address => uint) public betAmount;
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

    modifier onlyBeforeStay {
        require(hasPlayerStayed[msg.sender] == false, "Error: Player has already chosen to stay");
        _;
    }

    function enterTournament() onlyNewPlayers public {
        require(msg.sender != dealer, "Error: Dealer can't enter tournament");
        require(playerBalances[msg.sender] == 0, "Error: Player already has coins");
        players[msg.sender] = true;

        // Provide player with tokens once they enter the tournament
        uint amount = 10000;
        BLJCoin.fundPlayer(amount);
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

    function revealDealersHand() onlyDuringHand private returns (uint[] memory) {
        uint dealerTotal = dealersHand[msg.sender][0] + dealersHand[msg.sender][1];
        uint playerTotal = 0;
        for (uint i = 0; i < playersHand[msg.sender].length; i++) {
            playerTotal += playersHand[msg.sender][i];
        }

        while(dealerTotal < playerTotal){
            hitDealersHand();
            for (uint i = 0; i < dealersHand[msg.sender].length; i++) {
                dealerTotal += dealersHand[msg.sender][i];
            }

            if(dealerTotal <= 21 && dealerTotal > playerTotal) {
                // Player loses
                playerBalances[msg.sender] -= betAmount[msg.sender];
                isHandActive[msg.sender] = false;
                break;
            }
            if(dealerTotal > 21 && playerTotal <= 21){
                // Player wins (send them their original bet back + double)
                BLJCoin.sendFundsToPlayer((betAmount[msg.sender] * 2));
                playerBalances[msg.sender] += betAmount[msg.sender];
                isHandActive[msg.sender] = false;
                break;
            }
            if(dealerTotal == playerTotal){
                // Push
                BLJCoin.sendFundsToPlayer(betAmount[msg.sender]);
                isHandActive[msg.sender] = false;
                break;
            }
        }
        return dealersHand[msg.sender];
    }

    function hitDealersHand() onlyDuringHand private {
        uint newCard = generateRandomCard();
        dealersHand[msg.sender].push(newCard);
    }

    function hitHand() onlyDuringHand onlyBeforeStay public {
        uint newCard = generateRandomCard();
        playersHand[msg.sender].push(newCard);

        uint playerTotal = 0;
        for (uint i = 0; i < playersHand[msg.sender].length; i++) {
            playerTotal += playersHand[msg.sender][i];
        }

        if(playerTotal > 21){
            // Player loses
            hasPlayerBusted[msg.sender] = true;
            playerBalances[msg.sender] -= betAmount[msg.sender];
            isHandActive[msg.sender] = false;
        }
    }

    function stayHand() onlyBeforeStay onlyDuringHand public {
        require(hasPlayerBusted[msg.sender] == false, "Error: Player has busted");  
        hasPlayerStayed[msg.sender] = true;
        revealDealersHand();
    }

    function startHand() onlyExistingPlayers public payable {
        require(playerBalances[msg.sender] >= msg.value, "Error: Not enough funds to place bet");
        require(isHandActive[msg.sender] == false, "Error: You have already started a hand");
        betAmount[msg.sender] = msg.value;
        isHandActive[msg.sender] = true;
        hasPlayerStayed[msg.sender] = false;

        playersHand[msg.sender] = generatePlayersHand();
        dealersHand[msg.sender] = generateDealersHand();

        emit StartHand(msg.sender, betAmount[msg.sender], playersHand[msg.sender], dealersHand[msg.sender]);
    }

    function claimAwards() public {
        require(block.timestamp - lastAwardGiven > 1 weeks, "Error: Awards are only given out once per week");
        lastAwardGiven = block.timestamp;

        // Give winners awards
    }
}