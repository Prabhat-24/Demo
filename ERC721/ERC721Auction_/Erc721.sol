// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function balanceOf(address _owner) external view returns (uint256);

    function ownerOf(uint256 _tokenId) external view returns (address);

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

    event Transfer(address _from, address _to, uint256 _tokenId);
    event Approval(address _owner, address _approved, uint256 _tokenId);
    event ApprovalForAll(address _owner, address _operator, bool _approved);
}

contract Erc721 is IERC721 {
    string public name;
    string public symbol;
    address public admin;
    uint256 private count;

    mapping(address => uint256) private balance;
    mapping(uint256 => address) private owner;
    mapping(uint256 => address) private allow;
    mapping(uint256 => bool) private exists;
    mapping(address => mapping(address => bool)) private allowAll;

    constructor(string memory _tokenName, string memory _symbol) {
        require(
            bytes(_tokenName).length != 0 && bytes(_symbol).length != 0,
            "Erc721Token:fill all input fields"
        );

        name = _tokenName;
        symbol = _symbol;
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Erc721Token: Only Admin Allowed");
        _;
    }

    function mintToken(address _to) external onlyAdmin {
        require(
            _to != address(0),
            "Erc721Token: zero address not allowed in from"
        );
        require(
            _to.code.length == 0,
            "Erc721Token:this is a contract address "
        );
        ++count;
        owner[count] = _to;
        balance[_to]++;
        exists[count] = true;

        emit Transfer(address(0), _to, count);
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return balance[_owner];
    }

    function ownerOf(uint256 _tokenId) public view returns (address) {
        return owner[_tokenId];
    }

    function _transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) private {
        balance[_from]--;
        owner[_tokenId] = _to;
        balance[_to]++;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external {
        require(
            _from != address(0),
            "Erc721Token: zero address not allowed in from"
        );
        require(
            _to != address(0),
            "Erc721Token: zero address not allowed in to"
        );

        require(
            _from == msg.sender ||
                getApproved(_tokenId) == msg.sender ||
                allowAll[_from][msg.sender],
            "Erc721Token: you are not allowed"
        );
        _transferFrom(_from, _to, _tokenId);
        emit Transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) external {
        require(
            _approved != address(0),
            "Erc721Token:zero address not allowed"
        );
        require(_tokenId != 0, "Erc721Token: enter a valid tokenId");
        require(
            ownerOf(_tokenId) == msg.sender,
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

    function getApproved(uint256 _tokenId) public view returns (address) {
        return allow[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator)
        external
        view
        returns (bool)
    {
        return allowAll[_owner][_operator];
    }

    function burn(uint256 _tokenId) external {
        require(exists[_tokenId], "Erc721Token:token not available");
        require(
            owner[_tokenId] == msg.sender,
            "Erc721Token: you are not tokenOwner"
        );
        owner[_tokenId] = address(0);

        _transferFrom(msg.sender, address(0), _tokenId);
        emit Transfer(msg.sender, address(0), _tokenId);
    }
}
