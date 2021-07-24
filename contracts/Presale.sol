// SPDX-License-Identifier: MIT
pragma solidity ^0.6.2;
import "@pancakeswap/pancake-swap-lib/contracts/access/Ownable.sol";
import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";

// functions: setRate, buyTokens...
contract Presale is Ownable {
    IBEP20 public token;
    IBEP20 public usdt;
    uint128 public tokensSold = 0;
    uint128 public rate = 3000; // 0.3 = 3000, 0.45 = 4500, 0.69 = 6900 // 0.3 USDT = 1 ARI
    address public walletOwner;
    address public walletDev;

    constructor(
        IBEP20 _token,
        IBEP20 _usdt,
        address _walletOwner,
        address _walletDev
    ) public {
        token = _token;
        usdt = _usdt;
        walletOwner = _walletOwner;
        walletDev = _walletDev;
        transferOwnership(_walletOwner);
    }

    /// @notice user buys 100 tokens at rate of 0.3 then 33 USDT will be deducted and 100 tokens will be given
    function buyTokens(uint128 _tokens) external {
        tokensSold += _tokens;
        uint128 price80percent = (_tokens * rate * 80) / 1000000;
        uint128 price20percent = (_tokens * rate * 20) / 1000000;
        usdt.transferFrom(msg.sender, walletOwner, price80percent);
        usdt.transferFrom(msg.sender, walletDev, price20percent);
        token.transfer(msg.sender, _tokens);
    }

    function ownerFunction_setRate(uint128 _rate) external onlyOwner {
        rate = _rate;
    }

    function ownerFunction_getLockedTokens(IBEP20 _token) external onlyOwner {
        _token.transfer(owner(), _token.balanceOf(address(this)));
    }
}
