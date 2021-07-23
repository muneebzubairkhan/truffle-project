// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract USDT is ERC20("USDT", "USDT") {
    uint256 coins1000 = 1000 * 1e18;

    constructor() {
        _mint(msg.sender, coins1000);
    }

    function mint() public {
        _mint(msg.sender, coins1000);
    }

    function mint(address _account) public {
        _mint(_account, coins1000);
    }
}
