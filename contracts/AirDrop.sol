// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AirDrop is Ownable {
    uint256 fromBlock;
    uint256 toBlock;

    mapping(uint256 => address) public rewardWinner;

    function getFromToBlock() external view returns (uint256, uint256) {
        return (fromBlock, toBlock);
    }

    function airdropERC20(
        IERC20 _token,
        uint256[] calldata _tokenIds,
        address[] calldata _to,
        uint256[] calldata _values,
        uint256 _fromBlock,
        uint256 _toBlock
    ) external onlyOwner {
        require(_to.length == _values.length, "Only Owner and correct data");
        fromBlock = _fromBlock;
        toBlock = _toBlock;

        for (uint256 i = 0; i < _to.length; i++) {
            address winner = rewardWinner[_tokenIds[i]];

            if (winner == address(0)) rewardWinner[_tokenIds[i]] = _to[i];

            require(_token.transfer(rewardWinner[_tokenIds[i]], _values[i]));
        }
    }

    function withdrawAllWETH() external onlyOwner {
        IERC20 _token = IERC20(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619);

        withdrawSomeWETH(_token.balanceOf(address(this)));
    }

    /// @notice provide value in wei https://eth-converter.com/
    function withdrawSomeWETH(uint256 _amountInWei) public onlyOwner {
        IERC20 _token = IERC20(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619);

        withdrawAnyERC20(_token, _amountInWei);
    }

    /// @notice provide erc20 token address and provide value in wei https://eth-converter.com/
    function withdrawAnyERC20(IERC20 _token, uint256 _amount) public onlyOwner {
        _token.transfer(msg.sender, _amount);
    }
}
