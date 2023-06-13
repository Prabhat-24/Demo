// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Calculator {
    function sum(uint8 a, uint8 b) external returns (uint8);

    function sub(uint8 a, uint8 b) external returns (uint8);

    function div(uint8 a, uint8 b) external returns (uint8);

    function mul(uint8 a, uint8 b) external returns (uint8);
}

contract Test is Calculator {
    function sum(uint8 a, uint8 b) external pure returns (uint8) {
        uint8 sum_ = a + b;
        return sum_;
    }

    function sub(uint8 a, uint8 b) external pure returns (uint8) {
        uint8 sub_ = a - b;
        return sub_;
    }

    function div(uint8 a, uint8 b) external pure returns (uint8) {
        uint8 div_ = a / b;
        return div_;
    }

    function mul(uint8 a, uint8 b) external pure returns (uint8) {
        uint8 mul_ = a * b;
        return mul_;
    }
}
