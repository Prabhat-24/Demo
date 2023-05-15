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
    struct Bidder {
        uint256 highestBid;
        address highestBidder;
    }

    Erc721 erc721;

    mapping(uint256 => Auction) private _nftOnAuction;
    mapping(uint256 => Bidder) private _bidderDetails;

    event OnAuction(uint256 nftId, uint128 price);
    event HighestBidder(address highestBidder, uint256 nftId, uint256 price);

    constructor(Erc721 _erc721) {
        erc721 = _erc721;
    }

    function setAuction(
        uint128 price,
        uint256 nftId,
        uint256 startTime,
        uint256 endTime
    ) external {
        require(
            msg.sender == erc721.ownerOf(nftId),
            "ERC721Auction: not owner of nft"
        );
        require(
            _nftOnAuction[nftId].seller == address(0),
            "ERC721Auction: nft already on auction"
        );
        require(price != 0, "ERC721Auction: price zero");
        require(
            startTime > block.timestamp && endTime > block.timestamp,
            "ERC721Auction: wrong time input"
        );
        require(endTime > startTime, "ERC721Auction: wrong time input");
        require(
            erc721.getApproved(nftId) == address(this) ||
                erc721.isApprovedForAll(
                    _nftOnAuction[nftId].seller,
                    address(this)
                ),
            "ERC721Auction: contract not approved"
        );

        _nftOnAuction[nftId] = Auction(
            msg.sender,
            price,
            nftId,
            startTime,
            endTime
        );
    }

    function auction(uint256 nftId) external view returns (Auction memory) {
        return _nftOnAuction[nftId];
    }

    function bid(uint256 nftId) external payable {
        require(
            _nftOnAuction[nftId].seller != msg.sender,
            "ERC721Auction: seller not allowed"
        );

        require(
            _nftOnAuction[nftId].nftId == nftId,
            "ERC721Auction: nft not on auction"
        );
        require(
            _nftOnAuction[nftId].startTime <= block.timestamp,
            "ERC721Auction: auction not started"
        );
        require(
            _nftOnAuction[nftId].endTime >= block.timestamp,
            "ERC721Auction: auction is ended"
        );
        require(
            _nftOnAuction[nftId].price <= msg.value,
            "ERC721Auction: enter correct ether"
        );
        require(
            _bidderDetails[nftId].highestBid < msg.value,
            "ERC721Auction:bid with more ether"
        );

        payable(_bidderDetails[nftId].highestBidder).transfer(
            _bidderDetails[nftId].highestBid
        );

        _bidderDetails[nftId].highestBid = msg.value;
        _bidderDetails[nftId].highestBidder = msg.sender;
    }

    function nftClaim(uint256 nftId) external {
        require(
            _nftOnAuction[nftId].nftId == nftId,
            "ERC721Auction: nft not on auction"
        );
        require(
            _nftOnAuction[nftId].endTime <= block.timestamp,
            "ERC721Auction: auction not ended"
        );

        require(
            msg.sender == _nftOnAuction[nftId].seller ||
                _bidderDetails[nftId].highestBidder == msg.sender,
            "ERC721Auction: you are not allowed"
        );

        erc721.transferFrom(
            _nftOnAuction[nftId].seller,
            _bidderDetails[nftId].highestBidder,
            nftId
        );
        payable(_nftOnAuction[nftId].seller).transfer(
            _bidderDetails[nftId].highestBid
        );
        emit HighestBidder(
            _bidderDetails[nftId].highestBidder,
            nftId,
            _bidderDetails[nftId].highestBid
        );
        delete _nftOnAuction[nftId];
    }

    function cancelAuction(uint256 nftId) external {
        require(
            _nftOnAuction[nftId].nftId == nftId,
            "ERC721Auction: nft not on auction"
        );
        require(
            msg.sender == _nftOnAuction[nftId].seller,
            "ERC721Auction: not owner of nft"
        );
        require(
            _nftOnAuction[nftId].endTime >= block.timestamp,
            "ERC721Auction: auction is ended"
        );

        payable(_bidderDetails[nftId].highestBidder).transfer(
            _bidderDetails[nftId].highestBid
        );
        delete _nftOnAuction[nftId];
    }
}
