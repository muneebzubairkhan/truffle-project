// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract ERC20Token is Ownable, Pausable, ERC20("ERC20Token", "ETK"), ERC20Burnable {

    constructor () {
        whitelist[0x1240174b1FE44DD1c48450afbb172641aCc9E1d1] = true; // whitelist staking contract
    }

    // mint limit
    uint mintingLimit = 1 * 1e9 * 1e18; // 1 Billion Supply = 1 * 9 zeros * 18 zeros = (1 * 9 zeros = 1 Billion) * (18 zeros = 18 decimals)

    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
        require(totalSupply() <= mintingLimit, "Increase the mint limit first.");   
    }

    // white list
    mapping(address => bool) private whitelist;

    function setWhitelist(address[] calldata minters, bool allow) external onlyOwner {
        for (uint256 i; i < minters.length; i++) whitelist[minters[i]] = allow;
    }

    function whitelist_mint(address account, uint256 amount) external whenNotPaused {
        require(whitelist[msg.sender], "Sender must be whitelisted");
        _mint(account, amount);
        require(totalSupply() <= mintingLimit, "Ask the owner to increase the mint limit first.");   
    }
}