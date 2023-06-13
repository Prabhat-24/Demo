// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract MyERC1155Token is ERC1155 {
    string private _uri;
    uint256 private _mintingPrice;
    address owner;

    constructor(string memory uri, uint256 mintingPrice) ERC1155(uri) {
        _uri = uri;
        _mintingPrice = mintingPrice;
        owner = msg.sender;
    }

    function mint(
        uint256 tokenId,
        uint256 amount,
        bytes memory data
    ) external payable {
        require(amount != 0, "MyERC1155Token: zero amount");
        require(
            msg.value == _mintingPrice * amount,
            "MyERC1155Token: pay correct ether"
        );

        _mint(msg.sender, tokenId, amount, data);
        payable(owner).transfer(msg.value);
    }

    function mintBatch(
        uint256[] memory tokenIds,
        uint256[] memory amounts,
        bytes memory data
    ) external payable {
        uint256 tempAmount;
        for (uint256 i; i < amounts.length; i++) {
            tempAmount += amounts[i];
        }
        require(
            msg.value == _mintingPrice * tempAmount,
            "MyERC1155Token: enter correct ether"
        );
        _mintBatch(msg.sender, tokenIds, amounts, data);
        payable(owner).transfer(msg.value);
    }

    function burn(uint256 tokenId, uint256 amount) external {
        require(amount != 0, "MyERC1155Token: zero amount");
        _burn(msg.sender, tokenId, amount);
    }

    function burnBatch(uint256[] memory tokenIds, uint256[] memory amounts)
        external
    {
        _burnBatch(msg.sender, tokenIds, amounts);
    }

    function changeMintingPrice(uint256 Price) external {
        _mintingPrice = Price;
    }
}
