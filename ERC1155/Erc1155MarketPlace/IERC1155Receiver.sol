// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC1155Receiver {
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) external pure returns (bytes4);
}
