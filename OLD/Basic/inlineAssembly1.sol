// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InlineAssembly1 {
  function getCurrentBlockNumber() public view returns (uint256) {
    uint256 blockNumber;
    assembly {
        blockNumber := number()
    }
    return blockNumber;
}
}
