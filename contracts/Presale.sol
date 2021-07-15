// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// functions: setRate, buyTokens, unlockable...
contract Presale is Ownable {
    IERC20 public token;
    IERC20 public usdt;
    uint256 public tokensSold = 0;
    uint256 public rate = 3000; // 0.3 = 3000, 0.45 = 4500, 0.69 = 6900 // 0.3 USDT = 1 ARI
    address public wallet;

    constructor(
        IERC20 _token,
        IERC20 _usdt
    ) {
        token = _token;
        usdt = _usdt;
        wallet = msg.sender;
    }

    function buyTokens(uint256 _tokens) external {
        tokensSold += _tokens;
        usdt.transferFrom(msg.sender, wallet, (_tokens * rate) / 10000);
        token.transfer(msg.sender, _tokens);
    }

    function ownerFunction_setRate(uint256 _rate) external onlyOwner {
        rate = _rate;
    }

    function ownerFunction_getLockedTokens(IERC20 _token) external onlyOwner {
        _token.transfer(owner(), _token.balanceOf(address(this)));
    }
}
