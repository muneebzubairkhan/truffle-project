// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// functions: setRate, buyTokens...
contract Presale is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public tokenX; // People will buy tokenX
    IERC20 public buyingToken; // People will give buyingToken and get tokenX in return
    uint public tokenXSold = 0;
    uint public rate; // 3 = 3 000 000 000 000 000 000, 0.3 = 3 00 000 000 000 000 000 // 0.3 buyingToken = 1 TokenX
    address public walletOwner;
    address public walletDev;

    constructor(
        IERC20 _tokenX,
        IERC20 _buyingToken,
        uint _rate,
        address _walletOwner
    ) {
        tokenX = _tokenX;
        buyingToken = _buyingToken;
        rate = _rate;
        walletOwner = _walletOwner;
        transferOwnership(_walletOwner);
    }

    /// @notice user buys at rate of 0.3 then 33 BUSD or buyingToken will be deducted and 100 tokenX will be given
    function buyTokens(uint _tokens) external {
        tokenXSold += _tokens;
        uint price = (_tokens * rate ) / 1e18;
        buyingToken.transferFrom(msg.sender, walletOwner, price);
        tokenX.transfer(msg.sender, _tokens);
    }

    function ownerFunction_setRate(uint _rate) external onlyOwner {
        rate = _rate;
    }

    function ownerFunction_getLockedTokens(IERC20 _token) external onlyOwner {
        _token.transfer(owner(), _token.balanceOf(address(this)));
    }
}

// be ware of ownerships and mint to proper owners
// as different factory calling will be used

// 