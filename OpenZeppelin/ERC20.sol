// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyERC20token is ERC20 {
    string private _name;
    string private _symbol;
 

    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _name = name;
        _symbol = symbol;
    }

    function mint(uint256 amount) external  {
        require(amount != 0, "MyERC20token: zero amount");

        _mint(msg.sender, amount);
    }

    function burn(uint256 amount) external {
        require(amount != 0, "Mytoken: zero amount");
        _burn(msg.sender, amount);
    }
}
