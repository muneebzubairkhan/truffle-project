// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// functions: setRate, buyTokens
contract Presale is Ownable {
    IERC20 token;
    IERC20 usdt;
    uint256 tokensSold = 0;
    uint256 rate = 3000; // 0.3 = 3000, 0.45 = 4500, 0.69 = 6900 // 0.3 USDT = 1 ARI, rate = 0.3, 0.45, 0.69
    address wallet;

    constructor(
        IERC20 _token,
        IERC20 _usdt,
        address _wallet
    ) {
        usdt = _usdt;
        wallet = _wallet;
        token = _token;
    }

    // do the natspec annotations
    // input: buyTokens(100), expected output: person charged 100*0.3 = $30 and gets 100 tokens
    // 1 test case will be formed
    function buyTokens(uint256 _tokens) public {
        tokensSold += _tokens;
        usdt.transferFrom(msg.sender, wallet, (_tokens * rate) / 10000);
        token.transfer(msg.sender, _tokens);
    }

    function setRate(uint256 _rate) public onlyOwner {
        rate = _rate;
    }
}

/*
10 10*1
10 10*0.3 = 3
*/
