// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AirDrop is Ownable {
    function airdropERC20(
        IERC20 _token,
        address[] calldata _to,
        uint256[] calldata _values
    ) external onlyOwner {
        require(_to.length == _values.length, "Only Owner and correct data");
        for (uint256 i = 0; i < _to.length; i++) require(_token.transfer(_to[i], _values[i]));
    }
}
