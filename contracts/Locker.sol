// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// functions: lockTokens, unlockTokens...
contract Locker is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public tokenX;
    address public walletOwner;
    uint256 public unlockTokensAtTime;
    bool public unlockTokensRequestMade = false;
    bool public unlockTokensRequestAccepted = false;

    event UnlockedTokens(address _token, uint256 _amount);

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
        // make event
    }

    function acceptUnlockTokensRequest() external onlyOwner {
        unlockTokensRequestAccepted = true;
        // make event
    }

    function unlockTokens() external onlyOwner {
        require(
            unlockTokensRequestMade,
            "Please make a request to unlock tokens."
        );
        require(
            unlockTokensRequestAccepted,
            "Please wait till the approval to unlock tokens."
        );
        require(
            block.timestamp > unlockTokensAtTime,
            "Tokens will be unlocked soon."
        );
        tokenX.transfer(owner(), tokenX.balanceOf(address(this)));
    }
}

/*

const res = await addFromWeb(1,2)
if(res === null){

}
else{
    console.log('res: ', res);
}

const someThing = newFunc();
someThing()

const p = {
    name: "ali",
    address: {
        city: "Lahore",
        street: "16",
        region: {
            time: "10"
        }
    }
}

p.name
p.address.city
console.log('time: ', p.address.region.time);

function thisContractIsMadeBy_TheHash.io() external returns(memory string) {
    return "Hi if you want to develop a smart contract you can contact on telegram @thinkmuneeb";
}

update variables by owner of tokenX and shieldNetwork
be ware of ownerships and mint to proper owners
as different factory calling will be used
natspec annotations, author Muneeb Khan
mention comments see sir written contract

*/
