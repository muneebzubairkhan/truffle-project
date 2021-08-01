// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./TokenERC20.sol";

contract ERC20Generator {
    uint256 _1000_coins = 1000 * 1e18;
    IERC20[] erc20s;

    function createERC20(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) public {
        IERC20 erc20 = new TokenERC20(_name, _symbol, _totalSupply);
        erc20s.push(erc20);
    }
}
