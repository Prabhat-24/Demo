// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface SchoolDatabase {
    struct StudentData {
        string studentName;
        uint256 studentRollNumber;
        string studentGender;
        string studentAddress;
        address addressStudent;
    }
    struct StudentPerformance {
        string examGrade;
        string sportsGrade;
    }
    struct TeacherData {
        string teacherName;
        uint256 empId;
        string teacherGender;
        string teacherAddress;
        address addressTeacher;
    }
}

contract Student is SchoolDatabase {
    address admin;
    mapping(uint256 => StudentData) public studentData;
    mapping(uint256 => StudentPerformance) public studentPerformance;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(admin == msg.sender, "Student:only Admin");
        _;
    }

    function enterDetails(
        string memory studentName,
        uint256 studentRollNumber,
        string memory studentGender,
        string memory studentAddress,
        address addressStudent
    ) public onlyAdmin {
        studentData[studentRollNumber] = StudentData(
            studentName,
            studentRollNumber,
            studentGender,
            studentAddress,
            addressStudent
        );
    }

    function performanceDetails(
        uint256 rollNumber,
        string memory examGrade,
        string memory sports
    ) public onlyAdmin {
        studentPerformance[rollNumber] = StudentPerformance(examGrade, sports);
    }
}

contract Teacher is SchoolDatabase {
    address admin;

    constructor() {
        admin = msg.sender;
    }

    mapping(string => TeacherData) public teacherData;
    modifier onlyAdmin() {
        require(admin == msg.sender, "Student:only Admin");
        _;
    }

    function enterDetails(
        string memory teacherName,
        uint256 empId,
        string memory teacherGender,
        string memory teacherAddress,
        address addressTeacher
    ) external onlyAdmin {
        teacherData[teacherName] = TeacherData(
            teacherName,
            empId,
            teacherGender,
            teacherAddress,
            addressTeacher
        );
    }
}
