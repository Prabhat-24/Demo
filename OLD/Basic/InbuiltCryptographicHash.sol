// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Hash {
    function hashKeccak256(string memory message, address receiverAddress) public view returns(bytes32) {
        return keccak256(abi.encodePacked(msg.sender, message, receiverAddress));
    }
}
// 0x929336a17aF293b16d025170e310d7C408C5447e
//sha256
//ripemd160