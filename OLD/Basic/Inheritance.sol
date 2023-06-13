// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// contract A {
//     function play(int256 x, int256 y) public virtual returns (int256 sum) {
//         return sum = x + y;
//     }
// }

// contract B is A {
//     function play(int256 x, int256 y) public pure override returns (int256 mul)
//     {
//         return mul = x * y;
//     }
// }

contract Animal {
    function makeSound() public  virtual returns (string memory) {
        return "Animal sound";
    }
}

contract Cat is Animal {
    function makeSound() public override returns (string memory) {
        string memory sound = super.makeSound();
        return string(abi.encodePacked(sound, " and ", "Meow"));
    }
}
// contract Animal {
//     function makeSound() virtual public returns (string memory){

//     }
// }

// contract Cat is Animal {
//     function makeSound() public pure override returns (string memory) {

//         return "Meow";
//     }
// }
