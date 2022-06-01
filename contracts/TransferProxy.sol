// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./INftTransferProxy.sol";
import "./OperatorRole.sol";

contract TransferProxy is INftTransferProxy, OperatorRole {
    function __TransferProxy_init() external initializer {
         __Ownable_init();
    }

    function erc721safeTransferFrom(ERC721 token, address from, address to, uint256 tokenId) 
    override external onlyOperator {    
        token.safeTransferFrom(from, to, tokenId);
    }

    function erc1155safeTransferFrom(ERC1155 token, address from, address to, uint256 id, 
    uint256 value, bytes calldata data) override external onlyOperator {
        token.safeTransferFrom(from, to, id, value, data);
    }
    
    function erc20safeTransferFrom(ERC20 token, address from, address to, uint256 value) override external onlyOperator{
        require(token.transferFrom(from, to, value), "failure while transferring");
    }
}
