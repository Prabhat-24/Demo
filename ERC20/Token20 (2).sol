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

contract Token20 is IERC20 {
    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 totalTokenSupply;
    address allTokenAddress;

    mapping(address => uint256) private tokenBalance;
    //owner,spender
    mapping(address => mapping(address => uint256)) private allow;

    constructor(
        uint256 numberOftoken,
        string memory tName,
        string memory tSymbol,
        uint256 tDecimals
    ) {
        allTokenAddress = msg.sender;
        totalTokenSupply = mint(numberOftoken);
        name = tName;
        symbol = tSymbol;
        decimals = tDecimals;
        tokenBalance[allTokenAddress] = totalTokenSupply;
    }

    modifier onlyDeployer() {
        require(msg.sender == allTokenAddress, "Token20: only deployer");
        _;
    }

    function totalSupply() external view returns (uint256) {
        return totalTokenSupply;
    }

    function balanceOf(address tokenAccount) external view returns (uint256) {
        require(tokenAccount != address(0), "Token: zero is not an address");
        require(tokenBalance[tokenAccount] != 0, "Token: zero token");
        return tokenBalance[tokenAccount];
    }

    function transfer(address receiverAddress, uint256 numberOfToken)
        external
        returns (bool)
    {
        require(receiverAddress != address(0), "Token: zero is not an address");
        require(
            numberOfToken <= tokenBalance[msg.sender] && numberOfToken != 0,
            "Token:wrong input"
        );
        tokenBalance[msg.sender] -= numberOfToken;
        tokenBalance[receiverAddress] += numberOfToken;
        emit transactionDetails(msg.sender, receiverAddress, numberOfToken);
        return true;
    }

    function approve(address spender, uint256 tokens) external returns (bool) {
        require(msg.sender != spender, "Token: only deployer");
        require(spender != address(0), "Token: zero is not an address");
        require(tokens > 0, "Token: please enter more than 0 ");
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
            "Token:zero is not an address"
        );
        require(from != to, "Token: please enter different address");
        require(tokens > 0, "Token: please send more than one token");
        require(
            allow[from][msg.sender] >= tokens,
            "Token: you are not allowed to send this much token"
        );
        require(tokenBalance[from] >= tokens, "Token: insufficient token");
        tokenBalance[from] -= tokens;
        tokenBalance[to] += tokens;
        allow[from][msg.sender] -= tokens;
        emit transactionDetailsFrom(from, to, tokens);
        return true;
    }

    function mint(uint256 numberOfToken) public onlyDeployer returns (uint256) {
        require(numberOfToken != 0, "Token: please enter more than one");
        totalTokenSupply += numberOfToken;
        tokenBalance[allTokenAddress] += numberOfToken;
        emit transactionDetailsFrom(address(0), msg.sender, numberOfToken);
        return totalTokenSupply;
    }

    function burn(uint256 numberOfToken) public onlyDeployer returns (uint256) {
        require(numberOfToken != 0, "Token: please enter more than one");
        totalTokenSupply -= numberOfToken;
        tokenBalance[allTokenAddress] -= numberOfToken;
        emit transactionDetailsFrom(msg.sender, address(0), numberOfToken);
        return totalTokenSupply;
    }
}
