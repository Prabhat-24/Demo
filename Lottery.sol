// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    struct LotteryBuyers {
        string name;
        address userAddress;
    }
    address manager;
    uint256 count;

    mapping(uint256 => LotteryBuyers) private lotteryBuyersData;

    constructor() {
        manager = msg.sender;
    }

    modifier onlyManager() {
        require(manager == msg.sender, "Lottery:Only manager allowed");
        _;
    }

    function entry(string memory name) public payable {
        require(manager != msg.sender, "Lottery:Manager not allowed");
        require(msg.value == 1 ether, "Lottery:Sorry! please pay 1 ethere");
        require(existCustomer() == false, "Lottery:sorry! only once");
        lotteryBuyersData[count++] = LotteryBuyers(name, msg.sender);
    }

    function existCustomer() private view returns (bool) {
        for (uint256 i = 0; i < count; i++) {
            if (lotteryBuyersData[i].userAddress == msg.sender) {
                return true;
            }
        }
        return false;
    }

    function totalLotteryBuyers() public view returns (uint256) {
        return count;
    }

    function randomNumber() private view returns (uint256) {
        uint256 randNo = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.number, msg.sender)
            )
        ) % count;

        return randNo;
    }

    function winner() public view onlyManager returns (LotteryBuyers memory) {
        uint256 rNum = randomNumber();
        return lotteryBuyersData[rNum];
    }

    function fundTransfer() public onlyManager {
        payable(winner().userAddress).transfer(2 ether);
    }
}
