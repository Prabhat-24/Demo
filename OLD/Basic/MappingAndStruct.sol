// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.0;
 contract MappingAndStruct{
     struct student{
         string name;
         uint8 class;
     }
     mapping(uint8=>student ) public data;
     function setter(uint8 roll_no,string memory name,uint8 class)public  {
         data[roll_no]=student(name,class);

     }
 }