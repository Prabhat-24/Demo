// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Array {
    function fixedArray() public pure returns (uint16[3] memory) {
        uint16[3] memory arrf = [uint16(1), 2, 3];
        return arrf;
    }

    uint32[]  arrd;

  function dynamicArray(uint8 num) public  {
        arrd.push(num);
    }
  function arrayLength()public view returns(uint){
    return arrd.length;
  }  
  function dynamicArray2(uint8 num) public pure {
        uint32[] memory arr = new uint32[](3);
           for(uint8 i=0;i<=arr.length-1;i++){
            arr[i]=num;
           }
          
    }
}
