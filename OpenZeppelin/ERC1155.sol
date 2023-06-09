// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract MyERC1155Token is ERC1155 {
    string private _uri;

    constructor(string memory uri) ERC1155(uri) {
        _uri = uri;
    }

    function mint(
        uint256 tokenId,
        uint256 amount,
      
    ) external payable {
        require(amount != 0, "MyERC1155Token: zero amount");

        _mint(msg.sender, tokenId, amount, data);
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

        _mintBatch(msg.sender, tokenIds, amounts, data);
        payable(owner).transfer(msg.value);
    }

    function burn(uint256 tokenId, uint256 amount) external {
        require(amount != 0, "MyERC1155Token: zero amount");
        _burn(msg.sender, tokenId, amount);
    }

    function burnBatch(
        uint256[] memory tokenIds,
        uint256[] memory amounts
    ) external {
        _burnBatch(msg.sender, tokenIds, amounts);
    }
}
