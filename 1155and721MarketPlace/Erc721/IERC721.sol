// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./IERC165.sol";

interface IERC721 is IERC165 {
    function balanceOf(address _owner) external view returns (uint256);

    function ownerOf(uint256 _tokenId) external view returns (address);

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory data
    ) external;

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external;

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external;

    function approve(address _approved, uint256 _tokenId) external;

    function setApprovalForAll(address _operator, bool _approved) external;

    function getApproved(uint256 _tokenId) external view returns (address);

    function isApprovedForAll(address _owner, address _operator)
        external
        view
        returns (bool);

    function supportsInterface(bytes4 _interfaceID)
        external
        view
        returns (bool);

    event Transfer(address _from, address _to, uint256 _tokenId);
    event Approval(address _owner, address _approved, uint256 _tokenId);
    event ApprovalForAll(address _owner, address _operator, bool _approved);
}
