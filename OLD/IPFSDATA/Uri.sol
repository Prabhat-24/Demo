// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DemoContractStruct {
    struct Emp {
        string empName;
        uint256 empId;
        uint256 empNumber;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
