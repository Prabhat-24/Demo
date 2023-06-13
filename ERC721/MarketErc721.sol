// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "NFT/Erc721.sol";
import "ERC/Token20.sol";

contract MarketErc721 {
    struct Sale {
        address owner;
        uint256 tokenId;
        uint256 tokenPrice;
        bool isErc20Token;
        bool status;
    }

    Erc721 erc721;
    ERC20 erc20;

    mapping(uint256 => Sale) private tokenOnSale;

    constructor(Erc721 _erc721, ERC20 _erc20) {
        erc721 = _erc721;
        erc20 = _erc20;
    }

    function onSale(
        uint256 _tokenId,
        uint256 _tokenPrice,
        bool _isErc20Token
    ) public {
        require(_tokenPrice > 0, "MarketErc721:enter more than zero");
        require(_tokenId != 0, "MarketErc721:enter valid _tokenId");
        require(
            !tokenOnSale[_tokenId].status,
            "MarketErc721:token already on Sale"
        );
        require(
            erc721.ownerOf(_tokenId) == msg.sender,
            "MarketErc721: invalid token owner"
        );
        require(
            erc721.getApproved(_tokenId) == address(this) ||
                erc721.isApprovedForAll(
                    erc721.ownerOf(_tokenId),
                    address(this)
                ),
            "MarketErc721: contract not approved"
        );

        tokenOnSale[_tokenId] = Sale(
            msg.sender,
            _tokenId,
            _tokenPrice,
            _isErc20Token,
            true
        );
    }

    function getNftOnSale(uint256 _tokenId) public view returns (Sale memory) {
        return tokenOnSale[_tokenId];
    }

    function purchaseNft(uint256 _tokenId) public payable {
        address nftOwner = erc721.ownerOf(_tokenId);
        require(_tokenId != 0, "MarketErc721:enter more than zero");
        if (erc721.ownerOf(_tokenId) != tokenOnSale[_tokenId].owner) {
            revert("MarketErc721: externally transferred ");
        }
        require(tokenOnSale[_tokenId].status, "MarketErc721:token not on sale");
        require(msg.sender != nftOwner, "MarketErc721:Nft owner not allowed");

        if (tokenOnSale[_tokenId].isErc20Token) {
            require(
                msg.value == (tokenOnSale[_tokenId].tokenPrice),
                "MarketErc721: enter a valid ether"
            );
            erc721.transferFrom(nftOwner, msg.sender, _tokenId);
            payable(nftOwner).transfer(address(this).balance);
            tokenOnSale[_tokenId].status = false;
        } else {
            require(
                erc20.balanceOf(msg.sender) >= tokenOnSale[_tokenId].tokenPrice,
                "MarketErc721: insufficient token"
            );
            erc20.transferFrom(
                msg.sender,
                nftOwner,
                tokenOnSale[_tokenId].tokenPrice
            );
            erc721.transferFrom(nftOwner, msg.sender, _tokenId);
            tokenOnSale[_tokenId].status = false;
        }
    }
}
