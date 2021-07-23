// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ARI is ERC20, Ownable {
    string constant NAME = "ARI";
    string constant SYMBOL = "ARI";
    uint256 constant TOTAL_SUPPLY = 1_000_000_000 ether;

    constructor(address _walletOwner) ERC20(NAME, SYMBOL) {
        _mint(_walletOwner, TOTAL_SUPPLY);
    }

    function ownerFunction_getLockedTokens(IERC20 _token) external onlyOwner {
        _token.transfer(owner(), _token.balanceOf(address(this)));
    }
}
