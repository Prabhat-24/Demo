// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../Erc1155/IERC1155.sol";

interface NewIERC1155 is IERC1155 {
    function mint(
        address _to,
        uint256 _id,
        uint256 _amount
    ) external;
}
