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

pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Locker.sol";

contract Presale is Ownable {
    using SafeERC20 for IERC20;

    // tokenX = token which people will buy from presale
    IERC20 public busd; // People will give BUSD or buyingToken and get tokenX in return
    IERC20 public tokenX; // People will buy tokenX
    IERC20 public tokenToHold; // People hold this token to buy token X
    IERC20 public lpTokenX; // Owner of tokenX will lock lpTokenX to get their confidence
    Locker public tokenXLocker;
    Locker public lpTokenXLocker;

    uint256 public softcap;
    uint256 public hardcap;

    uint256 public tokenXSold = 0;
    uint256 public rate; // 3 = 3 000 000 000 000 000 000, 0.3 = 3 00 000 000 000 000 000 // 0.3 busd = 1 TokenX
    uint256 public amountTokenToHold;
    uint256 public presaleOpenAt;
    uint256 public presaleCloseAt;

    uint256 public participantsCount = 0;
    mapping(address => bool) private isParticipant;
    uint8 public tier = 1;
    address public presaleEarningWallet;
    address public factory;
    string public presaleMediaLinks; // tokenX owner will give his social media, photo, driving liscense images links.

    mapping(address => bool) public isWhitelisted;
    bool public onlyWhitelistedAllowed;
    bool public presaleIsBlacklisted = false;
    bool public presaleIsApproved = false;

    event AmountTokenToHoldChanged(uint256 _amountTokenToHold);
    event UnlockedUnsoldTokens(uint256 _tokens);

    struct Box {
        IERC20 tokenX;
        IERC20 lpTokenX;
        IERC20 tokenToHold;
        IERC20 busd;
        address presaleEarningWallet;
        uint256 hardcap;
        uint256 softcap;
        uint256 rate;
        uint256 amountTokenToHold;
        uint256 presaleOpenAt;
        uint256 presaleCloseAt;
        uint256 unlockTokensAt;
        bool onlyWhitelistedAllowed;
        address[] whitelistAddresses;
        string presaleMediaLinks;
    }

    constructor(Box memory __) {
        tokenX = __.tokenX;
        lpTokenX = __.lpTokenX;
        tokenToHold = __.tokenToHold;
        busd = __.busd;
        factory = msg.sender; // only trust those presales who address exist in factory contract // go to factory address and see presale address belong to that factory or not. use method: belongsToThisFactory

        hardcap = __.hardcap;
        softcap = __.softcap;
        rate = __.rate;
        presaleOpenAt = __.presaleOpenAt;
        presaleCloseAt = __.presaleCloseAt;
        amountTokenToHold = __.amountTokenToHold;
        presaleEarningWallet = __.presaleEarningWallet;

        onlyWhitelistedAllowed = __.onlyWhitelistedAllowed;

        presaleMediaLinks = __.presaleMediaLinks;

        if (__.onlyWhitelistedAllowed) {
            for (uint256 i = 0; i < __.whitelistAddresses.length; i++) {
                isWhitelisted[__.whitelistAddresses[i]] = true;
            }
        }

        tokenXLocker = new Locker(
            __.tokenX,
            __.presaleEarningWallet,
            __.unlockTokensAt
        );

        lpTokenXLocker = new Locker(
            __.lpTokenX,
            __.presaleEarningWallet,
            __.unlockTokensAt
        );

        transferOwnership(__.presaleEarningWallet);
    }

    /// @notice user buys at rate of 0.3 then 33 BUSD or buyingToken will be deducted and 100 tokenX will be given
    function buyTokens(uint256 _tokens) external {
        require(
            !presaleIsBlacklisted,
            "Presale is rejected by the parent network."
        );
        require(block.timestamp < presaleCloseAt, "Presale is closed.");
        require(
            presaleIsApproved,
            "Presale is not approved by the parent network."
        );
        require(
            tokenToHold.balanceOf(msg.sender) >= amountTokenToHold,
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

        // count participants
        if (!isParticipant[msg.sender]) {
            isParticipant[msg.sender] = true;
            participantsCount++;
        }

        tokenXSold += _tokens;
        busd.transferFrom(msg.sender, presaleEarningWallet, price);
        tokenX.transfer(msg.sender, _tokens); // try with _msgsender on truufle test and ethgas reporter
    }

    function ownerFunction_editOnlyWhitelistedAllowed(
        bool _onlyWhitelistedAllowed
    ) external onlyOwner {
        onlyWhitelistedAllowed = _onlyWhitelistedAllowed;
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

    function onlyOwnerFunction_setAmountTokenToHold(uint256 _amountTokenToHold)
        external
        onlyOwner
    {
        amountTokenToHold = _amountTokenToHold;
        emit AmountTokenToHoldChanged(_amountTokenToHold);
    }

    function onlyOwnerFunction_UnlockUnsoldTokens() external onlyOwner {
        uint256 contractBalance = tokenX.balanceOf(address(this));
        tokenX.transfer(msg.sender, contractBalance);
        emit UnlockedUnsoldTokens(contractBalance);
    }

    function onlyParentCompanyFunction_editPresaleIsApproved(
        bool _presaleIsApproved
    ) public {
        require(
            msg.sender == parentCompany(),
            "You must be parent company to edit value of presaleIsApproved."
        );
        presaleIsApproved = _presaleIsApproved;
    }

    function onlyParentCompanyFunction_editPresaleIsBlacklisted(
        bool _presaleIsBlacklisted
    ) public {
        require(
            msg.sender == parentCompany(),
            "You must be parent company to edit value of presaleIsBlacklisted."
        );
        presaleIsBlacklisted = _presaleIsBlacklisted;
    }

    function onlyParentCompanyFunction_editTier(uint8 _tier) public {
        require(
            msg.sender == parentCompany(),
            "You must be parent company to edit value of tier."
        );
        tier = _tier;
    }

    ////////////////////////////////////////////////////////////////
    //            ONLY PARENT COMPANY FUNCTIONS                   //
    ////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////
    //                  READ CONTRACT                             //
    ////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////
    //                  WRITE CONTRACT                            //
    ////////////////////////////////////////////////////////////////

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

        uint256[] memory uints = new uint256[](12);
        uints[0] = tokenX.totalSupply();
        uints[1] = tokenX.balanceOf(address(this));
        uints[2] = tokenXLocker.balance();
        uints[3] = tokenXLocker.unlockTokensAtTime();
        uints[4] = lpTokenX.balanceOf(address(this));
        uints[5] = lpTokenXLocker.balance();
        uints[6] = lpTokenXLocker.unlockTokensAtTime();
        uints[7] = tokenXSold;
        uints[8] = rate;
        uints[9] = amountTokenToHold;
        uints[10] = presaleCloseAt;
        uints[11] = tier;

        bool[] memory bools = new bool[](6);
        bools[0] = presaleIsBlacklisted;
        bools[1] = presaleIsApproved;

        bools[2] = tokenXLocker.unlockTokensRequestMade();
        bools[3] = tokenXLocker.unlockTokensRequestAccepted();
        bools[4] = lpTokenXLocker.unlockTokensRequestMade();
        bools[5] = lpTokenXLocker.unlockTokensRequestAccepted();

        return (addresses, uints, bools);
    }

    function parentCompany() public view returns (address) {
        return Ownable(factory).owner();
    }

    function AAA_developers() public pure returns (string memory) {
        return
            "Smart Contract belong to this DAPP: https://shield-launchpad.netlify.app/ Smart contract made in Pakistan by Muneeb Zubair Khan, Whatsapp +923014440289, Telegram @thinkmuneeb, The UI is made by Abraham Peter, Whatsapp +923004702553, Telegram @Abrahampeterhash. Discord timon#1213. Project done with TrippyBlue and ShieldNet Team.";
    }
}
