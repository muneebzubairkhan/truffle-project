// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract USDT is ERC20("USDT", "USDT") {
    uint256 public SUPPLY = 1 * 1e18 * 1e18;

    constructor() {
        _mint(msg.sender, SUPPLY);
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        uint256 toBurn = amount.mul(5).div(100);
        uint256 toRewards = amount.div(100);
        uint256 toTransfer = amount.sub(toRewards).sub(toBurn);

        _burn(msg.sender, toBurn);
        _transfer(_msgSender(), recipient, toTransfer);
        return true;
    }
}
