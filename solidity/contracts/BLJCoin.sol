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

    function fundPlayer(address _player, uint _amount) public {
        require(_amount == 10000, "Error: Amount must be 10000");
        // require(msg.sender != creator, "Error: Contract creator can't fund themselves");
        // require(Blackjack.players(_player) == false, "Error: Player has already entered");
        // require(Blackjack.playerBalances(_player) == 0, "Error: Player already has coins");
        //console.log(allowance(creator, creator));
        _approve(creator, _player, _amount);
        transferFrom(creator, _player, _amount);
    }
}