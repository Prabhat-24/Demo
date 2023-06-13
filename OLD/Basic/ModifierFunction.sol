// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ModifierFunction {
    address public owner = msg.sender;
   

    modifier onlyOwner() {
        require(owner == msg.sender, "not owner");
        _;
    }

    function startAuction() public view onlyOwner returns(string memory s) {
        s = "start";
    }

    function stopAuction() public view onlyOwner returns(string memory st) {
        st = "stop";
    }
}
