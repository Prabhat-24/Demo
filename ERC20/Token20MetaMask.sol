// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address numberOfToken) external view returns (uint256);

    function transfer(
        address receiverAddress,
        uint256 numberOfToken
    ) external returns (bool);

    function approve(address spender, uint256 tokens) external returns (bool);

    function allowance(
        address tokenOwner,
        address spender
    ) external returns (uint256);

    function transferFrom(
        address from,
        address to,
        uint256 tokens
    ) external returns (bool);

    function mint(uint256 numberOfToken) external returns (uint256);

    function burn(uint256 numberOfToken) external returns (uint256);

    event transactionDetails(
        address sender,
        address receiver,
        uint256 numberOfTokens
    );
    event transactionDetailsFrom(address from, address to, uint256 tokens);
    event approveDetails(address spender, uint256 token);
}

contract Token20MetaMask is IERC20 {
    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 private totalTokenSupply;
    address public owner;

    mapping(address => uint256) private tokenBalance;
    //owner,spender
    mapping(address => mapping(address => uint256)) private allow;

    constructor(
        uint256 numberOftoken,
        string memory tName,
        string memory tSymbol,
        uint256 tDecimals
    ) {
        owner = msg.sender;
        totalTokenSupply = mint(numberOftoken);
        name = tName;
        symbol = tSymbol;
        decimals = tDecimals;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Token20MetaMask: only onlyOwner");
        _;
    }

    function totalSupply() external view returns (uint256) {
        return totalTokenSupply;
    }

    function balanceOf(address tokenAccount) external view returns (uint256) {
        require(
            tokenAccount != address(0),
            "Token20MetaMask: zero address not allowed"
        );

        return tokenBalance[tokenAccount];
    }

    function transfer(
        address receiverAddress,
        uint256 numberOfToken
    ) external returns (bool) {
        require(
            receiverAddress != address(0),
            "Token20MetaMask: zero address not allowed"
        );
        require(
            numberOfToken <= tokenBalance[msg.sender],
            "Token20MetaMask: invalid address or insufficient token"
        );
        require(numberOfToken != 0, "Token20MetaMask: zero token");
        tokenBalance[msg.sender] -= numberOfToken;
        tokenBalance[receiverAddress] += numberOfToken;
        emit transactionDetails(msg.sender, receiverAddress, numberOfToken);
        return true;
    }

    function approve(address spender, uint256 tokens) external returns (bool) {
        require(spender != address(0), "Token20MetaMask: zero address not allowed");
        require(tokens > 0, "Token20MetaMask: please enter more than 0 ");
        require(
            tokenBalance[msg.sender] >= tokens,
            "Token20MetaMask: insufficient token"
        );
        allow[msg.sender][spender] += tokens;
        emit approveDetails(spender, tokens);
        return true;
    }

    function allowance(
        address tOwner,
        address tSpender
    ) external view returns (uint256) {
        return allow[tOwner][tSpender];
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokens
    ) external returns (bool) {
        require(
            from != address(0) && to != address(0),
            "Token20MetaMask:zero address not allowed"
        );
        require(from != to, "Token20MetaMask: please enter different address");
        require(tokens > 0, "Token20MetaMask: please send more than one token");
        require(
            allow[from][msg.sender] >= tokens,
            "Token20MetaMask: you are not allowed to send this much token"
        );
        require(
            tokenBalance[from] >= tokens,
            "Token20MetaMask: insufficient token"
        );
        tokenBalance[from] -= tokens;
        tokenBalance[to] += tokens;
        allow[from][msg.sender] -= tokens;
        emit transactionDetailsFrom(from, to, tokens);
        return true;
    }

    function mint(uint256 numberOfToken) public onlyOwner returns (uint256) {
        require(numberOfToken != 0, "Token20MetaMask: please enter more than one");
        totalTokenSupply += numberOfToken;
        tokenBalance[msg.sender] += numberOfToken;
        emit transactionDetailsFrom(address(0), msg.sender, numberOfToken);
        return totalTokenSupply;
    }

    function burn(uint256 numberOfToken) public onlyOwner returns (uint256) {
        require(numberOfToken != 0, "Token20MetaMask: please enter more than one");
        totalTokenSupply -= numberOfToken;
        tokenBalance[msg.sender] -= numberOfToken;
        emit transactionDetailsFrom(msg.sender, address(0), numberOfToken);
        return totalTokenSupply;
    }
}
