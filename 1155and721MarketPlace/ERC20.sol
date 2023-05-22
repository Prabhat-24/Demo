// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address numberOfToken) external view returns (uint256);

    function transfer(address receiverAddress, uint256 numberOfToken)
        external
        returns (bool);

    function approve(address spender, uint256 tokens) external returns (bool);

    function allowance(address tokenOwner, address spender)
        external
        returns (uint256);

    function transferFrom(
        address from,
        address to,
        uint256 tokens
    ) external returns (bool);

    event transactionDetails(
        address sender,
        address receiver,
        uint256 numberOfTokens
    );
    event transactionDetailsFrom(address from, address to, uint256 tokens);
    event approveDetails(address spender, uint256 token);
}

contract ERC20 is IERC20 {
    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 totalTokenSupply;
    address admin;

    mapping(address => uint256) private tokenBalance;
    //owner,spender
    mapping(address => mapping(address => uint256)) private allow;

    constructor(
        string memory tName,
        string memory tSymbol,
        uint256 tDecimals,
        uint256 numberOftoken,
        address to
    ) {
        admin = msg.sender;
        totalTokenSupply = mint(numberOftoken, to);
        name = tName;
        symbol = tSymbol;
        decimals = tDecimals;
        tokenBalance[admin] = totalTokenSupply;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Token20: only admin");
        _;
    }

    function totalSupply() external view returns (uint256) {
        return totalTokenSupply;
    }

    function balanceOf(address tokenAccount) external view returns (uint256) {
        return tokenBalance[tokenAccount];
    }

    function transfer(address receiverAddress, uint256 numberOfToken)
        external
        returns (bool)
    {
        require(
            receiverAddress != address(0),
            "Token: zero address not allowed"
        );
        require(
            numberOfToken <= tokenBalance[msg.sender] && numberOfToken != 0,
            "Token:insufficient token"
        );
        require(numberOfToken != 0, "Token:enter a valid tokenId");
        _transfer(receiverAddress, numberOfToken);
        return true;
    }

    function _transfer(address receiverAddress, uint256 numberOfToken) private {
        tokenBalance[msg.sender] -= numberOfToken;
        tokenBalance[receiverAddress] += numberOfToken;
        emit transactionDetails(msg.sender, receiverAddress, numberOfToken);
    }

    function approve(address spender, uint256 tokens) external returns (bool) {
        require(spender != address(0), "Token: zero address not allowed");

        require(
            tokenBalance[msg.sender] >= tokens,
            "Token: insufficient token"
        );
        allow[msg.sender][spender] += tokens;
        emit approveDetails(spender, tokens);
        return true;
    }

    function allowance(address owner, address spender)
        external
        view
        returns (uint256)
    {
        return allow[owner][spender];
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokens
    ) external returns (bool) {
        require(
            from != address(0) && to != address(0),
            "Token:zero address not allowed"
        );
        require(from != to, "Token: please enter different address");
        require(tokens > 0, "Token: please send more than one token");
        require(
            allow[from][msg.sender] >= tokens,
            "Token: insufficient allowance"
        );
        require(tokenBalance[from] >= tokens, "Token: insufficient token");
        tokenBalance[from] -= tokens;
        tokenBalance[to] += tokens;
        allow[from][msg.sender] -= tokens;
        emit transactionDetailsFrom(from, to, tokens);
        return true;
    }

    function mint(uint256 numberOfToken, address to)
        public
        onlyAdmin
        returns (uint256)
    {
        require(numberOfToken != 0, "Token: please enter more than one");

        _mint(numberOfToken, to);
        emit transactionDetailsFrom(address(0), msg.sender, numberOfToken);
        return totalTokenSupply;
    }

    function _mint(uint256 numberOfToken, address to) private {
        totalTokenSupply += numberOfToken;
        tokenBalance[to] += numberOfToken;
    }

    function burn(uint256 numberOfToken) external onlyAdmin returns (uint256) {
        require(numberOfToken != 0, "Token: please enter more than one");
        totalTokenSupply -= numberOfToken;
        _transfer(address(0), numberOfToken);
        emit transactionDetailsFrom(msg.sender, address(0), numberOfToken);
        return totalTokenSupply;
    }
}
