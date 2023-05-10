// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Erc1155.sol";

contract Erc1155Market {
    struct NFTMarketItem {
        uint256 tokenId;
        uint256 amount;
        uint256 price;
        address owner;
        bool onSale;
    }
    Erc1155 erc;

    mapping(uint256 => mapping(address => NFTMarketItem)) private _marketItem;

    constructor(Erc1155 _erc) {
        erc = _erc;
    }

    event OnSale(
        address _owner,
        uint256 _tokenId,
        uint256 _price,
        uint256 _amount
    );
    event purchase(
        address _owner,
        address _to,
        uint256 _tokenId,
        uint256 _amount,
        uint256 _price
    );

    function setOnSale(
        uint256 _tokenId,
        uint256 _amount,
        uint256 _price,
        address _owner
    ) external {
        {
            require(_owner == msg.sender, "Erc1155Market: invalid owner");
            require(
                !_marketItem[_tokenId][msg.sender].onSale,
                "Erc1155Market: already on sale"
            );

            require(
                _amount != 0 && _price != 0,
                "Erc1155Market: enter more than zero"
            );

            require(
                erc.balanceOf(msg.sender, _tokenId) >= _amount,
                "Erc1155Market: invalid amount"
            );

            _marketItem[_tokenId][msg.sender] = NFTMarketItem(
                _tokenId,
                _amount,
                _price,
                _owner,
                true
            );
        }
        emit OnSale(_owner, _tokenId, _price, _amount);
    }

    function onSale(uint256 _tokenId, address _idOwner)
        external
        view
        returns (NFTMarketItem memory)
    {
        return _marketItem[_tokenId][_idOwner];
    }

    function purchaseToken(
        address _to,
        uint256 _amount,
        uint256 _tokenId,
        address _idOwner
    ) external payable {
        require(
            _marketItem[_tokenId][_idOwner].onSale,
            "Erc1155Market: not on sale"
        );
        require(
            erc.isApprovedForAll(_idOwner, address(this)),
            "Erc1155Market: give approval "
        );
        require(
            _to != address(0) && _idOwner != address(0),
            "Erc1155Market: zero address"
        );
        require(
            _amount != 0 && _marketItem[_tokenId][_idOwner].amount >= _amount,
            "Erc1155Market:enter a valid input "
        );

        require(
            _marketItem[_tokenId][_idOwner].price * _amount == msg.value,
            "Erc1155Market: enter valid ether"
        );

        erc.safeTransferFrom(_idOwner, _to, _tokenId, _amount, "");
        payable(_idOwner).transfer(msg.value);

        _marketItem[_tokenId][_idOwner].amount -= _amount;
        if (_marketItem[_tokenId][_idOwner].amount == 0) {
            _marketItem[_tokenId][_idOwner].onSale = false;
        }
        emit purchase(_idOwner, _to, _tokenId, _amount, msg.value);
    }
}
