// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";

contract NFT is ERC721Enumerable, ERC721Burnable {
    uint256 private _tokenId;

    event LogMint(uint256 indexed tokenId, address minter);
    
    constructor() ERC721("Testing NFT", "TEST") {}

    function mint() external payable {
        _mint(msg.sender, _tokenId);
        emit LogMint(_tokenId++, msg.sender);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}