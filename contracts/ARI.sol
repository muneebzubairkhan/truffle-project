// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;
import "@pancakeswap/pancake-swap-lib/contracts/access/Ownable.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/BEP20.sol";

contract ARI is Ownable, BEP20 {
    string constant NAME = "ARI";
    string constant SYMBOL = "ARI";
    uint256 constant TOTAL_SUPPLY = 1_000_000_000 ether;

    constructor(address _walletOwner) public BEP20(NAME, SYMBOL) {
        _mint(msg.sender, TOTAL_SUPPLY);
        transferOwnership(_walletOwner);
    }

    function ownerFunction_getLockedTokens(IBEP20 _token) external onlyOwner {
        _token.transfer(owner(), _token.balanceOf(address(this)));
    }
}
