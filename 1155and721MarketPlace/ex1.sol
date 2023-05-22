// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Erc721/Erc721Token.sol";
import "./Erc1155/Erc1155.sol";

contract Market {
    struct AuctionDetails {
        address seller;
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
        uint256 price;
        uint256 tokenId;
        uint256 amount;
        bool onSale;
    }

    struct Bid {
        address bidder;
        uint256 bidAmount;
    }

    Erc721Token private erc721;
    Erc1155 private erc1155;

    mapping(bool => mapping(uint256 => mapping(address => AuctionDetails))) private auctions;
    mapping(bool => mapping(uint256 => mapping(address => SaleDetails))) private sales;
    mapping(bool => mapping(uint256 => Bid[])) private bids;

    event AuctionCreated(
        address seller,
        uint256 tokenId,
        uint256 price,
        uint256 amount,
        bool isErc721
    );

    event AuctionCancelled(address seller, uint256 tokenId, bool isErc721);
    event SaleCreated(address seller, uint256 tokenId, uint256 price, uint256 amount, bool isErc721);
    event SaleCancelled(address seller, uint256 tokenId, bool isErc721);
    event AuctionSuccessful(
        address highestBidder,
        uint256 tokenId,
        uint256 price,
        bool isErc721
    );

    constructor(Erc721Token _erc721, Erc1155 _erc1155) {
        erc721 = _erc721;
        erc1155 = _erc1155;
    }

    function createAuction(
        uint128 price,
        uint256 tokenId,
        uint256 amount,
        uint256 startTime,
        uint256 endTime,
        bool isErc721
    ) external {
        require(price > 0, "Market: Price must be greater than zero");
        require(startTime > block.timestamp && endTime > block.timestamp, "Market: Invalid time input");
        require(endTime > startTime, "Market: Invalid time input");

        if (isErc721) {
            require(msg.sender == erc721.ownerOf(tokenId), "Market: Only the owner can create an auction");
            require(
                erc721.getApproved(tokenId) == address(this) ||
                erc721.isApprovedForAll(msg.sender, address(this)),
                "Market: Contract is not approved to transfer the token"
            );

            auctions[isErc721][tokenId][msg.sender] = AuctionDetails(
                msg.sender,
                price,
                tokenId,
                0,
                0,
                address(0),
                startTime,
                endTime
            );
        } else {
            require(
                erc1155.balanceOf(msg.sender, tokenId) >= amount,
                "Market: Insufficient balance to create an auction"
            );
            require(
                erc1155.isApprovedForAll(msg.sender, address(this)),
                "Market: Contract is not approved to transfer the tokens"
            );

            auctions[isErc721][tokenId][msg.sender] = AuctionDetails(
                msg.sender,
                price,
                tokenId,
                amount,
                0,
                address(0),
                startTime,
                endTime
            );
        }

        emit AuctionCreated(msg.sender, tokenId, price, amount, isErc721);
    }

    function createSale(
        uint256 price,
        uint256 tokenId,
        uint256 amount,
        bool isErc721
    ) external {
        require(price > 0, "Market: Price must be greater than zero");

        if (isErc721) {
            require(msg.sender == erc721.ownerOf(tokenId), "Market: Only the owner can create a sale");
            require(
                erc721.getApproved(tokenId) == address(this) ||
                erc721.isApprovedForAll(msg.sender, address(this)),
                "Market: Contract is not approved to transfer the token"
            );

            sales[isErc721][tokenId][msg.sender] = SaleDetails(
                msg.sender,
                price,
                tokenId,
                0,
                true
            );
        } else {
            require(
                erc1155.balanceOf(msg.sender, tokenId) >= amount,
                "Market: Insufficient balance to create a sale"
            );
            require(
                erc1155.isApprovedForAll(msg.sender, address(this)),
                "Market: Contract is not approved to transfer the tokens"
            );

            sales[isErc721][tokenId][msg.sender] = SaleDetails(
                msg.sender,
                price,
                tokenId,
                amount,
                true
            );
        }

        emit SaleCreated(msg.sender, tokenId, price, amount, isErc721);
    }

    function cancelSale(uint256 tokenId, bool isErc721) external {
        if (isErc721) {
            require(sales[isErc721][tokenId][msg.sender].onSale, "Market: Token is not on sale");

            delete sales[isErc721][tokenId][msg.sender];
        } else {
            require(sales[isErc721][tokenId][msg.sender].onSale, "Market: Token is not on sale");

            delete sales[isErc721][tokenId][msg.sender];
        }

        emit SaleCancelled(msg.sender, tokenId, isErc721);
    }

    function getAuctionDetails(uint256 tokenId, bool isErc721)
        external
        view
        returns (AuctionDetails[] memory)
    {
        return auctions[isErc721][tokenId];
    }

    function getSaleDetails(uint256 tokenId, bool isErc721)
        external
        view
        returns (SaleDetails memory)
    {
        return sales[isErc721][tokenId][msg.sender];
    }

    function placeBid(uint256 tokenId, bool isErc721) external payable {
        AuctionDetails storage auction = auctions[isErc721][tokenId][msg.sender];
        require(auction.startTime < block.timestamp && auction.endTime > block.timestamp, "Market: Auction not active");
        require(msg.value > auction.highestBid, "Market: Bid amount is not higher than the current highest bid");

        bids[isErc721][tokenId].push(Bid(msg.sender, msg.value));
        auction.highestBid = msg.value;
        auction.highestBidder = msg.sender;

        emit AuctionSuccessful(
            auction.highestBidder,
            tokenId,
            auction.highestBid,
            isErc721
        );
    }

    function cancelBid(uint256 tokenId, bool isErc721) external {
        Bid[] storage bidList = bids[isErc721][tokenId];
        uint256 numBidders = bidList.length;
        require(numBidders > 0, "Market: No bids to cancel");

        for (uint256 i = 0; i < numBidders; i++) {
            if (bidList[i].bidder == msg.sender) {
                require(bidList[i].bidder != auctions[isErc721][tokenId][msg.sender].seller, "Market: Seller cannot cancel their bid");
                require(i == numBidders - 1, "Market: Cannot cancel bid once there are higher bids");

                payable(msg.sender).transfer(bidList[i].bidAmount);
                bidList.pop();

                return;
            }
        }
    }

    function acceptBid(uint256 tokenId, bool isErc721) external {
        AuctionDetails storage auction = auctions[isErc721][tokenId][msg.sender];
        require(auction.endTime < block.timestamp, "Market: Auction is still active");
        require(auction.highestBidder != address(0), "Market: No bids to accept");

        address highestBidder = auction.highestBidder;
        uint256 highestBid = auction.highestBid;

        if (isErc721) {
            erc721.safeTransferFrom(
                msg.sender,
                highestBidder,
                tokenId
            );
        } else {
            erc1155.safeTransferFrom(
                msg.sender,
                highestBidder,
                tokenId,
                auction.amount,
                ""
            );
        }

        delete auctions[isErc721][tokenId][msg.sender];

        emit AuctionSuccessful(
            highestBidder,
            tokenId,
            highestBid,
            isErc721
        );
    }
}
