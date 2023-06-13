// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//  contract transfer{
//      function checkBalance()public view returns(uint) {
//       return (msg.sender).balance;
//      }
//  }
contract ViewFunction{
   
  
    function viewFunction()public pure returns(uint){
         uint x=10;
        return x;
    }
}