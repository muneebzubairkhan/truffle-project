// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Presale {
    IERC20 token;
    IERC20 usdt;
    uint256 tokensSold = 0;
    uint256 increment = 1000;
    address wallet;

    constructor(IERC20 _usdt, address _wallet) {
        usdt = _usdt;
        wallet = _wallet;
    }

    // do the natspec annotations
    function buyTokens(uint256 tokens) public {
        tokensSold += tokens;
        increment += (tokens * increment); // calculate on copy pencil // infinite series calculus practical here
        usdt.transferFrom(msg.sender, wallet, tokens + increment);
        token.transfer(msg.sender, tokens);
    }
}

/*
10 10*1
10 10*0.3 = 3
*/
