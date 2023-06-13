// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "NFT/OLD/String.sol";

contract ERC721URIStorage {
    string internal baseURI;
    mapping(uint256 => string) internal _tokenURI;
    event URI(uint256 id, string tokenURI);

    function setBaseURI(string memory _baseURI) internal {
        baseURI = _baseURI;
    }

    function _createTokenURI(uint256 id) internal {
        _tokenURI[id] = string.concat(baseURI, Strings.toString(id), ".json");
        emit URI(id, _tokenURI[id]);
    }

    function tokenURI(uint256 _tokenId) public view returns (string memory) {
        return _tokenURI[_tokenId];
    }

    function _deleteTokenURI(uint256 id) internal {
        delete _tokenURI[id];
    }
}
