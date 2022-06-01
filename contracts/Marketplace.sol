// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "./TransferProxy.sol/";

contract Marketplace {
    uint public itemCount;  
    TransferProxy transferProxy = new TransferProxy();

    event List(
        uint itemId,
        address indexed nft,
        uint tokenId,
        uint price,
        address indexed seller
    );
    event Bought(
        uint itemId,
        address indexed nft,
        uint tokenId,
        uint price,
        address indexed seller,
        address indexed buyer
    ); 

    struct NFTERC721Item{
        ERC721 erc721Token;
        uint itemId;
        uint tokenId;
        uint price;
        address payable seller;
        bool sold;
    }

    mapping(uint => NFTERC721Item) public _NFTItems;
    
    function listERC721Item(ERC721 _token, uint256 _price, uint256 _tokenId) public{
        require(_price > 0, "Price must greater than zero");
        itemCount++;
        _token.setApprovalForAll(address(this), true);
        _token.transferFrom(msg.sender, address(transferProxy), _tokenId);
        
        _NFTItems[itemCount] = NFTERC721Item(
            _token,
            itemCount,
            _tokenId,
            _price,
            payable(msg.sender),
            false
        );
        emit List(itemCount, address(_token), _tokenId, _price, msg.sender);
    }
    function purchaseERC721Item(uint _itemId) external payable {
        NFTERC721Item storage item = _NFTItems[_itemId];
        require(_itemId > 0 && _itemId <= itemCount, "item doesn't exist");
        require(!item.sold, "item already sold");
        // pay seller and feeAccount
        item.seller.transfer(item.price);
        // update item to sold
        item.sold = true;
        // transfer nft to buyer
        item.erc721Token.setApprovalForAll(address(this), true);
        transferProxy.erc721safeTransferFrom(item.erc721Token, address(transferProxy), msg.sender, item.tokenId);
        // emit Bought event
        emit Bought(
            _itemId,
            address(item.erc721Token),
            item.tokenId,
            item.price,
            item.seller,
            msg.sender
        );
    }
    function _msgSender() public view virtual returns (address) {
        return address(this);
    }
}