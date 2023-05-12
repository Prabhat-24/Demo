// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./IStore.sol";
import "./IERC165.sol";

contract Store is IStore, IERC165 {
    uint256 internal value;

    function setValue(uint256 number) external {
        value = number;
    }

    function getValue() external view returns (uint256) {
        return value;
    }

    function supportsInterface(bytes4 interfaceId)
        external
        pure
        returns (bool)
    {
        return (interfaceId == type(IERC165).interfaceId ||
            interfaceId == this.getValue.selector);
    }
}
