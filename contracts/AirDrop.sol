// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AirDrop is Ownable {
    uint256 fromBlock;
    uint256 toBlock;

    function getFromToBlock() external view returns (uint256, uint256) {
        return (fromBlock, toBlock);
    }

    function airdropERC20(
        IERC20 _token,
        address[] calldata _to,
        uint256[] calldata _values,
        uint256 _fromBlock,
        uint256 _toBlock
    ) external onlyOwner {
        require(_to.length == _values.length, "Only Owner and correct data");
        fromBlock = _fromBlock;
        toBlock = _toBlock;

        for (uint256 i = 0; i < _to.length; i++) 
            require(_token.transfer(_to[i], _values[i]));
    }

    function withdrawWETH() external onlyOwner {
        withdrawAnyERC20(IERC20(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619));
    }

    function withdrawAnyERC20(IERC20 _token) public onlyOwner {
        _token.transfer(msg.sender, _token.balanceOf(address(this)));
    }

    /// @notice provide the value in wei https://eth-converter.com
    function withdrawAnyERC20(IERC20 _token, uint256 amount) public onlyOwner {
        _token.transfer(msg.sender, amount);
    }
}