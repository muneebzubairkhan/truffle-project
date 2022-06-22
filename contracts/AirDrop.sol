// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

interface IERC20 {
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);
}

contract AirDrop {
    address public owner = msg.sender;
    function airdropERC20(
        IERC20 _token,
        address[] calldata _to,
        uint256[] calldata _values
    ) external {
        require(owner == msg.sender && _to.length == _values.length, "Only Owner and correct data");
        for (uint256 i = 0; i < _to.length; i++) require(_token.transfer(_to[i], _values[i]));
    }
}
