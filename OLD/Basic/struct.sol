
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract DemoContractStruct {
   struct Emp {
      string empName;
      uint empId;
      uint empNumber;
    } 
      Emp  emp;
    function setEmpDetails(string memory _name,uint _id,uint _num)public {
 
       emp =Emp(_name,_id,_num);
    }
     function getEmpDetails() public view returns(Emp memory){
 return emp;
    }
    }
