// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma abicoder v2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

interface INftTransferProxy {
    function erc721safeTransferFrom(ERC721 token, address from, address to, uint256 tokenId) external;

    function erc1155safeTransferFrom(ERC1155 token, address from, address to, uint256 id, uint256 value, bytes calldata data) external;

    function erc20safeTransferFrom(ERC20 token, address from, address to, uint256 value) external;
}