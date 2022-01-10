// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract ERC20Pausable is Ownable, Pausable, ERC20("Rarible", "RARI") {
    function transfer(address to, uint256 value) public override whenNotPaused returns (bool) {
        return super.transfer(to, value);
    }

    function transferFrom(address from, address to, uint256 value) public override whenNotPaused returns (bool) {
        return super.transferFrom(from, to, value);
    }

    function approve(address spender, uint256 value) public override whenNotPaused returns (bool) {
        return super.approve(spender, value);
    }

    function increaseAllowance(address spender, uint256 addedValue) public override whenNotPaused returns (bool) {
        return super.increaseAllowance(spender, addedValue);
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public override whenNotPaused returns (bool) {
        return super.decreaseAllowance(spender, subtractedValue);
    }
}

contract RariToken is ERC20Pausable {
    bool public mintStopped = false;

    function mint(address account, uint256 amount) public onlyOwner returns (bool) {
        require(!mintStopped, "mint is stopped");
        _mint(account, amount);
        return true;
    }

    function stopMint() public onlyOwner {
        mintStopped = true;
    }
}