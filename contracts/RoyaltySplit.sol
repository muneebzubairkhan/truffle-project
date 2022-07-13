// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract RoyaltySplit is Ownable {
    receive() external payable {}

    function getToken() external payable {}

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;

        payable(msg.sender).transfer((balance * 0.20 ether) / 1 ether); // 20%
        payable(msg.sender).transfer((balance * 0.20 ether) / 1 ether); // 20%
        payable(msg.sender).transfer((balance * 0.20 ether) / 1 ether); // 20%
        payable(msg.sender).transfer((balance * 0.20 ether) / 1 ether); // 20%
        payable(msg.sender).transfer((balance * 0.20 ether) / 1 ether); // 20%
    }

    function withdrawERC20(IERC20 _erc20) external onlyOwner {
        uint256 balance = _erc20.balanceOf(address(this));

        _erc20.transfer(msg.sender, (balance * 0.20 ether) / 1 ether); //  20%
        _erc20.transfer(msg.sender, (balance * 0.20 ether) / 1 ether); //  20%
        _erc20.transfer(msg.sender, (balance * 0.20 ether) / 1 ether); //  20%
        _erc20.transfer(msg.sender, (balance * 0.20 ether) / 1 ether); //  20%
        _erc20.transfer(msg.sender, (balance * 0.20 ether) / 1 ether); //  20%
    }
}
