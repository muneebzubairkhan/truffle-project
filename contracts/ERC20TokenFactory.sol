// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./ERC20Token.sol";

contract ERC20TokenFactory {
    IERC20[] public erc20s;

    function createERC20(
        address _owner,
        string memory _name,
        string memory _symbol,
        uint256 _totalSupply
    ) external {
        IERC20 erc20 = new ERC20Token(_owner, _name, _symbol, _totalSupply);
        erc20s.push(erc20);
    }

    function getERC20s() external view returns (IERC20[] memory) {
        return erc20s;
    }
}
