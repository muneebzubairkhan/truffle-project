// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// functions: setRate, buyTokens...
contract Presale is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public tokenX; // People will buy tokenX
    IERC20 public buyingToken; // People will give buyingToken and get tokenX in return
    uint256 public tokenXSold = 0;
    uint256 public rate; // 3 = 3 000 000 000 000 000 000, 0.3 = 3 00 000 000 000 000 000 // 0.3 buyingToken = 1 TokenX
    uint256 public amountTokenXToBuyTokenX;
    address public walletOwner;

    mapping(address => bool) isWhitelisted;
    bool public onlyWhitelistedAllowed;

    event RateChanged(uint256 _newRate);

    constructor(
        IERC20 _tokenX,
        IERC20 _buyingToken,
        uint256 _rate,
        address _walletOwner,
        bool _onlyWhitelistedAllowed,
        uint256 _amountTokenXToBuyTokenX
    ) {
        tokenX = _tokenX;
        buyingToken = _buyingToken;
        rate = _rate;
        walletOwner = _walletOwner;
        onlyWhitelistedAllowed = _onlyWhitelistedAllowed;
        amountTokenXToBuyTokenX = _amountTokenXToBuyTokenX;
        transferOwnership(_walletOwner);
    }

    /// @notice user buys at rate of 0.3 then 33 BUSD or buyingToken will be deducted and 100 tokenX will be given
    function buyTokens(uint256 _tokens) external {
        if (onlyWhitelistedAllowed) {
            require(
                isWhitelisted[msg.sender],
                "You should become whitelisted to continue."
            );
        }
        require(
            amountTokenXToBuyTokenX >= tokenX.balanceOf(msg.sender),
            "You should have more amount of tokens."
        );

        tokenXSold += _tokens;
        uint256 price = (_tokens * rate) / 1e18;
        buyingToken.transferFrom(msg.sender, walletOwner, price);
        tokenX.transfer(msg.sender, _tokens); // try with _msgsender on truufle test and ethgas reporter
    }

    function ownerFunction_getLockedTokens(IERC20 _token) external onlyOwner {
        _token.transfer(owner(), _token.balanceOf(address(this)));
    }

    function ownerFunction_setRate(uint256 _rate) external onlyOwner {
        rate = _rate;
        emit RateChanged(_rate);
    }

    function addMultipleToWhitelist(address[] memory _addresses)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < _addresses.length; i++) {
            isWhitelisted[_addresses[i]] = true;
        }
    }

    function removeMultipleFromWhitelist(address[] memory _addresses)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < _addresses.length; i++) {
            isWhitelisted[_addresses[i]] = false;
        }
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
