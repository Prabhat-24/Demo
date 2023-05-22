// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "../Erc721/IERC721.sol";

interface NewIERC721 is IERC721{
    function mintToken(address _to, uint256 _tokenId) external;
}
