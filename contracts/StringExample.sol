// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract StringExample {
    string public myString = "hello world!";
    string public myString2 = "hello world!";

    function setMyString(string memory _myString) public {
        myString = _myString;
    }

    function setMyString2(string memory _myString) public {
        myString2 = _myString;
    }
}
