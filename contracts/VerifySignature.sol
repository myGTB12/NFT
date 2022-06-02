// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721_Test.sol";
//message to sign
//hash(message)
//sign(hash(message), private key) | offchain
//ecrecover(hash(message), signture) == signer
contract VerifySignature {
    function getMessageHash(
        ERC721_Test tokenerc721_test,
        uint _price,
        uint _tokenId,
        address _seller
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(tokenerc721_test, _price, _tokenId, _seller));
    }

    function getEthSignedMessageHash(bytes32 _messageHash)
        public
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
            );
    }

    function verify(
        address _signer,
        ERC721_Test erc721TokenTest,
        uint _price,
        uint _tokenId,
        bytes memory signature
    ) public pure returns (bool) {
        bytes32 messageHash = getMessageHash(erc721TokenTest, _price, _tokenId, _signer);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recoverSigner(ethSignedMessageHash, signature) == _signer;
    }

    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)
        public
        pure
        returns (address)
    {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig)
        public
        pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        require(sig.length == 65, "invalid signature length");

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }
}