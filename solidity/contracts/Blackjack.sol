// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Blackjack {
    address public dealer;
    mapping(address => bool) players;
    mapping(address => uint256) playerBalances;

    constructor() {
        dealer = msg.sender;
    }

    function enterTournament() public {
        require(players[msg.sender] = false, "Error: Player has already entered");
        players[msg.sender] = true;
        fundPlayer(msg.sender);
    }

    // Provide the player with tokens once he enters tournament
    function fundPlayer(address _address) internal {}
}
