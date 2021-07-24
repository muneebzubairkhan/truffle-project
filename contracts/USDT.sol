// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract USDT is ERC20("USDT", "USDT") {
    uint256 coins1000 = 1000 * 1e18;

    constructor() {
        _mint(msg.sender, coins1000);
    }

    function mintMe1000Coins() public {
        _mint(msg.sender, coins1000);
    }

    function mint1000CoinsToSomeAddress(address _account) public {
        _mint(_account, coins1000);
    }

    /// @dev Fix for the ERC20 short address attack.
    modifier onlyPayloadSize(uint256 size) {
        require(!(msg.data.length < size + 4));
        _;
    }

    /// @dev a contract must use SafeERC20 to use this method transferFrom()
    /// @notice I learnt it from USDT contract on ETH Mainnet on 24 July 2021, 3:30 am.
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override onlyPayloadSize(3 * 32) returns (bool) {
        return super.transferFrom(_from, _to, _value);
        // block.timestamp;
        // return true;
    }
}
