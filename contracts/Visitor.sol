// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

contract Visitors {
    uint256 public visitors;

    event VisitorCame(uint256 visitorNumber);
    
    function visitorCame() external {
        visitors++;
        emit VisitorCame(visitors);
    }
}