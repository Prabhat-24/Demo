// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyERC20token is ERC20 {
    string private _name;
    string private _symbol;
    uint256 internal _mintingPrice;

    constructor(
        string memory name,
        string memory symbol,
        uint256 mintingPrice
    ) ERC20(name, symbol) {
        _name = name;
        _symbol = symbol;
        _mintingPrice = mintingPrice;
    }

    function mint(uint256 amount) external payable {
        require(amount != 0, "MyERC20token: zero amount");
        require(
            msg.value == ((amount * _mintingPrice) / 10**decimals()),
            "MyERC20token: pay correct ether"
        );

        _mint(msg.sender, amount);
    }

    function burn(uint256 amount) external {
        require(amount != 0, "Mytoken: zero amount");
        _burn(msg.sender, amount);
        payable(msg.sender).transfer((amount * _mintingPrice) / 10**decimals());
    }
}
