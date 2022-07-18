// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract AirDrop is Ownable {
    uint256 fromBlock;
    uint256 toBlock;

    // tokenId => tokenId Seller
    mapping(uint256 => address) public sellerOf;

    // tokenId => reward percentage to sell tokenId
    mapping(uint256 => uint256) public rewardPercentageOf;

    function _saveRoyaltyInfo(
        uint256 _soldTokenId,
        address _seller,
        uint256 _rewardPercentage
    ) internal {
        if (sellerOf[_soldTokenId] == address(0)) {
            sellerOf[_soldTokenId] = _seller;
            rewardPercentageOf[_soldTokenId] = _rewardPercentage;
        }
    }

    function saveRoyaltyInfo(
        address[] calldata _sellers,
        uint256[] calldata _soldTokenIds,
        uint256[] calldata _percentagesRewardOnSale
    ) external onlyOwner {
        for (uint256 i = 0; i < _soldTokenIds.length; i++) _saveRoyaltyInfo(_soldTokenIds[i], _sellers[i], _percentagesRewardOnSale[i]);
    }

    function airdropERC20(
        IERC20 _token,
        uint256[] calldata _soldTokenIds,
        uint256[] calldata _rewardOfProjOwner,
        uint256 _fromBlock,
        uint256 _toBlock
    ) external onlyOwner {
        require(_soldTokenIds.length == _rewardOfProjOwner.length, "Send Correct data _soldTokenIds.length == _rewardOfProjOwner.length");

        fromBlock = _fromBlock;
        toBlock = _toBlock;

        for (uint256 i = 0; i < _soldTokenIds.length; i++) require(_token.transfer(sellerOf[_soldTokenIds[i]], (rewardPercentageOf[_soldTokenIds[i]] * _rewardOfProjOwner[i]) / 100));
    }

    function withdrawAllWETH() external onlyOwner {
        withdrawWETH(IERC20(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619).balanceOf(address(this)));
    }

    /// @notice provide value in wei https://eth-converter.com
    function withdrawWETH(uint256 _amountInWei) public onlyOwner {
        withdrawAnyERC20(0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619, _amountInWei);
    }

    /// @notice provide ERC20 token address and provide value in wei https://eth-converter.com/ , ERC20 WETH is at 0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619 i.e https://polygonscan.com/address/0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619
    function withdrawAnyERC20(address _token, uint256 _amount) public onlyOwner {
        IERC20(_token).transfer(msg.sender, _amount);
    }
}
