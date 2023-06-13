// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyERC721Token is ERC721 {
    string private _name;
    string private _symbol;
    uint256 private _mintingPrice;
    address owner;

    constructor(
        string memory name,
        string memory symbol,
        uint256 mintingPrice
    ) ERC721(_name, _symbol) {
        _name = name;
        _symbol = symbol;
        _mintingPrice = mintingPrice;
        owner = msg.sender;
    }

    function mint(uint256 tokenId) external payable {
        require(msg.value == _mintingPrice, "MyERC721Token: pay correct ether");
        payable(owner).transfer(msg.value);
        _mint(msg.sender, tokenId);
    }

    function burn(uint256 tokenId) external {
        _burn(tokenId);
    }

    function changeMintingPrice(uint256 Price) external {
        _mintingPrice = Price;
    }
}
