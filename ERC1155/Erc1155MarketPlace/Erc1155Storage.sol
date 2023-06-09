// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "NFT/OLD/String.sol";

contract Erc1155Storage {
    string internal baseURI;
    mapping(uint256 => string) private _tokenUri;

    function setBaseURI(string memory _baseURI) internal {
        baseURI = _baseURI;
    }

    function setTokenURI(uint256 _numberOfId) internal {
        _tokenUri[_numberOfId] = string.concat(
            baseURI,
            Strings.toString(_numberOfId),
            ".json"
        );
    }

    function tokenURI(uint256 _id) internal view returns (string memory) {
        return _tokenUri[_id];
    }
}
