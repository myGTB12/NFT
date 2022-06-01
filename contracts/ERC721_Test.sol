// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC721_Test is ERC721, Ownable{
    uint256 private mintPrice = 100;
    uint256 public totalSupply;         //minted token
    uint256 private maxSupply;
    mapping(address => uint256) public mintedWallets;           

    constructor() ERC721("Test NFT", "TNT"){
        maxSupply = 1000000;
    }

    function mint() external payable onlyOwner{
        //_mint
        require(mintedWallets[msg.sender] < 1000, "exceeds max per wallet");
        require(totalSupply < maxSupply, "sold out!");

        mintedWallets[msg.sender] ++;
        totalSupply ++;
        uint256 tokenID = totalSupply;
        _safeMint(msg.sender, tokenID);
    }
    
}

