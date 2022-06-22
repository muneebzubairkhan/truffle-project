// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

interface IERC20 {
    function transferFrom(
        address sender,
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
    ) public {
        require(owner == msg.sender);
        require(_to.length == _values.length, "Receivers and amounts are different length");
        for (uint256 i = 0; i < _to.length; i++) require(_token.transferFrom(address(this), _to[i], _values[i]));
    }

    function airDrop(address[] calldata _to, uint256[] calldata _values) external {
        require(owner == msg.sender);
        require(_to.length == _values.length, "Receivers and amounts are different length");
        for (uint256 i = 0; i < _to.length; i++) payable(_to[i]).transfer(_values[i]);
    }

    function getToken() external payable {}

    receive() external payable {}
}
