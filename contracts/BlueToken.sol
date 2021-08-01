// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BlueToken is ERC20("Blue Token", "BLUE") {
    uint256 _1000_coins = 1000 * 1e18;

    constructor() {
        _mint(msg.sender, _1000_coins);
    }

    function get_1000_Coins() public {
        _mint(msg.sender, _1000_coins);
    }

    function get_1000_coins_at_address(address _account) public {
        _mint(_account, _1000_coins);
    }
}
