// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract DemoContract 
{
    enum customerType{Regular, Premium, VIP}

    uint public discount;

   function calculate_discount( customerType cust) public 
    { 
        

        if (cust == customerType.Regular)
        {
            discount = 15;          
        }
        else if (cust == customerType.Premium)
        {
            discount = 25;          
        }
        else if (cust == customerType.VIP)
        {
            discount = 35;          
        }
    
    }
}