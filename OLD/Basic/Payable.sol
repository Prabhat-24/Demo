// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 contract DemoPayable{
    address  payable receiver=payable(0x583031D1113aD414F02576BD6afaBfb302140225);
 
 function  payEther() public payable {

 }
 function getBalance()public view returns(uint){
     return address(this).balance;
 } 
 function sendEther()public {
receiver.transfer(1 ether);
 }
 }