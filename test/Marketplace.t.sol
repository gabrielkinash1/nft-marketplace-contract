// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Test.sol";
import "../src/Marketplace.sol";
import "../src/NFT.sol";

contract MarketplaceTest is Test {
    Marketplace marketplace;
    NFT nft;

    function setUp() public {
        marketplace = new Marketplace();
        nft = new NFT();
    }

    function testCreateListing() public {
        nft.mint();
        nft.approve(address(marketplace), 0);
        marketplace.createListing(address(nft), 0, 0.01 ether, 7 days);
        Marketplace.Listing memory listing = marketplace.getListing(address(nft), 0);
        assertEq(listing.tokenId, 0);
    }

    function testBuyListed() public {
        vm.prank(address(1));
        vm.deal(address(1), 1 ether);
        nft.mint();
        vm.prank(address(1));
        nft.setApprovalForAll(address(marketplace), true);
        vm.prank(address(1));
        marketplace.createListing(address(nft), 0, 0.01 ether, 7 days);
        vm.prank(address(2));
        vm.deal(address(2), 1 ether);
        marketplace.buyListed{value: 0.01 ether}(address(nft), 0);
        assertEq(nft.balanceOf(address(2)), 1);
    }
}