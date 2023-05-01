// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721 {
    function balanceOf(address _owner) external view returns (uint256);

    function ownerOf(uint256 _tokenId) external view returns (address);

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory data
    ) external payable;

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable;

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable;

    function approve(address _approved, uint256 _tokenId) external payable;

    function setApprovalForAll(address _operator, bool _approved) external;

    function getApproved(uint256 _tokenId) external view returns (address);

    function isApprovedForAll(address _owner, address _operator)
        external
        view
        returns (bool);

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 indexed _tokenId
    );
    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 indexed _tokenId
    );
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );

    function mintToken(address _buyer, uint256 _tokenId) external;
}

contract Erc721Token is IERC721 {
    string public tokenName;
    string public symbol;
    address public admin;

    mapping(address => uint256) private balance;
    mapping(uint256 => address) private owner;
    mapping(uint256 => address) private allow;
    mapping(address => mapping(address => bool)) private allowAll;

    constructor(string memory _tokenName, string memory _symbol) {
        tokenName = _tokenName;
        symbol = _symbol;
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Erc721Token: Only Admin Allowed");
        _;
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return balance[_owner];
        //mint, transfer
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return owner[_tokenId];
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory data
    ) external payable {
        require(
            _from != address(0),
            "Erc721Token: zero address not allowed in from"
        );
        require(
            _to != address(0),
            "Erc721Token: zero address not allowed in to"
        );
        emit Transfer(_from, _to, _tokenId);
    }

    //Safely transfers tokenId token from from to to, checking first that contract
    //recipients are aware of the ERC721 protocol to prevent tokens from being forever locked.
    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) public payable {
        require(
            _from != address(0),
            "Erc721Token: zero address not allowed in from"
        );
        require(
            _to != address(0),
            "Erc721Token: zero address not allowed in to"
        );
        if (msg.sender == _from) {
            delete owner[_tokenId];
            balance[_from] -= 1;
            owner[_tokenId] = _to;
            balance[_to] += 1;
        } else if (allow[_tokenId] == msg.sender) {
            require(
                allow[_tokenId] == _from,
                "Erc721Token: you are not allowed"
            );
            delete owner[_tokenId];
            balance[_from] -= 1;
            owner[_tokenId] = _to;
            balance[_to] += 1;
        }

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        require(
            _from != address(0),
            "Erc721Token: zero address not allowed in from"
        );
        require(
            _to != address(0),
            "Erc721Token: zero address not allowed in to"
        );

        emit Transfer(_from, _to, _tokenId);
    }

    // why payable
    function approve(address _approved, uint256 _tokenId) external payable {
        allow[_tokenId] = _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        allowAll[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) external view returns (address) {
        return allow[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator)
        external
        view
        returns (bool)
    {
        return allowAll[_owner][_operator];
    }

    function mintToken(address _buyer, uint256 _tokenId) public onlyAdmin {
        require(
            _buyer != address(0),
            "Erc721Token: zero address not allowed in from"
        );
        require(owner[_tokenId] == address(0), "Erc721Token: not available");
        owner[_tokenId] = _buyer;
        balance[_buyer] += 1;
    }
}
