// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
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
    IERC20 public lpTokenX; // Owner of tokenX will lock lpTokenX to get their confidence
    Locker public tokenXLocker;
    Locker public lpTokenXLocker;
    uint256 public tokenXSold = 0;
    uint256 public rate; // 3 = 3 000 000 000 000 000 000, 0.3 = 3 00 000 000 000 000 000 // 0.3 busd = 1 TokenX
    uint256 public amountTokenXToBuyTokenX;
    uint256 public presaleClosedAt = type(uint256).max;
    uint8 public tier = 1;
    address public presaleEarningWallet;
    address public parentCompany;
    address public factory;

    mapping(address => bool) isWhitelisted;
    bool public onlyWhitelistedAllowed;
    bool public presaleIsRejected = false;
    bool public presaleIsApproved = false;
    bool public presaleAppliedForClosing = false;

    event RateChanged(uint256 _newRate);
    event PresaleClosed();

    constructor(
        IERC20 _tokenX,
        IERC20 _lpTokenX,
        IERC20 _busd,
        uint256 _rate,
        address _presaleEarningWallet,
        address _parentCompany,
        bool _onlyWhitelistedAllowed,
        uint256 _amountTokenXToBuyTokenX,
        uint256 _unlockAtTime,
        address[] memory _whitelistAddresses
    ) {
        tokenX = _tokenX;
        lpTokenX = _lpTokenX;
        busd = _busd;
        factory = msg.sender; // only trust those presales who address exist in factory contract // go to factory address and see presale address belong to that factory or not. use method: belongsToThisFactory
        rate = _rate;
        presaleEarningWallet = _presaleEarningWallet;
        onlyWhitelistedAllowed = _onlyWhitelistedAllowed;
        amountTokenXToBuyTokenX = _amountTokenXToBuyTokenX;
        parentCompany = _parentCompany;

        if (_onlyWhitelistedAllowed) {
            for (uint256 i = 0; i < _whitelistAddresses.length; i++) {
                isWhitelisted[_whitelistAddresses[i]] = true;
            }
        }

        transferOwnership(_presaleEarningWallet);
    }

    /// @notice user buys at rate of 0.3 then 33 BUSD or buyingToken will be deducted and 100 tokenX will be given
    function buyTokens(uint256 _tokens) external {
        require(
            !presaleIsRejected,
            "Presale is rejected by the parent network."
        );
        require(block.timestamp < presaleClosedAt, "Presale is closed.");
        require(
            presaleIsApproved,
            "Presale is not approved by the parent network."
        );
        require(
            tokenX.balanceOf(msg.sender) >= amountTokenXToBuyTokenX,
            "You need to hold tokens to buy them from presale."
        );

        uint256 price = (_tokens * rate) / 1e18;
        require(
            busd.balanceOf(msg.sender) >= price,
            "You have less BUSD available."
        );

        if (onlyWhitelistedAllowed) {
            require(
                isWhitelisted[msg.sender],
                "You should become whitelisted to continue."
            );
        }

        tokenXSold += _tokens;
        busd.transferFrom(msg.sender, presaleEarningWallet, price);
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

    function onlyOwnerFunction_closePresale(uint8 _months) external onlyOwner {
        require(
            _months >= 1 && _months <= 3,
            "Presale closing period can be 1 to 3 months."
        );
        presaleAppliedForClosing = presaleAppliedForClosing;
        presaleClosedAt = block.timestamp + _months * 30 days;
        emit PresaleClosed();
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

    function onlyParentCompanyFunction_editPresaleIsRejected(
        bool _presaleIsRejected
    ) public {
        require(
            msg.sender == parentCompany,
            "You must be parent company to edit value of presaleIsRejected."
        );
        presaleIsRejected = _presaleIsRejected;
    }

    function onlyParentCompanyFunction_editTier(uint8 _tier) public {
        require(
            msg.sender == parentCompany,
            "You must be parent company to edit value of tier."
        );
        tier = _tier;
    }

    function getPresaleDetails()
        external
        view
        returns (
            address[] memory,
            uint256[] memory,
            bool[] memory
        )
    {
        address[] memory addresses = new address[](4);
        addresses[0] = address(tokenX);
        addresses[1] = address(lpTokenX);
        addresses[2] = address(tokenXLocker);
        addresses[3] = address(lpTokenXLocker);
        uint256[] memory uints = new uint256[](9);
        uints[0] = tokenX.balanceOf(address(this));
        uints[1] = lpTokenX.balanceOf(address(this));
        uints[2] = tokenXLocker.balance();
        uints[3] = lpTokenXLocker.balance();
        uints[4] = tokenXSold;
        uints[5] = rate;
        uints[6] = amountTokenXToBuyTokenX;
        uints[7] = presaleClosedAt;
        uints[8] = tier;
        bool[] memory bools = new bool[](3);
        bools[0] = presaleIsRejected;
        bools[1] = presaleIsApproved;
        bools[2] = presaleAppliedForClosing;

        return (addresses, uints, bools);
    }

    function setTokenXLocker(Locker _tokenXLocker) external {
        require(msg.sender == factory, "Only factory can change locker");
        tokenXLocker = _tokenXLocker;
    }

    function setLpTokenXLocker(Locker _lpTokenXLocker) external {
        require(msg.sender == factory, "Only factory can change locker");
        lpTokenXLocker = _lpTokenXLocker;
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
