// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

interface IMarketplace {
    struct Listing {
        uint256 tokenId;
        uint256 price;
        address owner;
        uint256 saleEnds;
    }

    struct Collection {
        mapping (uint256 => Listing) listings;
        EnumerableSet.UintSet listedTokens;
    }

    event CreateListing(address collection, uint256 tokenId, uint256 price, uint256 salesEnd);
    event UpdatePriceListing(address collection, uint256 tokenId, uint256 price);
    event UpdateDurationListing(address collection, uint256 tokenId, uint256 duration);
    event DeleteListing(address collection, uint256 tokenId);
    event BoughtListed(address collection, uint256 tokenId, uint256 price);

    function createListing(address collection, uint256 tokenId, uint256 price, uint256 duration) external;

    function updateListingPrice(address collection, uint256 tokenId, uint256 price) external;

    function updateListingDuration(address collection, uint256 tokenId, uint256 duration) external;

    function deleteListing(address collection, uint256 tokenId) external;

    function getListing(address collection, uint256 tokenId) external view returns (Listing memory);

    function buyListed(address collection, uint256 tokenId) external payable;
}