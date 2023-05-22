// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Erc721/Erc721Token.sol";
import "./Erc1155/Erc1155.sol";

contract Market {
    struct AuctionDetails {
        address seller;
        uint128 price;
        uint256 nftId;
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

    Erc721Token erc721;
    Erc1155 erc1155;

    event SetDetails(
        address seller,
        uint256 nftId,
        uint256 price,
        uint256 amount,
        bool isErc721
    );
    event PurchaseToken(
        address seller,
        address to,
        uint256 tokenId,
        uint256 price,
        uint256 amount,
        bool isErc721
    );
    event HighestBidder(
        address highestBidder,
        uint256 nftId,
        uint256 price,
        bool isErc721
    );
    event CancelAuction(address seller, uint256 tokenId, bool isErc721);

    mapping(bool => mapping(uint256 => mapping(address => AuctionDetails)))
        private _auctionList;
    mapping(bool => mapping(uint256 => mapping(address => SaleDetails)))
        private _saleList;

    constructor(Erc721Token _erc721, Erc1155 _erc1155) {
        erc721 = _erc721;
        erc1155 = _erc1155;
    }

    function mint(
        address to,
        uint256 tokenId,
        uint256 amount
    ) external {
        if (amount == 0) {
            erc721.mintToken(to, tokenId);
        } else {
            erc1155.mint(to, tokenId, amount);
        }
    }

    function setAuction(
        uint128 price,
        uint256 nftId,
        uint256 amount,
        uint256 startTime,
        uint256 endTime,
        bool isErc721
    ) external {
        require(
            _saleList[isErc721][nftId][msg.sender].tokenId != nftId,
            "Market: already on sale "
        );
        require(price != 0, "Market: price zero");
        require(
            _auctionList[isErc721][nftId][msg.sender].seller == address(0),
            "Market: nft already on auction"
        );
        require(
            startTime > block.timestamp && endTime > block.timestamp,
            "Market: wrong time input"
        );
        require(endTime > startTime, "Market: wrong time input");

        if (amount == 0 && isErc721) {
            require(
                msg.sender == erc721.ownerOf(nftId),
                "Market: invalid owner"
            );
            require(
                erc721.getApproved(nftId) == address(this) ||
                    erc721.isApprovedForAll(msg.sender, address(this)),
                "Market: contract not approved"
            );
            _auctionList[true][nftId][msg.sender] = AuctionDetails(
                msg.sender,
                price,
                nftId,
                amount,
                0,
                address(0),
                startTime,
                endTime
            );
        } else if (isErc721 == false) {
            require(
                erc1155.balanceOf(msg.sender, nftId) >= amount,
                "Market: invalid owner"
            );
            require(
                erc1155.isApprovedForAll(msg.sender, address(this)),
                "Market: contract not approved"
            );

            _auctionList[false][nftId][msg.sender] = AuctionDetails(
                msg.sender,
                price,
                nftId,
                amount,
                0,
                address(0),
                startTime,
                endTime
            );
        } else {
            revert("Market: invalid input");
        }
        emit SetDetails(msg.sender, nftId, price, amount, isErc721);
    }

    function setOnSale(
        uint256 price,
        uint256 tokenId,
        uint256 amount,
        bool isErc721
    ) external {
        require(
            _auctionList[isErc721][tokenId][msg.sender].nftId != tokenId,
            "Market: already on auction"
        );
        require(price > 0, "Market:enter more than zero");
        require(
            !_saleList[isErc721][tokenId][msg.sender].onSale,
            "Market:token already on Sale"
        );
        if (amount == 0 && isErc721) {
            require(
                erc721.ownerOf(tokenId) == msg.sender,
                "Market: invalid token owner"
            );
            require(
                erc721.getApproved(tokenId) == address(this) ||
                    erc721.isApprovedForAll(msg.sender, address(this)),
                "Market: contract not approved"
            );
            _saleList[true][tokenId][msg.sender] = SaleDetails(
                msg.sender,
                price,
                tokenId,
                amount,
                true
            );
        } else if (isErc721 == false) {
            require(
                erc1155.balanceOf(msg.sender, tokenId) >= amount,
                "Market: invalid owner"
            );
            require(
                erc1155.isApprovedForAll(msg.sender, address(this)),
                "Market: contract not approved"
            );
            _saleList[false][tokenId][msg.sender] = SaleDetails(
                msg.sender,
                price,
                tokenId,
                amount,
                true
            );
        } else {
            revert("Market: invalid input");
        }
        emit SetDetails(msg.sender, tokenId, price, amount, isErc721);
    }

    function cancelSale(
        address seller,
        uint256 tokenId,
        bool isErc721
    ) external {
        require(
            _saleList[isErc721][tokenId][seller].onSale,
            "Market: token not Sale"
        );
        require(
            _saleList[isErc721][tokenId][seller].seller == msg.sender,
            "Market: only token seller"
        );

        delete _saleList[isErc721][tokenId][seller];
    }

    function onSale(
        bool isErc721,
        address sellerAddress,
        uint256 tokenId
    ) external view returns (SaleDetails memory) {
        return _saleList[isErc721][tokenId][sellerAddress];
    }

    function onAunction(
        bool isErc721,
        address sellerAddress,
        uint256 tokenId
    ) external view returns (AuctionDetails memory) {
        return _auctionList[isErc721][tokenId][sellerAddress];
    }

    function purchaseToken(
        address seller,
        address to,
        uint256 tokenId,
        uint256 amount,
        bool isErc721
    ) external payable {
        address tempSeller = _saleList[isErc721][tokenId][msg.sender].seller;

        require(
            to != address(0) && seller != address(0),
            "Market: zero address"
        );
        require(
            _saleList[isErc721][tokenId][seller].seller != msg.sender,
            "Market: seller not allowed"
        );
        require(
            _saleList[isErc721][tokenId][seller].onSale,
            "Market: nft not on sale"
        );

        if (amount == 0 && isErc721) {
            require(
                msg.value == _saleList[true][tokenId][seller].price,
                "Market: enter a valid ether"
            );

            _saleList[true][tokenId][seller].onSale = false;
            erc721.transferFrom(seller, msg.sender, tokenId);
            payable(tempSeller).transfer(msg.value);
        } else if (isErc721 == false) {
            require(
                _saleList[false][tokenId][seller].amount >= amount,
                "Market: invalid input"
            );
            require(
                _saleList[false][tokenId][seller].price * amount == msg.value,
                "Market: enter valid ether"
            );

            _saleList[false][tokenId][seller].amount -= amount;
            if (_saleList[false][tokenId][seller].amount == 0) {
                _saleList[false][tokenId][seller].onSale = false;
            }
            erc1155.safeTransferFrom(seller, to, tokenId, amount, "");

            payable(tempSeller).transfer(msg.value);
        } else {
            revert("Market: invalid input");
        }
        emit PurchaseToken(seller, to, tokenId, msg.value, amount, isErc721);
    }

    function bid(
        bool isErc721,
        uint256 nftId,
        address seller
    ) external payable {
        address tempHighestBidder = _auctionList[isErc721][nftId][seller]
            .highestBidder;
        uint256 tempHighestBid = _auctionList[isErc721][nftId][seller]
            .highestBid;
        require(
            _auctionList[isErc721][nftId][seller].seller != msg.sender,
            "Market: seller not allowed"
        );
        require(
            _auctionList[isErc721][nftId][seller].nftId == nftId,
            "Market: nft not on auction"
        );
        require(
            _auctionList[isErc721][nftId][seller].startTime <= block.timestamp,
            "Market: auction not started"
        );
        require(
            _auctionList[isErc721][nftId][seller].endTime >= block.timestamp,
            "Market: auction is ended"
        );

        require(
            _auctionList[isErc721][nftId][seller].price <= msg.value,
            "Market: enter correct ether"
        );
        require(
            _auctionList[isErc721][nftId][seller].highestBid < msg.value,
            "Market:bid with more ether"
        );

        if (isErc721) {
            payable(tempHighestBidder).transfer(tempHighestBid);

            _auctionList[true][nftId][seller].highestBid = msg.value;
            _auctionList[true][nftId][seller].highestBidder = msg.sender;
        } else {
            payable(tempHighestBidder).transfer(tempHighestBid);

            _auctionList[false][nftId][seller].highestBid = msg.value;
            _auctionList[false][nftId][seller].highestBidder = msg.sender;
        }
        emit HighestBidder(msg.sender, nftId, msg.value, isErc721);
    }

    function claim(
        bool isErc721,
        uint256 nftId,
        address seller
    ) external {
        address tempSeller = _auctionList[isErc721][nftId][seller].seller;
        uint256 tempHighestBid = _auctionList[isErc721][nftId][seller]
            .highestBid;
        address tempHighestBidder = _auctionList[isErc721][nftId][seller]
            .highestBidder;
        uint256 tempAmount = _auctionList[isErc721][nftId][seller].amount;
        require(
            _auctionList[isErc721][nftId][seller].nftId == nftId,
            "Market: nft not on auction"
        );
        require(
            _auctionList[isErc721][nftId][seller].endTime <= block.timestamp,
            "Market: auction not ended"
        );
        require(
            msg.sender == _auctionList[isErc721][nftId][seller].seller ||
                _auctionList[isErc721][nftId][seller].highestBidder ==
                msg.sender,
            "Market: you are not allowed"
        );
        if (isErc721) {
            delete _auctionList[true][nftId][seller];
            payable(tempSeller).transfer(tempHighestBid);
            erc721.transferFrom(tempSeller, tempHighestBidder, nftId);
        } else {
            delete _auctionList[false][nftId][seller];

            payable(tempSeller).transfer(tempHighestBid);
            erc1155.safeTransferFrom(
                tempSeller,
                tempHighestBidder,
                nftId,
                tempAmount,
                ""
            );
        }
        emit HighestBidder(
            _auctionList[false][nftId][seller].highestBidder,
            nftId,
            _auctionList[false][nftId][seller].highestBid,
            isErc721
        );
    }

    function cancelAuction(
        bool isErc721,
        uint256 tokenId,
        address seller
    ) external {
        address tempHighestBidder = _auctionList[isErc721][tokenId][seller]
            .highestBidder;
        uint256 tempHighestBid = _auctionList[isErc721][tokenId][seller]
            .highestBid;
        require(
            _auctionList[isErc721][tokenId][seller].nftId == tokenId,
            "Market: nft not on sale"
        );

        require(
            _auctionList[isErc721][tokenId][seller].seller == msg.sender,
            "Market: only seller allowed"
        );
        require(
            _auctionList[isErc721][tokenId][seller].endTime >= block.timestamp,
            "Market: auction already ended"
        );
        delete _auctionList[isErc721][tokenId][seller];
        payable(tempHighestBidder).transfer(tempHighestBid);

        emit CancelAuction(msg.sender, tokenId, isErc721);
    }
}
