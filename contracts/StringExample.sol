// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract StringExample {
    string public myString = "hello world!";

    function setMyString(string memory _myString) public {
        myString = _myString;
    }
}
