// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "./IMarketplace.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract Marketplace is Ownable, IMarketplace {
    using Address for address;
    using EnumerableSet for EnumerableSet.UintSet;

    mapping (address => Collection) private collections;

    function createListing(address collection, uint256 tokenId, uint256 price, uint256 duration) external {
        require(IERC721Enumerable(collection).ownerOf(tokenId) == msg.sender, "You're not the NFT holder.");
        uint256 timestamp = block.timestamp + duration;
        Listing memory listing = Listing(
            tokenId,
            price,
            msg.sender,
            timestamp
        );
        collections[collection].listings[tokenId] = listing;
        collections[collection].listedTokens.add(tokenId);
        emit CreateListing(collection, tokenId, price, timestamp);
    }

    function updateListingPrice(address collection, uint256 tokenId, uint256 price) external {
        require(IERC721Enumerable(collection).ownerOf(tokenId) == msg.sender, "You're not the NFT holder.");
        collections[collection].listings[tokenId].price = price;
        emit UpdatePriceListing(collection, tokenId, price);
    }

    function updateListingDuration(address collection, uint256 tokenId, uint256 duration) external {
        require(IERC721Enumerable(collection).ownerOf(tokenId) == msg.sender, "You're not the NFT holder.");
        uint256 timestamp = block.timestamp + duration;
        collections[collection].listings[tokenId].saleEnds = timestamp;
        emit UpdateDurationListing(collection, tokenId, timestamp);
    }

    function deleteListing(address collection, uint256 tokenId) external {
        require(IERC721Enumerable(collection).ownerOf(tokenId) == msg.sender, "You're not the NFT holder.");
        delete collections[collection].listings[tokenId];
        collections[collection].listedTokens.remove(tokenId);
        emit DeleteListing(collection, tokenId);
    }

    function getListing(address collection, uint256 tokenId) external view returns (Listing memory) {
        Listing memory listing = collections[collection].listings[tokenId];
        require(IERC721Enumerable(collection).ownerOf(tokenId) == listing.owner, "Failed to get listing");
        return listing;
    }

    function buyListed(address collection, uint256 tokenId) external payable {
        Listing memory listing = collections[collection].listings[tokenId];
        require(IERC721Enumerable(collection).ownerOf(tokenId) == listing.owner, "Failed to buy listed");
        require(msg.value >= listing.price, "Failed to buy listed");
        IERC721(collection).safeTransferFrom(listing.owner, msg.sender, tokenId);
        Address.sendValue(payable(listing.owner), msg.value);
        delete collections[collection].listings[tokenId];
        collections[collection].listedTokens.remove(tokenId);
        emit BoughtListed(collection, tokenId, msg.value);
    }
}