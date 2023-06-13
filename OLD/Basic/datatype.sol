// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// contract DrinkMachine {
//     function getDrinkSize(uint8 amount) public pure returns (string memory) {
//         string memory drinkSize;
//         if (amount == 5) {
//             drinkSize = "small size ";
//         } else if (amount == 8) {
//             drinkSize = "medium size";
//         } else if (amount == 10) {
//             drinkSize = "large size";
//         } else {
//             drinkSize = "invalid";
//         }
//         return drinkSize;
//     }
// }
 contract voting{
    
     function votingAge(uint8 age)public pure returns(bool) {
       bool result=(age>=18);
             return result;
     }
 }