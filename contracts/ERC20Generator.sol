// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./TokenERC20.sol";

contract ERC20Generator {
    IERC20[] public erc20s;

    function createERC20(
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) external {
        IERC20 erc20 = new TokenERC20(_name, _symbol, _totalSupply);
        erc20s.push(erc20);
    }

    function getERC20s() external view returns (IERC20[] memory) {
        return erc20s;
    }
}
