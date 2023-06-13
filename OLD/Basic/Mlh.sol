// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    string  x;

    function setA() external  returns(string memory ){
        x = "GeeksForGeeks";
        return x;
    }
}

contract B {
    uint256  pow;

    function setB() external  returns(uint256){
        uint256 a = 2;
        uint256 b = 20;
        pow = a**b;
        return pow;
    }
}

contract C is A, B {
    function getStr() external view returns (string memory) {
        return x;
    }

    function getPow() external view returns (uint256) {
        return pow;
    }
}

contract caller {
    C contractC = new C();

    function testInheritance() public returns(string memory,uint){
       return (contractC.setA(),contractC.setB());
        
     }
}
