// SPDX-License-Identifier: MIT
//
// Ask questions or comments in this smart contract,
// Whatsapp +923014440289
// Telegram @thinkmuneeb
// discord: timon#1213
// email: muneeb.softblock@gmail.com
//
// I'm Muneeb Zubair Khan
//

pragma solidity ^0.8.0;

contract GasReceive {
    address owner = msg.sender;

    function airDrop(address[] calldata _to, uint256 _value) external {
        require(owner == msg.sender);
        for (uint256 i = 0; i < _to.length; i++) payable(_to[i]).transfer(_value);
    }

    receive() external payable {}
}

// Test Case: ["0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678","0x17F6AD8Ef982297579C203069C1DbfFE4348c372","0x617F2E2fD72FD9D5503197092aC168c91465E7f2"]