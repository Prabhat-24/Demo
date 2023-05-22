 // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Erc721/IERC721.sol";
import "./Erc1155/IERC1155.sol";
import "./Erc721/ERC165.sol";

contract UpdateMarket {
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

    event AuctionCreated(
        address seller,
        address contractAddress,
        uint256 tokenId,
        uint256 price,
        uint256 amount
    );
    event AuctionCancelled(
        address seller,
        address contractAddress,
        uint256 tokenId,
        bool isErc721
    );
    event SaleCreated(
        address seller,
        address contractAddress,
        uint256 tokenId,
        uint256 price,
        uint256 amount
    );
    event SaleCancelled(
        address seller,
        address contractAddress,
        uint256 tokenId
    );
    event PurchaseToken(
        address seller,
        address contractAddress,
        address to,
        uint256 tokenId,
        uint256 amount
    );
    event AuctionSuccessful(
        address highestBidder,
        uint256 tokenId,
        uint256 price
    );
    // contractAddress=>tokrnId=>sellerAddress=>AuctionDetails
    mapping(address => mapping(uint256 => mapping(address => AuctionDetails)))
        private _auctionList;
    // contractAddress=>tokrnId=>sellerAddress=>SaleDetails
    mapping(address => mapping(uint256 => mapping(address => SaleDetails)))
        private _saleList;
    // contractAddress=>tokrnId=>sellerAddress=>bids
    mapping(address => mapping(uint256 => mapping(address => Bid[])))
        private _bids;

    function isERC721Mint(address contractAddress) private view returns (bool) {
        bytes4 IID_IERC721 = type(IERC721).interfaceId;
        return ERC165(contractAddress).supportsInterface(IID_IERC721);
    }

    function isERC721(address contractAddress) private view returns (bool) {
        return ERC165(contractAddress).supportsInterface(0x80ac58cd);
    }

    function isERC1155Mint(address contractAddress)
        private
        view
        returns (bool)
    {
        bytes4 IID_IERC1155 = type(IERC1155).interfaceId;
        return ERC165(contractAddress).supportsInterface(IID_IERC1155);
    }

    function isERC1155(address contractAddress) private view returns (bool) {
        return ERC165(contractAddress).supportsInterface(0xd9b67a26);
    }

    function mint(
        address to,
        address contractAddress,
        uint256 tokenId,
        uint256 amount
    ) external {
        if (isERC1155Mint(contractAddress)) {
            IERC721(contractAddress).mintToken(to, tokenId);
        } else if (isERC1155Mint(contractAddress)) {
            IERC1155(contractAddress).mint(to, tokenId, amount);
        } else {
            revert("Market: unsupported interface");
        }
    }

    function createAuction(
        address contractAddress,
        uint128 price,
        uint256 tokenId,
        uint256 amount,
        uint256 startTime,
        uint256 endTime
    ) external {
        require(price != 0, "Market: Price must be greater than zero");
        require(
            _saleList[contractAddress][tokenId][msg.sender].tokenId != tokenId,
            "Market: already on sale "
        );

        require(
            _auctionList[contractAddress][tokenId][msg.sender].seller ==
                address(0),
            "Market: nft already on auction"
        );
        require(
            startTime > block.timestamp && endTime > block.timestamp,
            "Market:  Invalid time input"
        );
        require(endTime > startTime, "Market:  Invalid time input");

        if (isERC721(contractAddress) || isERC721Mint(contractAddress)) {
            require(
                msg.sender == IERC721(contractAddress).ownerOf(tokenId),
                "Market: Only owner create an auction"
            );
            require(
                IERC721(contractAddress).getApproved(tokenId) ==
                    address(this) ||
                    IERC721(contractAddress).isApprovedForAll(
                        msg.sender,
                        address(this)
                    ),
                "Market: contract not approved"
            );
            _auctionList[contractAddress][tokenId][msg.sender] = AuctionDetails(
                msg.sender,
                contractAddress,
                price,
                tokenId,
                0,
                0,
                address(0),
                startTime,
                endTime
            );
        } else if (
            isERC1155(contractAddress) || isERC1155Mint(contractAddress)
        ) {
            require(
                IERC1155(contractAddress).balanceOf(msg.sender, tokenId) >=
                    amount,
                "Market:Insufficient balance to create  auction"
            );
            require(
                IERC1155(contractAddress).isApprovedForAll(
                    msg.sender,
                    address(this)
                ),
                "Market: contract not approved"
            );

            _auctionList[contractAddress][tokenId][msg.sender] = AuctionDetails(
                msg.sender,
                contractAddress,
                price,
                tokenId,
                amount,
                0,
                address(0),
                startTime,
                endTime
            );
        } else {
            revert("Market: wrong address");
        }
        emit AuctionCreated(
            msg.sender,
            contractAddress,
            tokenId,
            price,
            amount
        );
    }

    function createSale(
        uint256 price,
        address contractAddress,
        uint256 tokenId,
        uint256 amount
    ) external {
        require(price > 0, "Market: Price must be greater than zero");
        require(
            _auctionList[contractAddress][tokenId][msg.sender].tokenId !=
                tokenId,
            "Market: already on auction"
        );

        require(
            _saleList[contractAddress][tokenId][msg.sender].seller ==
                address(0),
            "Market:token already on Sale"
        );
        if (isERC721(contractAddress) || isERC721Mint(contractAddress)) {
            require(
                IERC721(contractAddress).ownerOf(tokenId) == msg.sender,
                "Market:  Only owner create sale"
            );
            require(
                IERC721(contractAddress).getApproved(tokenId) ==
                    address(this) ||
                    IERC721(contractAddress).isApprovedForAll(
                        msg.sender,
                        address(this)
                    ),
                "Market: contract not approved"
            );
            _saleList[contractAddress][tokenId][msg.sender] = SaleDetails(
                msg.sender,
                contractAddress,
                price,
                tokenId,
                0
            );
        } else if (
            isERC1155(contractAddress) || isERC1155Mint(contractAddress)
        ) {
            require(amount != 0, "Market: zero amount");

            require(
                IERC1155(contractAddress).balanceOf(msg.sender, tokenId) >=
                    amount,
                "Market: Insufficient balance to create sale"
            );
            require(
                IERC1155(contractAddress).isApprovedForAll(
                    msg.sender,
                    address(this)
                ),
                "Market: contract not approved"
            );
            _saleList[contractAddress][tokenId][msg.sender] = SaleDetails(
                msg.sender,
                contractAddress,
                price,
                tokenId,
                amount
            );
        } else {
            revert("Market: wrong address");
        }
        emit SaleCreated(msg.sender, contractAddress, tokenId, price, amount);
    }

    function cancelSale(address contractAddress, uint256 tokenId) external {
        require(
            _saleList[contractAddress][tokenId][msg.sender].seller ==
                msg.sender,
            "Market: only token seller"
        );

        delete _saleList[contractAddress][tokenId][msg.sender];

        emit SaleCancelled(msg.sender, contractAddress, tokenId);
    }

    function getSaleDetails(
        address contractAddress,
        address seller,
        uint256 tokenId
    ) external view returns (SaleDetails memory) {
        return _saleList[contractAddress][tokenId][seller];
    }

    function getAuctionDetails(
        address contractAddress,
        address seller,
        uint256 tokenId
    ) external view returns (AuctionDetails memory) {
        return _auctionList[contractAddress][tokenId][seller];
    }

    function purchaseToken(
        address seller,
        address contractAddress,
        uint256 tokenId,
        uint256 amount
    ) external payable {
        SaleDetails memory saleDetails = _saleList[contractAddress][tokenId][
            seller
        ];

        require(seller != address(0), "Market: zero address");
        require(saleDetails.seller != msg.sender, "Market: seller not allowed");

        require(saleDetails.tokenId == tokenId, "Market: nft not on sale");
        if (isERC721(contractAddress) || isERC721Mint(contractAddress)) {
            require(
                msg.value == saleDetails.price,
                "Market: enter a valid ether"
            );
            delete _saleList[contractAddress][tokenId][seller];
            IERC721(contractAddress).transferFrom(
                saleDetails.seller,
                msg.sender,
                saleDetails.tokenId
            );

            payable(saleDetails.seller).transfer(msg.value);
        } else if (
            isERC1155(contractAddress) || isERC1155Mint(contractAddress)
        ) {
            require(saleDetails.amount >= amount, "Market: invalid input");
            require(
                saleDetails.price * amount == msg.value,
                "Market: enter valid ether"
            );

            saleDetails.amount -= amount;
            if (saleDetails.amount == 0) {
                delete _saleList[contractAddress][tokenId][seller];
            }
            IERC1155(contractAddress).safeTransferFrom(
                saleDetails.seller,
                msg.sender,
                saleDetails.tokenId,
                saleDetails.amount,
                ""
            );

            payable(saleDetails.seller).transfer(msg.value);
        } else {
            revert("Market: wrong address");
        }
        emit PurchaseToken(
            seller,
            contractAddress,
            msg.sender,
            tokenId,
            amount
        );
    }

    function placeBid(
        address contractAddress,
        uint256 tokenId,
        address seller
    ) external payable {
        AuctionDetails memory auction = _auctionList[contractAddress][tokenId][
            seller
        ];
        require(auction.seller != msg.sender, "Market: seller not allowed");

        require(
            auction.startTime < block.timestamp &&
                auction.endTime > block.timestamp,
            "Market: Auction not active"
        );
        require(auction.highestBid < msg.value, "Market:bid with more ether");

        _bids[contractAddress][tokenId][seller].push(
            Bid(msg.sender, msg.value)
        );

        auction.highestBid = msg.value;
        auction.highestBidder = msg.sender;

        emit AuctionSuccessful(
            auction.highestBidder,
            tokenId,
            auction.highestBid
        );
    }

    address bidder;
    uint256 bidAmount;

    function cancelBid(
        address contractAddress,
        uint256 tokenId,
        address seller
    ) external {
        require(
            _auctionList[contractAddress][tokenId][seller].endTime >=
                block.timestamp,
            "Market: auction is ended"
        );
        Bid[] memory bidList = _bids[contractAddress][tokenId][seller];
        for (uint256 i = 0; i < bidList.length; i++) {
            if (bidList[i].bidder == msg.sender) {
                uint256 tempBidAmount = bidList[i].bidAmount;
                address tempbidder = bidList[i].bidder;
                if (i == 0) {
                    delete _bids[contractAddress][tokenId][seller][i];
                    payable(tempbidder).transfer(tempBidAmount);
                } else if (i == bidList.length - 1) {
                    _auctionList[contractAddress][tokenId][seller]
                        .highestBid = bidList[i - 1].bidAmount;
                    _auctionList[contractAddress][tokenId][seller]
                        .highestBidder = bidList[i - 1].bidder;
                    delete _bids[contractAddress][tokenId][seller][i];
                    payable(tempbidder).transfer(tempBidAmount);
                } else {
                    delete _bids[contractAddress][tokenId][seller][i];
                    payable(tempbidder).transfer(tempBidAmount);
                }
            }
        }
    }

    function claim(
        address contractAddress,
        uint256 tokenId,
        address seller
    ) external {
        AuctionDetails memory auctionDetails = _auctionList[contractAddress][
            tokenId
        ][seller];

        require(
            auctionDetails.tokenId == tokenId,
            "Market: nft not on auction"
        );
        require(
            auctionDetails.endTime <= block.timestamp,
            "Market: auction not ended"
        );
        require(
            msg.sender == auctionDetails.seller ||
                auctionDetails.highestBidder == msg.sender,
            "Market: you are not allowed"
        );
        _bids[contractAddress][tokenId][seller].pop();
        if (isERC721(contractAddress) || isERC721Mint(contractAddress)) {
            delete _auctionList[contractAddress][tokenId][seller];
            payable(auctionDetails.seller).transfer(auctionDetails.highestBid);
            IERC721(contractAddress).transferFrom(
                auctionDetails.seller,
                auctionDetails.highestBidder,
                auctionDetails.tokenId
            );
        } else if (isERC1155(contractAddress)) {
            delete _auctionList[contractAddress][tokenId][seller];
            payable(auctionDetails.seller).transfer(auctionDetails.highestBid);
            IERC1155(contractAddress).safeTransferFrom(
                auctionDetails.seller,
                auctionDetails.highestBidder,
                tokenId,
                auctionDetails.amount,
                ""
            );
        } else {
            revert("Market: wrong address");
        }
        if (_bids[contractAddress][tokenId][seller].length > 1) {
            withdraw(contractAddress, tokenId, seller);
        }
    }

    function withdraw(
        address contractAddress,
        uint256 tokenId,
        address seller
    ) internal {
        Bid[] memory bidList = _bids[contractAddress][tokenId][seller];

        for (uint256 i = 0; i < bidList.length; i++) {
            uint256 tempBid = bidList[i].bidAmount;
            address tempbidder = bidList[i].bidder;
            delete _bids[contractAddress][tokenId][seller][i];
            payable(tempbidder).transfer(tempBid);
        }
    }

    function cancelAuction(
        address contractAddress,
        uint256 tokenId,
        address seller
    ) external {
        AuctionDetails memory auctiondetails = _auctionList[contractAddress][
            tokenId
        ][seller];
        require(auctiondetails.seller == msg.sender, "Market: only saller");
        require(auctiondetails.tokenId == tokenId, "Market: nft not on sale");
        Bid[] memory bidList = _bids[contractAddress][tokenId][seller];
        if (bidList.length == 0) {
            delete _auctionList[contractAddress][tokenId][seller];
        } else {
            delete _auctionList[contractAddress][tokenId][seller];
            withdraw(contractAddress, tokenId, seller);
        }
    }
}
