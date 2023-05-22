// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IUpdateMarket {
    struct AuctionDetails {
        address seller;
        address contractAddress;
        uint128 price;
        uint256 tokenId;
        uint256 amount;
        uint256 highestBid;
        address highestBidder;
        uint256 startTime;
        uint256 endTime;
    }
    struct SaleDetails {
        address seller;
        address contractAddress;
        uint256 price;
        uint256 tokenId;
        uint256 amount;
    }
    struct Bid {
        address bidder;
        uint256 bidAmount;
    }
}
