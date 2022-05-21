// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";

contract BLJCoin is ERC20 {
    address public creator;
    constructor(uint256 _totalSupply) ERC20("Blackjack Coin", "BLJ") {
        creator = msg.sender;
        _mint(msg.sender, _totalSupply);
        increaseAllowance(msg.sender, _totalSupply);
    }

    function fundPlayer(uint _amount) internal {
        require(_amount == 10000, "Error: Amount must be 10000");
        _approve(creator, msg.sender, _amount);
        transferFrom(creator, msg.sender, _amount);
    }

    function sendFundsToPlayer(uint _amount) internal {
        _approve(creator, msg.sender, _amount);
        transferFrom(creator, msg.sender, _amount);
    }
}