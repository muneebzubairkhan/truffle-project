// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenERC20 is ERC20 {
    uint256 coins1000 = 1000 * 1e18;

    constructor(
        address _owner,
        string memory _name,
        string memory _symbol,
        uint256 _supply
    ) ERC20(_name, _symbol) {
        _mint(_owner, _supply);
    }

    function get_1000_coins() public {
        _mint(msg.sender, coins1000);
    }

    function get_1000_coins_at_address(address _account) public {
        _mint(_account, coins1000);
    }
}
