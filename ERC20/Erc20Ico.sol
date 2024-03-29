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

    function purchesToken(uint256 numberOfToken) external payable;

    function contractTokenBalance() external returns (uint256);

    function contractBalance() external view returns (uint256);

    function transferEther() external returns (bool);

    function changePrice(uint256 price) external returns (uint256);

    function tokenOnSale() external returns (uint256);

    event transactionDetails(
        address sender,
        address receiver,
        uint256 numberOfTokens
    );
    event transactionDetailsFrom(address from, address to, uint256 tokens);
    event approveDetails(address spender, uint256 token);
    event purchesDetails(address buyer, uint256 numberOfToken);
}

contract Erc20Ico is IERC20 {
    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 private totalTokenSupply;
    uint256 public maximumSupply;
    uint256 public tokenPrice;
    address private owner;
    uint256 private startTime;
    uint256 private saleTime;
    uint256 public tokenOnSale;

    mapping(address => uint256) private tokenBalance;
    //owner,spender
    mapping(address => mapping(address => uint256)) private allow;

    constructor(
        uint256 tMaxSupply,
        uint256 numOftoken,
        uint256 tTokenPrice,
        string memory tName,
        string memory tSymbol,
        uint256 tDecimals,
        uint256 tSaleTime,
        uint256 tTokenForSale
    ) {
        require(tMaxSupply != 0, "Erc20Update: zero not allowed");
        owner = msg.sender;
        maximumSupply = tMaxSupply;
        mint(numOftoken);
        changePrice(tTokenPrice);
        name = tName;
        symbol = tSymbol;
        decimals = tDecimals;
        tokenBalance[address(this)] = totalTokenSupply;
        startTime = block.timestamp;
        saleTime = tSaleTime;
        tokenOnSale = tTokenForSale;
        require(
            tTokenForSale < numOftoken,
            "Erc20Update:all token not available for sale "
        );
        tokenOnSale = tTokenForSale;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Erc20Update: only onlyOwner");
        _;
    }

    function totalSupply() external view returns (uint256) {
        return totalTokenSupply;
    }

    function balanceOf(address tokenAccount) external view returns (uint256) {
        require(
            tokenAccount != address(0),
            "Erc20Update: zero address not allowed"
        );

        return tokenBalance[tokenAccount];
    }

    function transfer(address receiverAddress, uint256 numberOfToken)
        external
        returns (bool)
    {
        require(
            receiverAddress != address(0),
            "Erc20Update: zero address not allowed"
        );
        require(numberOfToken != 0, "Erc20Update: zero token");

        require(
            numberOfToken <= tokenBalance[msg.sender],
            "Erc20Update: invalid address or insufficient token"
        );

        tokenBalance[msg.sender] -= numberOfToken;
        tokenBalance[receiverAddress] += numberOfToken;
        emit transactionDetails(msg.sender, receiverAddress, numberOfToken);
        return true;
    }

    function approve(address spender, uint256 tokens) external returns (bool) {
        require(spender != address(0), "Erc20Update: zero address not allowed");
        require(tokens > 0, "Erc20Update: please enter more than 0 ");
        require(
            tokenBalance[msg.sender] >= tokens,
            "Erc20Update: insufficient token"
        );

        allow[msg.sender][spender] += tokens;
        emit approveDetails(spender, tokens);
        return true;
    }

    function allowance(address tOwner, address tSpender)
        external
        view
        returns (uint256)
    {
        return allow[tOwner][tSpender];
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokens
    ) external returns (bool) {
        require(
            from != address(0) && to != address(0),
            "Erc20Update:zero address not allowed"
        );
        require(from != to, "Erc20Update: please enter different address");
        require(tokens > 0, "Erc20Update: please send more than one token");
        require(
            allow[from][msg.sender] >= tokens,
            "Erc20Update: you are not allowed to send this much token"
        );
        require(
            tokenBalance[from] >= tokens,
            "Erc20Update: insufficient token"
        );

        tokenBalance[from] -= tokens;
        tokenBalance[to] += tokens;
        allow[from][msg.sender] -= tokens;
        emit transactionDetailsFrom(from, to, tokens);
        return true;
    }

    function mint(uint256 numberOfToken) public onlyOwner returns (uint256) {
        require(numberOfToken != 0, "Erc20Update: please enter more than one");
        require(
            maximumSupply >= totalTokenSupply + numberOfToken,
            "Erc20Update:maximum mint limit!! "
        );

        totalTokenSupply += numberOfToken;
        tokenBalance[address(this)] += numberOfToken;

        emit transactionDetailsFrom(address(0), msg.sender, numberOfToken);
        return totalTokenSupply;
    }

    function burn(uint256 numberOfToken) public onlyOwner returns (uint256) {
        require(numberOfToken != 0, "Erc20Update: please enter more than one");

        totalTokenSupply -= numberOfToken;
        tokenBalance[address(this)] -= numberOfToken;

        emit transactionDetailsFrom(msg.sender, address(0), numberOfToken);
        return totalTokenSupply;
    }

    function purchesToken(uint256 numberOfToken) external payable {
        require(numberOfToken != 0, "Erc20Update: please give valid number");
        require(msg.value != 0, "Erc20Update: please give valid ether");
        // require(
        //     msg.value == (tokenPrice * numberOfToken) / 10**decimals,
        //     "Erc20Update: please give valid input"
        // );
        if (block.timestamp < startTime + saleTime) {
            require(
                msg.sender != owner,
                "Erc20Update:owner not allowed to buy"
            );
            if (tokenOnSale > 0) {
                require(
                    tokenOnSale >= numberOfToken,
                    "Erc20Update: invalid input of token"
                );
                tokenOnSale -= numberOfToken;
                require(
                    msg.value ==
                        ((numberOfToken * (tokenPrice)) / 2) / 10**decimals,
                    "Erc20Update: enter half price"
                );
                payable(owner).transfer(address(this).balance);
            } else {
                revert("Erc20Update: offer token sold out");
            }
        } else {
            require(
                msg.value == (tokenPrice * numberOfToken) / 10**decimals,
                "Erc20Update: enter full price"
            );
        }

        tokenBalance[address(this)] -= numberOfToken;
        tokenBalance[msg.sender] += numberOfToken;
        emit purchesDetails(msg.sender, numberOfToken);
    }

    function contractTokenBalance() external view onlyOwner returns (uint256) {
        return tokenBalance[address(this)];
    }

    function contractBalance() external view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    function transferEther() external returns (bool) {
        payable(owner).transfer(address(this).balance);
        return true;
    }

    function changePrice(uint256 price) public onlyOwner returns (uint256) {
        if (block.timestamp < startTime + saleTime) {
            revert("Erc20Update: price changing not allowed during sale");
        }

        require(price != 0, "Erc20Update: please enter more than zero");

        tokenPrice = price;
        return tokenPrice;
    }
}
