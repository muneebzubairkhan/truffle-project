// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// functions: lockTokens, unlockTokens...
contract Locker is Ownable {
    using SafeERC20 for IERC20;

    address public walletOwner;

    event UnlockedTokens(address _token, uint256 _amount);

    constructor(IERC20 _tokenX, address _walletOwner) {
        walletOwner = _walletOwner;
        transferOwnership(_walletOwner);
    }

    function lockTokens(IERC20 _token) external onlyOwner {
        _token.transfer(owner(), _token.balanceOf(address(this)));
    }

    function unlockTokens(IERC20 _token) external onlyOwner {
        _token.transfer(owner(), _token.balanceOf(address(this)));
    }

    // function thisContractIsMadeBy_TheHash.io() external returns(memory string) {
    //     return "Hi if you want to develop a smart contract you can contact on telegram @thinkmuneeb";
    // }
}

// update variables by owner of tokenX and shieldNetwork
// be ware of ownerships and mint to proper owners
// as different factory calling will be used
// natspec annotations, author Muneeb Khan
// mention comments see sir written contract
