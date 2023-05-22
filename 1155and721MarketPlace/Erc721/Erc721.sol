// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./IERC721Receiver.sol";
import "./Erc721Storage.sol";
import "./IERC721.sol";

contract Erc721 is IERC721, IERC721Receiver, ERC721URIStorage {
    string public name;
    string public symbol;
    address public admin;

    mapping(address => uint256) private balance;
    mapping(uint256 => address) private owner;
    mapping(uint256 => address) private allow;
    mapping(uint256 => bool) private exists;
    mapping(address => mapping(address => bool)) private allowAll;

    constructor(
        string memory _tokenName,
        string memory _symbol,
        string memory _baseURI
    ) {
        require(
            bytes(_tokenName).length != 0 &&
                bytes(_symbol).length != 0 &&
                bytes(_baseURI).length != 0,
            "Erc721Token:fill all input fields"
        );

        name = _tokenName;
        symbol = _symbol;
        admin = msg.sender;
        setBaseURI(_baseURI);
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Erc721Token: Only Admin Allowed");
        _;
    }

    function mintToken(address _to, uint256 _tokenId) external {
        require(
            _to != address(0),
            "Erc721Token: zero address not allowed in from"
        );
        require(
            _to.code.length == 0,
            "Erc721Token:don't mint in contract address "
        );

        require(!exists[_tokenId], "Erc721Token: already exists");

        owner[_tokenId] = _to;
        balance[_to] += 1;
        exists[_tokenId] = true;
        _createTokenURI(_tokenId);

        emit Transfer(address(0), _to, _tokenId);
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return balance[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return owner[_tokenId];
    }

    //to.code.length the compiled bytecode of the recipient address
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory data
    ) public {
        transferFrom(_from, _to, _tokenId);

        require(
            _to.code.length == 0 ||
                IERC721Receiver(_to).onERC721Received(
                    msg.sender,
                    _from,
                    _tokenId,
                    data
                ) ==
                IERC721Receiver.onERC721Received.selector,
            "unsafe recipient"
        );
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public {
        safeTransferFrom(_from, _to, _tokenId, "");
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        require(
            _from != address(0),
            "Erc721Token: zero address not allowed in from"
        );
        require(
            _to != address(0),
            "Erc721Token: zero address not allowed in to"
        );
        require(
            msg.sender == _from ||
                msg.sender == allow[_tokenId] ||
                allowAll[_from][msg.sender],
            "Erc721Token: you are not allowed"
        );

        balance[_from] -= 1;
        owner[_tokenId] = _to;
        balance[_to] += 1;

        emit Transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external {
        require(
            _approved != address(0),
            "Erc721Token:zero address not allowed"
        );
        require(_tokenId != 0, "Erc721Token: enter a valid tokenId");
        require(
            owner[_tokenId] == msg.sender,
            "Erc721Token: you are not token owner"
        );
        allow[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        require(
            _operator != address(0),
            "Erc721Token:zero address not allowed"
        );
        allowAll[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) external view returns (address) {
        return allow[_tokenId];
    }

    function isApprovedForAll(
        address _owner,
        address _operator
    ) external view returns (bool) {
        return allowAll[_owner][_operator];
    }

    function burn(uint256 _tokenId) public {
        require(_tokenId != 0, "Erc721Token: enter a valid tokenId");
        require(exists[_tokenId], "Erc721Token:token not available");
        require(
            owner[_tokenId] == msg.sender,
            "Erc721Token: you are not tokenOwner"
        );
        owner[_tokenId] = address(0);
        balance[msg.sender] -= 1;
        transferFrom(msg.sender, address(0), _tokenId);
        emit Transfer(msg.sender, address(0), _tokenId);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) public pure returns (bytes4) {
        return
            bytes4(
                keccak256("onERC721Received(address,address,uint256,bytes)")
            );
    }

    function supportsInterface(
        bytes4 interfaceId
    ) external pure returns (bool) {
        return interfaceId == type(IERC721).interfaceId;
    }
}
