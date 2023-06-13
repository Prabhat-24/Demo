// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MyERC721 is ERC721 {
    string private _name;
    string private _symbol;
    uint256 public totalTokenId;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) {
        _name = name;
        _symbol = symbol;
    }

    function mint() external {
        totalTokenId++;
        _mint(msg.sender, totalTokenId);
    }

    function burn(uint256 tokenId) external {
        require(ownerOf(tokenId) == msg.sender, "ERC721: invalid owner");
        _burn(tokenId);
    }
}
