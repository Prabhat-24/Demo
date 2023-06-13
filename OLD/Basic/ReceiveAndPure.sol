// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReceiveAndFallback {
    fallback() external payable {}

    receive() external payable {}

    function Output() public view returns (uint256) {
        return address(this).balance;
    }
}
