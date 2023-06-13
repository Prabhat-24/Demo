// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DonationSystem {
    struct DonorData {
        string donorName;
        uint256 numberOfEtherR;
    }
    struct ReceiverData {
        string receiverName;
        uint256 numberOfEtherD;
    }

    address private owner;
    uint32 private count;

    mapping(address => DonorData[]) private donorDetails;
    mapping(uint256 => ReceiverData) public receiverDetails;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "DonationSystem:not owner");
        _;
    }

    function Donate(string memory name) public payable {
        require(
            msg.value > 0 ether,
            "DonationSystem:please send more than 0 ether"
        );
        require(
            abi.encodePacked(name).length != 0,
            "DonationSystem:please fill your name"
        );

        donorDetails[msg.sender].push(DonorData(name, msg.value));
    }

    function DonorDetails(address donorAddress)
        public
        view
        onlyOwner
        returns (DonorData[] memory)
    {
        return donorDetails[donorAddress];
    }

    function totalFund() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }

    function removeDonor(address donor) public onlyOwner {
        delete donorDetails[donor];
    }

    function distributeFund(
        address receiverAddress,
        string memory receiverName,
        uint32 numberOfEther
    ) public payable onlyOwner {
        require(
            address(this).balance >= numberOfEther * 1 ether,
            "DonationSystem:insufficient balance"
        );
        require(
            receiverAddress != owner,
            "DonationSystem: owner not eligible to receive"
        );
        require(
            numberOfEther != 0 && address(this).balance >= numberOfEther,
            "DonationSystem:invalid input"
        );

        payable(receiverAddress).transfer(numberOfEther * 1 ether);
        receiverDetails[count++] = ReceiverData(receiverName, numberOfEther);
    }
}
