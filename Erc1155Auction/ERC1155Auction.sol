// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../ERC1155/ERC1155.sol";

contract Auction1155 {
    struct Auction {
        address seller;
        uint128 price;
        uint256 nftId;
        uint256 amount;
        uint256 startTime;
        uint256 endTime;
    }
    struct Bidder {
        uint256 highestBid;
        address highestBidder;
    }

    address erc1155;

    mapping(uint256 => mapping(address => Auction)) private _nftOnAuction;
    mapping(uint256 => mapping(address => Bidder)) private _bidderDetails;

    constructor(address _erc1155) {
        erc1155 = _erc1155;
    }

    function setAuction(
        uint128 price,
        uint256 nftId,
        uint256 amount,
        uint256 startTime,
        uint256 endTime
    ) external {
        require(
            IERC1155(erc1155).balanceOf(msg.sender, nftId) >= amount,
            "ERC1155: not owner of nft"
        );
        require(price != 0 && amount != 0, "ERC1155: enter more than zero");
        require(
            _nftOnAuction[nftId][msg.sender].seller == address(0),
            "ERC1155: nft already on auction"
        );
        require(
            startTime > block.timestamp && endTime > block.timestamp,
            "ERC1155: wrong time input"
        );
        require(endTime > startTime, "ERC1155: wrong time input");
        require(
            IERC1155(erc1155).isApprovedForAll(msg.sender, address(this)),
            "ERC1155: contract not approved"
        );
        _nftOnAuction[nftId][msg.sender] = Auction(
            msg.sender,
            price,
            nftId,
            amount,
            startTime,
            endTime
        );
    }

    function auction(uint256 nftId, address seller)
        external
        view
        returns (Auction memory)
    {
        return _nftOnAuction[nftId][seller];
    }

    function bid(uint256 nftId, address seller) external payable {
        require(
            _nftOnAuction[nftId][seller].seller != msg.sender,
            "ERC721Auction: seller not allowed"
        );
        require(
            _nftOnAuction[nftId][seller].nftId == nftId,
            "ERC1155: nft not on auction"
        );
        require(
            _nftOnAuction[nftId][seller].startTime != 0 &&
                _nftOnAuction[nftId][seller].startTime <= block.timestamp,
            "ERC1155: auction not started"
        );

        require(
            _nftOnAuction[nftId][seller].endTime >= block.timestamp,
            "ERC1155: auction is ended"
        );
        require(
            _nftOnAuction[nftId][seller].price <= msg.value,
            "ERC1155: enter correct ether"
        );
        require(
            _bidderDetails[nftId][seller].highestBid < msg.value,
            "ERC1155:bid with more ether"
        );

        payable(_bidderDetails[nftId][seller].highestBidder).transfer(
            _bidderDetails[nftId][seller].highestBid
        );

        _bidderDetails[nftId][seller].highestBid = msg.value;
        _bidderDetails[nftId][seller].highestBidder = msg.sender;
    }

    function nftClaim(uint256 nftId, address seller) external {
        require(
            _nftOnAuction[nftId][seller].nftId == nftId,
            "ERC1155: nft not on auction"
        );
        require(
            _nftOnAuction[nftId][seller].endTime <= block.timestamp,
            "ERC1155: auction not ended"
        );

        require(
            msg.sender == _nftOnAuction[nftId][seller].seller ||
                _bidderDetails[nftId][seller].highestBidder == msg.sender,
            "ERC1155: you are not allowed"
        );

        IERC1155(erc1155).safeTransferFrom(
            _nftOnAuction[nftId][seller].seller,
            _bidderDetails[nftId][seller].highestBidder,
            nftId,
            _nftOnAuction[nftId][seller].amount,
            ""
        );
        payable(_nftOnAuction[nftId][seller].seller).transfer(
            _bidderDetails[nftId][seller].highestBid
        );
        delete _nftOnAuction[nftId][seller];
    }

    function cancelAuction(uint256 nftId, address seller) external {
        require(
            _nftOnAuction[nftId][seller].nftId == nftId,
            "ERC721Auction: nft not on auction"
        );
        require(
            msg.sender == _nftOnAuction[nftId][seller].seller,
            "ERC721Auction: not owner of nft"
        );
        require(
            _nftOnAuction[nftId][seller].endTime >= block.timestamp,
            "ERC721Auction: auction is ended"
        );

        payable(_bidderDetails[nftId][seller].highestBidder).transfer(
            _bidderDetails[nftId][seller].highestBid
        );
        delete _nftOnAuction[nftId][seller];
    }
}
