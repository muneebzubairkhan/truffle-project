// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Locker.sol";

// functions: setRate, buyTokens...
// Presale is Locker
contract Presale is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public busd; // People will give BUSD or buyingToken and get tokenX in return
    IERC20 public tokenX; // People will buy tokenX
    Locker public tokenXLocker;
    Locker public tokenXLPLocker;
    uint256 public tokenXSold = 0;
    uint256 public rate; // 3 = 3 000 000 000 000 000 000, 0.3 = 3 00 000 000 000 000 000 // 0.3 busd = 1 TokenX
    uint256 public amountTokenXToBuyTokenX;
    address public walletOwner;
    address public parentCompany;
    address public factory;

    mapping(address => bool) isWhitelisted;
    bool public onlyWhitelistedAllowed;
    bool public presaleIsApproved = false;
    bool public presaleIsGenuine = true;

    event RateChanged(uint256 _newRate);

    constructor(
        IERC20 _tokenX,
        IERC20 _lpTokenX,
        IERC20 _busd,
        uint256 _rate,
        address _walletOwner,
        address _parentCompany,
        bool _onlyWhitelistedAllowed,
        uint256 _amountTokenXToBuyTokenX,
        uint256 _unlockAtTime
    ) {
        tokenX = _tokenX;
        busd = _busd;
        factory = msg.sender; // only trust those presales who address exist in factory contract
        rate = _rate;
        walletOwner = _walletOwner;
        onlyWhitelistedAllowed = _onlyWhitelistedAllowed;
        amountTokenXToBuyTokenX = _amountTokenXToBuyTokenX;
        parentCompany = _parentCompany;

        tokenXLocker = new Locker(_tokenX, _walletOwner, _unlockAtTime);
        tokenXLPLocker = new Locker(_lpTokenX, _walletOwner, _unlockAtTime);
        transferOwnership(_walletOwner);
    }

    /// @notice user buys at rate of 0.3 then 33 BUSD or buyingToken will be deducted and 100 tokenX will be given
    function buyTokens(uint256 _tokens) external {
        require(
            presaleIsApproved,
            "Presale is not approved by the parent network."
        );
        require(
            presaleIsGenuine,
            "Presale is marked as spam by the parent network."
        );
        require(
            tokenX.balanceOf(msg.sender) >= amountTokenXToBuyTokenX,
            "You should have more amount of tokens."
        );

        if (onlyWhitelistedAllowed) {
            require(
                isWhitelisted[msg.sender],
                "You should become whitelisted to continue."
            );
        }

        tokenXSold += _tokens;
        uint256 price = (_tokens * rate) / 1e18;
        busd.transferFrom(msg.sender, walletOwner, price);
        tokenX.transfer(msg.sender, _tokens); // try with _msgsender on truufle test and ethgas reporter
    }

    /// @dev pass true to add to whitelist, pass false to remove from whitelist
    function ownerFunction_editWhitelist(
        address[] memory _addresses,
        bool _approve
    ) external onlyOwner {
        for (uint256 i = 0; i < _addresses.length; i++) {
            isWhitelisted[_addresses[i]] = _approve;
        }
    }

    function onlyOwnerFunction_setRate(uint256 _rate) external onlyOwner {
        rate = _rate;
        emit RateChanged(_rate);
    }

    function onlyParentCompanyFunction_editPresaleIsApproved(
        bool _presaleIsApproved
    ) public {
        require(
            msg.sender == parentCompany,
            "You must be parent company to edit value of presaleIsApproved."
        );
        presaleIsApproved = _presaleIsApproved;
    }

    function onlyParentCompanyFunction_editPresaleIsGenuine(
        bool _presaleIsGenuine
    ) public {
        require(
            msg.sender == parentCompany,
            "You must be parent company to edit value of presaleIsApproved."
        );
        presaleIsGenuine = _presaleIsGenuine;
    }
}

/*
notes:

first implemet core logic
// nonreentrant modifier ? I think its only need in case external calls are not at end

update variables by owner of tokenX and shieldNetwork
be ware of ownerships and mint to proper owners
as different factory calling will be used
natspec annotations, author Muneeb Khan
mention comments see sir written contract

function thisContractIsMadeBy_TheHash.io() external returns(memory string) {
    return "Hi if you want to develop a smart contract you can contact on telegram @thinkmuneeb";
}

cosmetics
function ownerFunction_unlockTokens(IERC20 _token) external onlyOwner {
    _token.transfer(owner(), _token.balanceOf(address(this)));
}
fallback send eth to owner
can send erc721 erc1155 to owner

getWhitelist addresses  method?
presaleIsApproved = false; get approval after changing rate ?


// when I do something crazy in code I feel that it will be caught in auidt. or I need to fix it. Or use some other api.
        // i.e lock token in wallet at time of its creation in single go
        
*/
