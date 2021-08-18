// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20Token is Ownable, ERC20 {
    uint256 _1000_coins = 1000 * 1e18;

    constructor(
        address _owner,
        string memory _name,
        string memory _symbol,
        uint256 _supply
    ) ERC20(_name, _symbol) {
        _mint(_owner, _supply);
        transferOwnership(_owner);
    }

    function get_1000_Coins() public {
        _mint(msg.sender, _1000_coins);
    }

    function get_1000_coins_at_address(address _account) public {
        _mint(_account, _1000_coins);
    }
}
