// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Visitors {

    // Owner

    address owner = msg.sender;

    modifier onlyOwner { require(owner == msg.sender, "only owner"); _;}

    // VisitorCame

    event VisitorCame(uint256 timestamp);
    uint256 public visitors;

    function visitorCame() external onlyOwner {
        visitors++;
        emit VisitorCame(block.timestamp);
    }

    // VisitorCameAddress

    event VisitorCameAddress(uint256 timestamp, address visitor);
    uint256 public visitorsWithAddress;

    function visitorCameAddress(address _visitor) external onlyOwner {
        visitorsWithAddress++;
        emit VisitorCameAddress(block.timestamp, _visitor);
    }
}
