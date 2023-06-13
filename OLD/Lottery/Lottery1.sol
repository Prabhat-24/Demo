// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Lottery {
    struct LotteryBuyers {
        string name;
        address userAddress;
    }
    struct WinnerList {
        string winnerName;
        address winnerAddress;
    }
    address manager;
    uint256 count;
    bool winnerOneCall = true;
    bool winnerTwoCall = true;

    mapping(uint256 => LotteryBuyers) private lotteryBuyersData;
    mapping(uint256 => WinnerList) private winner;

    constructor() {
        manager = msg.sender;
    }

    modifier onlyManager() {
        require(manager == msg.sender, "Lottery:Only manager allowed");
        _;
    }

    function entry(string memory name) public payable {
        require(msg.value == 1 ether, "Lottery:Sorry! please pay 1 ethere");
        require(
            abi.encodePacked(name).length != 0,
            "Lottery:please fill your name"
        );
        require(manager != msg.sender, "Lottery:Manager not allowed");

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

    receive() external payable onlyManager {}

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

    function winnerOne() public payable onlyManager {
        require(
            winnerOneCall == true,
            "Lottery:Multiple times call not allowed"
        );
        winnerOneCall = false;
        require(count >= 4, "Lottery:Lottery registration not done yet");
        winner[1] = WinnerList(
            lotteryBuyersData[randomNumber()].name,
            lotteryBuyersData[randomNumber()].userAddress
        );
        payable(lotteryBuyersData[randomNumber()].userAddress).transfer(
            2 ether
        );
    }

    function winnerTwo() public payable onlyManager {
        require(
            winnerTwoCall == true,
            "Lottery:Multiple times call not allowed"
        );
        winnerTwoCall = false;
        require(count >= 4, "Lottery:Lottery registration not complete");
        require(
            winner[1].winnerAddress !=
                lotteryBuyersData[randomNumber()].userAddress
        );
        winner[2] = WinnerList(
            lotteryBuyersData[randomNumber()].name,
            lotteryBuyersData[randomNumber()].userAddress
        );
        payable(lotteryBuyersData[randomNumber()].userAddress).transfer(
            2 ether
        );
    }

    function displayWinner(uint8 winnerNumber)
        public
        view
        returns (WinnerList memory)
    {
        if (winnerNumber == 1) {
            if (winnerOneCall == true) {
                revert("Lottery:winner not declared");
            } else {
                return winner[winnerNumber];
            }
        }
        if (winnerNumber == 2) {
            if (winnerTwoCall == true) {
                revert("Lottery:winner not declared");
            } else {
                return winner[winnerNumber];
            }
        } else {
            revert("Lottery:invalid input");
        }
    }
}
