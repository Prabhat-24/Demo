// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Erc721.sol";

contract ERC721Auction {
    struct Auction {
        address seller;
        uint128 price;
        uint256 nftId;
        uint256 startTime;
        uint256 endTime;
    }
    struct BidWinner {
        uint256 highestBid;
        address highestBidder;
    }

    Erc721 erc721;

    mapping(uint256 => Auction) private _nftOnAuction;
    mapping(uint256 => BidWinner) private _bidWinner;

    event OnAuction(uint256 nftId, uint128 price);
    event HighestBidder(address highestBidder, uint256 nftId, uint256 price);

    constructor(Erc721 _erc721) {
        erc721 = _erc721;
    }

    function setAuction(
        address seller,
        uint128 price,
        uint256 nftId,
        uint256 startTime,
        uint256 endTime
    ) external {
        require(
            msg.sender == erc721.ownerOf(nftId),
            "ERC721Auction: not owner of nft"
        );
        require(price != 0, "ERC721Auction: price zero");
        require(
            startTime > block.timestamp && endTime > block.timestamp,
            "ERC721Auction: wrong time input"
        );
        require(endTime > startTime, "ERC721Auction: wrong time input");
        require(
            erc721.getApproved(nftId) == address(this) ||
                erc721.isApprovedForAll(erc721.ownerOf(nftId), address(this)),
            "ERC721Auction: contract not approved"
        );

        _nftOnAuction[nftId] = Auction(
            seller,
            price,
            nftId,
            startTime,
            endTime
        );
    }

    function onAuction(uint256 nftId) external view returns (Auction memory) {
        return _nftOnAuction[nftId];
    }

    function bidding(uint256 nftId) external payable {
        require(
            _nftOnAuction[nftId].startTime <= block.timestamp,
            "ERC721Auction: auction not started"
        );
        require(
            _nftOnAuction[nftId].endTime >= block.timestamp,
            "ERC721Auction: auction is over"
        );
        require(
            _nftOnAuction[nftId].price <= msg.value,
            "ERC721Auction: enter correct ether"
        );
        require(
            _bidWinner[nftId].highestBid < msg.value,
            "ERC721Auction:bid with more ether"
        );

        payable(_bidWinner[nftId].highestBidder).transfer(
            _bidWinner[nftId].highestBid
        );

        _bidWinner[nftId].highestBid = msg.value;
        _bidWinner[nftId].highestBidder = msg.sender;
    }

    function nftTransfer(uint256 nftId) external {
        require(
            block.timestamp >= _nftOnAuction[nftId].endTime,
            "ERC721Auction: auction not over"
        );
        require(
            msg.sender == _nftOnAuction[nftId].seller ||
                _bidWinner[nftId].highestBidder == msg.sender,
            "ERC721Auction: you are not allowed"
        );

        erc721.transferFrom(
            erc721.ownerOf(nftId),
            _bidWinner[nftId].highestBidder,
            nftId
        );
        payable(_nftOnAuction[nftId].seller).transfer(
            _bidWinner[nftId].highestBid
        );
        emit HighestBidder(
            _bidWinner[nftId].highestBidder,
            nftId,
            _bidWinner[nftId].highestBid
        );
        delete _nftOnAuction[nftId];
    }

    function cancelBid(uint256 nftId) external {
        require(
            msg.sender == erc721.ownerOf(nftId),
            "ERC721Auction: not owner of nft"
        );
        require(
            _nftOnAuction[nftId].nftId == nftId,
            "ERC721Auction: nft not on auction"
        );
        require(
            _nftOnAuction[nftId].endTime > block.timestamp,
            "ERC721Auction: auction is over"
        );

        payable(_bidWinner[nftId].highestBidder).transfer(
            _bidWinner[nftId].highestBid
        );
        delete _nftOnAuction[nftId];
    }
}
