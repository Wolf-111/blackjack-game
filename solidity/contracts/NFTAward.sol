// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTAward is ERC721 {
    uint public maxSupply;
    constructor() ERC721("Blackjack Prize", "BJP") {}
}