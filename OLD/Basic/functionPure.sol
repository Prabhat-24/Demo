// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.0;
contract FunctionPure {
   function getResult() public pure  returns(uint8 product){
      uint8 a = 1;
      uint8 b = 2;
      product = a * b;
    
 
   }
}