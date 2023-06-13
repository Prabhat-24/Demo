// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransferOwnerShip {
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    function ownerOfContract() external view returns (address) {
        return owner;
    }

    function transferOwnership(address newOwner) external {
        require(newOwner != address(0), "TransferOwnerShip: zero address");
        require(owner == msg.sender, "TransferOwnerShip: only owner");
        owner = newOwner;
    }
}
