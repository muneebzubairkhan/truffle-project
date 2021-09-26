// Hi. If you have any questions or comments in this smart contract please let me know at:
// Whatsapp +923014440289, Telegram @thinkmuneeb, discord: timon#1213, I'm Muneeb Zubair Khan
//
//
// Smart Contract belong to this DAPP: https://shield-launchpad.netlify.app/ Made in Pakistan by Muneeb Zubair Khan
// The UI is made by Abraham Peter, Whatsapp +923004702553, Telegram @Abrahampeterhash.
// Project done in collaboration with TrippyBlue and ShieldNet Team.
//
//
// SPDX-License-Identifier: MIT
//
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// functions: lockTokens, unlockTokens...
contract Locker is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public tokenX;
    address public walletOwner;
    address public factory;

    uint256 public unlockTokensAtTime;
    bool public unlockTokensRequestMade = false;
    bool public unlockTokensRequestAccepted = false;

    event UnlockTokensRequestMade(IERC20 _token, uint256 _amount);
    event UnlockedTokens(IERC20 _token, uint256 _amount);

    constructor(
        IERC20 _tokenX,
        address _walletOwner,
        uint256 _unlockTokensAtTime
    ) {
        tokenX = _tokenX;
        walletOwner = _walletOwner;
        unlockTokensAtTime = _unlockTokensAtTime;
        transferOwnership(_walletOwner);
    }

    function lockTokens(uint256 _amount) external onlyOwner {
        tokenX.transferFrom(owner(), address(this), _amount);
    }

    function makeUnlockTokensRequest() external onlyOwner {
        unlockTokensRequestMade = true;
        emit UnlockTokensRequestMade(tokenX, tokenX.balanceOf(address(this)));
    }

    function approveUnlockTokensRequest() external onlyOwner {
        require(
            unlockTokensRequestMade,
            "Locker Owner has to make request to unlock tokens."
        );
        require(
            msg.sender == Ownable(factory).owner(),
            "You must be owner of presale factory to approve unlock tokens."
        );
        require(
            block.timestamp > unlockTokensAtTime,
            "Tokens will be unlocked soon."
        );

        unlockTokensRequestAccepted = true;

        tokenX.transfer(owner(), tokenX.balanceOf(address(this)));
        emit UnlockedTokens(tokenX, tokenX.balanceOf(address(this)));
    }

    function balance() public view returns (uint256) {
        return tokenX.balanceOf(address(this));
    }
}
