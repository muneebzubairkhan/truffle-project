// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Visitors {
    event VisitorCame(uint256 timestamp);
    uint256 public visitors;
    address owner = msg.sender;

    function visitorCame() external {
        require(owner == msg.sender, "only owner");
        visitors++;
        emit VisitorCame(block.timestamp);
    }
}
