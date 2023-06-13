// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract C {
    uint256 private data;

    uint256 public info;

    constructor()  {
        info = 10;
    }

    function increment(uint256 a) private pure returns (uint256) {
        return a + 1;
    }

    function updateData(uint256 a) public {
        data = a;
    }

    function getData() external view returns (uint256) {
        return info;
    }

    function compute(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }
}


contract D {
    function readData() public returns (uint256) {
        C c = new C();
        c.updateData(7);
        return c.getData();
    }
   
}
 contract Y is C{
    function call() public pure returns(uint256){
       return compute(10, 20);
    }
 }
