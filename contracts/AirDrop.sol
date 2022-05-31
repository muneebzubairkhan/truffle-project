// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract AirDrop {
    address owner = msg.sender;

    function airDrop(address[] calldata _to, uint256[] calldata _values) external {
        require(owner == msg.sender);
        for (uint256 i = 0; i < _to.length; i++) payable(_to[i]).transfer(_values[i]);
    }

    receive() external payable {}
}
