// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC1155_Test is ERC1155, Ownable{
    uint256[] public supplies;
    uint256[] public minted;

    constructor() ERC1155("https://token-cdn-domain/{id}.json"){
        supplies.push(25);
        supplies.push(22);
        supplies.push(15);
        supplies.push(55);
        supplies.push(36);

        minted.push(1);
        minted.push(6);
        minted.push(5);
        minted.push(8);
        minted.push(4);
        
    }
    function setURI(string memory newuri) public onlyOwner{
        _setURI(newuri);
    }
    function mint(uint256 id, uint256 amount) public {
        require(id <= supplies.length, "token not exist");
        require(id != 0, "token not exist");
        uint256 index = id - 1;
        require(minted[index] + amount <= supplies[index], "Out of supplies!");
        _mint(msg.sender, id, amount, "");
        minted[index] += amount;
    }
}
