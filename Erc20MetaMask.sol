// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address _address) external view returns (uint256);

    function transfer(address _receiverAddress, uint256 _numberOfToken)
        external
        returns (bool);

    function approve(address _spender, uint256 _tokens) external returns (bool);

    function allowance(address _owner, address _spender)
        external
        returns (uint256);

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokens
    ) external returns (bool);

    function mint(uint256 _numberOfToken) external returns (uint256);

    function burn(uint256 _numberOfToken) external returns (uint256);

    function purchesToken(uint256 _numberOfToken) external payable;

    function contractTokenBalance() external returns (uint256);

    function contractBalance() external view returns (uint256);

    function transferEther() external returns (bool);

    function changePrice(uint256 _price) external returns (uint256);

    event transactionDetails(
        address _sender,
        address _receiver,
        uint256 _numberOfTokens
    );
    event transactionDetailsFrom(address _from, address _to, uint256 _tokens);
    event approveDetails(address _spender, uint256 _token);
    event purchesDetails(address _buyer, uint256 _numberOfToken);
}

contract Erc20MetaMask is IERC20 {
    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 private totalTokenSupply;
    uint256 public maximumSupply;
    uint256 public tokenPrice;
    address owner;

    mapping(address => uint256) private tokenBalance;
    //owner,spender
    mapping(address => mapping(address => uint256)) private allow;

    constructor(
        uint256 _maxSupply,
        uint256 _numOftoken,
        string memory _name,
        string memory _symbol,
        uint256 _decimals,
        uint256 _tokenPrice
    ) {
        owner = msg.sender;
        maximumSupply = _maxSupply;
        totalTokenSupply = mint(_numOftoken);
        tokenPrice = changePrice(_tokenPrice);
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        tokenBalance[address(this)] = totalTokenSupply;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Erc20Update: only onlyOwner");
        _;
    }

    function totalSupply() external view returns (uint256) {
        return totalTokenSupply;
    }

    function balanceOf(address _address) external view returns (uint256) {
        require(
            _address != address(0),
            "Erc20Update: zero address not allowed"
        );

        return tokenBalance[_address];
    }

    function transfer(address _receiverAddress, uint256 _numberOfToken)
        external
        returns (bool)
    {
        require(
            _receiverAddress != address(0),
            "Erc20Update: zero address not allowed"
        );
        require(_numberOfToken != 0, "Erc20Update: zero token");

        require(
            _numberOfToken <= tokenBalance[msg.sender],
            "Erc20Update: invalid address or insufficient token"
        );
        tokenBalance[msg.sender] -= _numberOfToken;
        tokenBalance[_receiverAddress] += _numberOfToken;
        emit transactionDetails(msg.sender, _receiverAddress, _numberOfToken);
        return true;
    }

    function approve(address _spender, uint256 _tokens)
        external
        onlyOwner
        returns (bool)
    {
        require(
            _spender != address(0),
            "Erc20Update: zero address not allowed"
        );
        require(_tokens > 0, "Erc20Update: please enter more than 0 ");
        require(
            tokenBalance[msg.sender] >= _tokens,
            "Erc20Update: insufficient token"
        );
        allow[msg.sender][_spender] += _tokens;
        emit approveDetails(_spender, _tokens);
        return true;
    }

    function allowance(address _Owner, address _Spender)
        external
        view
        returns (uint256)
    {
        return allow[_Owner][_Spender];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokens
    ) external returns (bool) {
        require(
            _from != address(0) && _to != address(0),
            "Erc20Update:zero address not allowed"
        );
        require(_from != _to, "Erc20Update: please enter different address");
        require(_tokens > 0, "Erc20Update: please send more than one token");
        require(
            allow[_from][msg.sender] >= _tokens,
            "Erc20Update: you are not allowed to send this much token"
        );
        require(
            tokenBalance[_from] >= _tokens,
            "Erc20Update: insufficient token"
        );

        tokenBalance[_from] -= _tokens;
        tokenBalance[_to] += _tokens;
        allow[_from][msg.sender] -= _tokens;
        emit transactionDetailsFrom(_from, _to, _tokens);
        return true;
    }

    function mint(uint256 _numberOfToken) public onlyOwner returns (uint256) {
        require(_numberOfToken != 0, "Erc20Update: please enter more than one");
        require(
            maximumSupply >= totalTokenSupply + _numberOfToken,
            "Erc20Update:maximum mint limit!! "
        );

        totalTokenSupply += _numberOfToken;
        tokenBalance[address(this)] += _numberOfToken;

        emit transactionDetailsFrom(address(0), msg.sender, _numberOfToken);
        return totalTokenSupply;
    }

    function burn(uint256 _numberOfToken) public onlyOwner returns (uint256) {
        require(_numberOfToken != 0, "Erc20Update: please enter more than one");

        totalTokenSupply -= _numberOfToken;
        tokenBalance[address(this)] -= _numberOfToken;

        emit transactionDetailsFrom(msg.sender, address(0), _numberOfToken);
        return totalTokenSupply;
    }

    function purchesToken(uint256 _numberOfToken) external payable {
        require(_numberOfToken != 0, "Erc20Update: please give valid number");
        require(msg.value != 0, "Erc20Update: please give valid ether");
        require(
            msg.value == (tokenPrice * _numberOfToken) / 10**decimals,
            "Erc20Update: please give valid input"
        );

        tokenBalance[address(this)] -= _numberOfToken;
        tokenBalance[msg.sender] += _numberOfToken;
        emit purchesDetails(msg.sender, _numberOfToken);
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
        require(price != 0, "Erc20Update: please enter more than one");
        tokenPrice = price;
        return tokenPrice;
    }
    //0xCb18F35230B60453c9f87A03F1df0aF0Ca975241
}
