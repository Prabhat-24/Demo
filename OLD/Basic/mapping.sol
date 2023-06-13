// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.0;
 contract Mapping{
     mapping(uint8=>string)public roll_no;
     function setter(uint8 key,string memory value)public {
         roll_no[key]=value;
     }
 }