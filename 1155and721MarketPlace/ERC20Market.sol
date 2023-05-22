// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Erc721/Erc721Token.sol";
import "./Erc1155/Erc1155.sol";
import "./ERC20.sol";

contract ERC20Market {
    struct AuctionDetails {
        address seller;
        uint128 erc20Amount;
        uint256 nftId;
        uint256 amount;
        uint256 highestBid;
        address highestBidder;
        uint256 startTime;
        uint256 endTime;
    }
    struct SaleDetails {
        address seller;
        uint256 erc20Amount;
        uint256 tokenId;
        uint256 amount;
    }
    struct Bidders {
        address bidder;
        uint256 bid;
    }

    Erc721Token erc721;
    Erc1155 erc1155;
    ERC20 erc20;

    event SetDetails(
        address seller,
        uint256 nftId,
        uint256 erc20Amount,
        uint256 amount,
        bool isErc721
    );
    event PurchaseToken(
        address seller,
        address to,
        uint256 tokenId,
        uint256 erc20Amount,
        uint256 amount,
        bool isErc721
    );
    event HighestBidder(
        address highestBidder,
        uint256 nftId,
        uint256 erc20Amount,
        bool isErc721
    );
    event CancelAuction(address seller, uint256 tokenId, bool isErc721);

    mapping(bool => mapping(uint256 => mapping(address => AuctionDetails)))
        private _auctionList;
    mapping(bool => mapping(uint256 => mapping(address => SaleDetails)))
        private _saleList;
    mapping(bool => mapping(uint256 => Bidders[])) private _biddersDetails;

    constructor(
        Erc721Token _erc721,
        Erc1155 _erc1155,
        ERC20 _erc20
    ) {
        erc721 = _erc721;
        erc1155 = _erc1155;
        erc20 = _erc20;
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
        uint128 erc20Amount,
        uint256 nftId,
        uint256 amount,
        uint256 startTime,
        uint256 endTime,
        bool isErc721
    ) external {
        require(erc20Amount != 0, "Market: erc20Amount zero");
        require(
            _saleList[isErc721][nftId][msg.sender].tokenId != nftId,
            "Market: already on sale "
        );
        require(
            _auctionList[isErc721][nftId][msg.sender].seller == address(0),
            "Market: nft already on auction"
        );
        require(
            startTime > block.timestamp && endTime > block.timestamp,
            "Market: wrong time input"
        );
        require(endTime > startTime, "Market: wrong time input");

        if (isErc721) {
            require(
                msg.sender == erc721.ownerOf(nftId),
                "Market: not owner of contract"
            );
            require(
                erc721.getApproved(nftId) == address(this) ||
                    erc721.isApprovedForAll(msg.sender, address(this)),
                "Market: contract not approved"
            );
            _auctionList[true][nftId][msg.sender] = AuctionDetails(
                msg.sender,
                erc20Amount,
                nftId,
                0,
                0,
                address(0),
                startTime,
                endTime
            );
        } else {
            require(amount != 0, "Market: zero amount");
            require(
                erc1155.balanceOf(msg.sender, nftId) >= amount,
                "Market: not owner of contract"
            );
            require(
                erc1155.isApprovedForAll(msg.sender, address(this)),
                "Market: contract not approved"
            );

            _auctionList[false][nftId][msg.sender] = AuctionDetails(
                msg.sender,
                erc20Amount,
                nftId,
                amount,
                0,
                address(0),
                startTime,
                endTime
            );
        }
        emit SetDetails(msg.sender, nftId, erc20Amount, amount, isErc721);
    }

    function setOnSale(
        uint256 erc20Amount,
        uint256 tokenId,
        uint256 amount,
        bool isErc721
    ) external {
        require(
            _auctionList[isErc721][tokenId][msg.sender].nftId != tokenId,
            "Market: already on auction"
        );

        require(erc20Amount != 0, "Market:enter more than zero");
        require(
            _saleList[isErc721][tokenId][msg.sender].tokenId != tokenId,
            "Market:token already on Sale"
        );

        if (isErc721) {
            require(
                erc721.ownerOf(tokenId) == msg.sender,
                "Market: not owner of token"
            );
            require(
                erc721.getApproved(tokenId) == address(this) ||
                    erc721.isApprovedForAll(msg.sender, address(this)),
                "Market: contract not approved"
            );
            _saleList[true][tokenId][msg.sender] = SaleDetails(
                msg.sender,
                erc20Amount,
                tokenId,
                0
            );
        } else {
            require(amount != 0, "Market: zero amount");
            require(
                erc1155.balanceOf(msg.sender, tokenId) >= amount,
                "Market: not owner of contract"
            );
            require(
                erc1155.isApprovedForAll(msg.sender, address(this)),
                "Market: contract not approved"
            );
            _saleList[false][tokenId][msg.sender] = SaleDetails(
                msg.sender,
                erc20Amount,
                tokenId,
                amount
            );
        }
        emit SetDetails(msg.sender, tokenId, erc20Amount, amount, isErc721);
    }

    function cancelSale(
        address seller,
        uint256 tokenId,
        bool isErc721
    ) external {
        require(
            _saleList[isErc721][tokenId][seller].tokenId == tokenId,
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
        uint256 tokenId,
        uint256 amount,
        bool isErc721
    ) external {
        address tempSeller = _saleList[isErc721][tokenId][seller].seller;
        uint256 tempAmount = _saleList[isErc721][tokenId][seller].erc20Amount;
        require(seller != address(0), "Market: zero address");
        require(tempSeller != msg.sender, "Market: seller not allowed");
        require(
            _saleList[isErc721][tokenId][seller].tokenId == tokenId,
            "Market: nft not on sale"
        );
        require(
            erc20.balanceOf(msg.sender) >=
                _saleList[isErc721][tokenId][seller].erc20Amount,
            "MarketErc721: insufficient token"
        );

        if (isErc721) {
            delete _saleList[true][tokenId][seller];
            erc20.transferFrom(msg.sender, tempSeller, tempAmount);
            erc721.transferFrom(tempSeller, msg.sender, tokenId);
        } else {
            require(
                _saleList[false][tokenId][seller].amount >= amount,
                "Market: invalid input"
            );

            _saleList[false][tokenId][seller].amount -= amount;

            erc20.transferFrom(msg.sender, tempSeller, tempAmount * amount);
            erc1155.safeTransferFrom(
                tempSeller,
                msg.sender,
                tokenId,
                amount,
                ""
            );
            if (_saleList[false][tokenId][seller].amount == 0) {
                delete _saleList[false][tokenId][seller];
            }
        }
        emit PurchaseToken(
            seller,
            msg.sender,
            tokenId,
            tempAmount,
            amount,
            isErc721
        );
    }

    function bid(
        bool isErc721,
        uint256 nftId,
        address seller,
        uint256 numberOfErc20Token
    ) external {
        require(
            _auctionList[isErc721][nftId][seller].seller != msg.sender,
            "Market: seller not allowed"
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
            erc20.balanceOf(msg.sender) >=
                _auctionList[isErc721][nftId][seller].erc20Amount,
            "Market: insufficient token"
        );
        require(
            _auctionList[isErc721][nftId][seller].highestBid <
                numberOfErc20Token,
            "Market:bid with more token"
        );

        _biddersDetails[isErc721][nftId].push(
            Bidders(msg.sender, numberOfErc20Token)
        );

        _auctionList[isErc721][nftId][seller].highestBid = numberOfErc20Token;
        _auctionList[isErc721][nftId][seller].highestBidder = msg.sender;
        erc20.transferFrom(msg.sender, address(this), numberOfErc20Token);
    }

    function cancelBid(
        bool isErc721,
        uint256 nftId,
        address seller
    ) external {
        require(
            _auctionList[isErc721][nftId][seller].endTime >= block.timestamp,
            "Market: auction is ended"
        );
        for (uint256 i; i < _biddersDetails[isErc721][nftId].length; i++) {
            if (_biddersDetails[isErc721][nftId][i].bidder == msg.sender) {
                uint256 tempBid = _biddersDetails[isErc721][nftId][i].bid;
                address tempBidder = _biddersDetails[isErc721][nftId][i].bidder;
                if (i == 0) {
                    delete _biddersDetails[isErc721][nftId][i];
                    erc20.transfer(tempBidder, tempBid);
                } else if (i == _biddersDetails[isErc721][nftId].length - 1) {
                    _auctionList[isErc721][nftId][seller]
                        .highestBid = _biddersDetails[isErc721][nftId][i - 1]
                        .bid;
                    _auctionList[isErc721][nftId][seller]
                        .highestBidder = _biddersDetails[isErc721][nftId][i - 1]
                        .bidder;
                    delete _biddersDetails[isErc721][nftId][i];
                    erc20.transfer(tempBidder, tempBid);
                } else {
                    delete _biddersDetails[isErc721][nftId][i];
                    erc20.transfer(tempBidder, tempBid);
                }
            }
        }
    }

    function claim(
        bool isErc721,
        uint256 nftId,
        address seller
    ) external {
        uint256 tempHighestBid = _auctionList[isErc721][nftId][seller]
            .highestBid;
        address tempHighestBidder = _auctionList[isErc721][nftId][seller]
            .highestBidder;
        uint256 tempAmount = _auctionList[isErc721][nftId][seller].amount;

        require(
            _auctionList[isErc721][nftId][seller].endTime <= block.timestamp,
            "Market: auction not ended"
        );
        require(
            _auctionList[isErc721][nftId][seller].highestBidder == msg.sender,
            "Market: you are not allowed"
        );

        if (isErc721) {
            erc20.transfer(seller, tempHighestBid);
            _biddersDetails[isErc721][nftId].pop();
            delete _auctionList[true][nftId][seller];
            erc721.transferFrom(seller, tempHighestBidder, nftId);
        } else {
            erc20.transfer(seller, tempHighestBid);
            _biddersDetails[isErc721][nftId].pop();
            delete _auctionList[false][nftId][seller];
            erc1155.safeTransferFrom(
                seller,
                tempHighestBidder,
                nftId,
                tempAmount,
                ""
            );
        }

        if (_biddersDetails[isErc721][nftId].length > 1) {
            withdraw(isErc721, nftId);
        }
    }

    function withdraw(bool isErc721, uint256 nftId) internal {
        for (uint256 i = 0; i < _biddersDetails[isErc721][nftId].length; i++) {
            uint256 tempBid = _biddersDetails[isErc721][nftId][i].bid;
            address tempBidder = _biddersDetails[isErc721][nftId][i].bidder;

            delete _biddersDetails[isErc721][nftId][i];
            erc20.transfer(tempBidder, tempBid);
        }
    }

    function cancelAuction(
        bool isErc721,
        uint256 tokenId,
        address seller
    ) external {
        require(
            _auctionList[isErc721][tokenId][seller].seller == msg.sender,
            "Market: only seller"
        );
        require(
            _auctionList[isErc721][tokenId][seller].nftId == tokenId,
            "Market: nft not on sale"
        );
        if (_biddersDetails[isErc721][tokenId].length == 0) {
            delete _auctionList[isErc721][tokenId][seller];
        } else {
            delete _auctionList[isErc721][tokenId][seller];
            withdraw(isErc721, tokenId);
        }
    }
}
