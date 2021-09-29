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
    ////////////////////////////////////////////////////////////////
    //                      VARIABLES                             //
    ////////////////////////////////////////////////////////////////

    using SafeERC20 for IERC20;

    IERC20 public busd; // People will give BUSD or buyingToken and get tokenX in return
    IERC20 public tokenX; // People will buy tokenX by giving their BUSD
    IERC20 public lpTokenX; // Owner of tokenX will lock lpTokenX to get their confidence
    IERC20 public tokenToHold; // People hold this token to buy token X
    Locker public tokenXLocker; //
    Locker public lpTokenXLocker;

    uint256 public softcap;
    uint256 public hardcap;

    uint256 public rate; // rate = 3 = 3 000 000 000 000 000 000, 0.3 = 3 00 000 000 000 000 000 // 0.3 busd = 1 TokenX
    uint256 public tokenXSold;
    uint256 public amountTokenToHold;

    uint256 public presaleOpenAt;
    uint256 public presaleCloseAt;

    uint256 public participantsCount = 0;

    mapping(address => bool) private isParticipant;

    mapping(address => bool) public isWhitelisted;

    // Bookkeeping like bank account
    mapping(address => uint256) public tokenXSoldBy;
    mapping(address => uint256) public tokenXBoughtBy;

    /// @notice The more trustworthy presale is the more presaleScore its has. presaleScore is assigned by the parent network only.
    uint8 public presaleScore = 1;

    address public factory;
    string public presaleMediaLinks; // tokenX owner will give his social media, photo, driving liscense images links.

    bool public presaleIsApproved;
    bool public presaleIsBlacklisted;
    bool public presaleIsCancelled;
    bool public onlyWhitelistedAllowed;

    event PresaleApproved(uint8 _presaleScore);
    event UnlockedUnsoldTokens(uint256 _tokens);
    event AmountTokenToHoldChanged(uint256 _amountTokenToHold);

    struct Box {
        IERC20 tokenX;
        IERC20 lpTokenX;
        IERC20 tokenToHold;
        IERC20 busd;
        //
        address presaleOwner;
        //
        uint256 rate;
        uint256 hardcap;
        uint256 softcap;
        uint256 amountTokenToHold;
        uint256 presaleOpenAt;
        uint256 presaleCloseAt;
        uint256 unlockTokensAt;
        //
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

        onlyWhitelistedAllowed = __.onlyWhitelistedAllowed;

        presaleMediaLinks = __.presaleMediaLinks;

        if (__.onlyWhitelistedAllowed) {
            for (uint256 i = 0; i < __.whitelistAddresses.length; i++) {
                isWhitelisted[__.whitelistAddresses[i]] = true;
            }
        }

        tokenXLocker = new Locker(
            __.tokenX,
            __.presaleOwner,
            __.unlockTokensAt
        );

        lpTokenXLocker = new Locker(
            __.lpTokenX,
            __.presaleOwner,
            __.unlockTokensAt
        );

        transferOwnership(__.presaleOwner);
    }

    ////////////////////////////////////////////////////////////////
    //                  WRITE CONTRACT                            //
    ////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////////
    //                FUNCTIONS FOR PUBLIC                        //
    ////////////////////////////////////////////////////////////////

    /// @notice user buys at rate of 0.3 then 33 BUSD will be deducted and 100 tokenX will be given
    function buyTokens(uint256 _tokens)
        external
        presaleOpen
        userIsAllowed
        presaleApproved
        presaleNotCancelled
        presaleNotBlacklisted
        userHasAmountTokenToHold
    {
        buyTokensBookkeeping(_tokens);

        uint256 price = (_tokens * rate) / 1e18;
        busd.transferFrom(msg.sender, address(this), price);
        tokenX.transfer(msg.sender, _tokens);
    }

    // user can only sell tokens from the wallet where they purchased.
    // we need to prevent token owner taking out funds by giving tokenX and getting BUSD
    function sellTokens(uint256 _tokens)
        external
        presaleCancelledOrPresaleEndedAndSoftcapNotReached
    {
        tokenXSoldBy[msg.sender] += _tokens;

        require(
            tokenXBoughtBy[msg.sender] >= tokenXSoldBy[msg.sender],
            "You have to sell tokens less or equal amount than you bought"
        );

        uint256 price = (_tokens * rate) / 1e18;
        busd.transfer(msg.sender, price);
        tokenX.transferFrom(msg.sender, address(this), _tokens);
    }

    ////////////////////////////////////////////////////////////////
    //            ONLY PARENT COMPANY FUNCTIONS                   //
    ////////////////////////////////////////////////////////////////

    modifier onlyParent() {
        require(
            msg.sender == parentCompany(),
            "You must be parent company to edit value"
        );
        _;
    }

    /// @notice Parent network will approve presale and assign a score to presale based on their photo, social media, driving liscense
    function onlyParent_editPresaleIsApproved(
        bool _presaleIsApproved,
        uint8 _presaleScore
    ) external onlyParent {
        presaleIsApproved = _presaleIsApproved;
        presaleScore = _presaleScore;
        emit PresaleApproved(_presaleScore);
    }

    /// @notice Parent network will assign a score to presale based on their photo, social media, driving liscense
    function onlyParent_editPresaleScore(uint8 _presaleScore)
        external
        onlyParent
    {
        presaleScore = _presaleScore;
    }

    function onlyParent_editPresaleIsBlacklisted(bool _presaleIsBlacklisted)
        external
        onlyParent
    {
        presaleIsBlacklisted = _presaleIsBlacklisted;
    }

    ////////////////////////////////////////////////////////////////
    //                 ONLY OWNER FUNCTIONS                       //
    ////////////////////////////////////////////////////////////////

    // todo
    // hardcapReached presaleEndedAndSoftcapReached
    function onlyOwner_withdrawBUSD()
        external
        onlyOwner
        presaleNotCancelled
        hardcapReachedOrPresaleEndedAndSoftcapReached
    {
        uint256 contractBalance = tokenX.balanceOf(address(this));
        tokenX.transfer(msg.sender, contractBalance);
    }

    function onlyOwner_unlockUnsoldTokens() external onlyOwner {
        uint256 contractBalance = tokenX.balanceOf(address(this));
        tokenX.transfer(msg.sender, contractBalance);
        emit UnlockedUnsoldTokens(contractBalance);
    }

    function onlyOwner_cancelPresale() external onlyOwner {
        require(!presaleIsCancelled, "Presale already cancelled");
        presaleIsCancelled = true;
    }

    function onlyOwner_setAmountTokenToHold(uint256 _amountTokenToHold)
        external
        onlyOwner
    {
        amountTokenToHold = _amountTokenToHold;
        emit AmountTokenToHoldChanged(_amountTokenToHold);
    }

    function onlyOwner_editOnlyWhitelistedAllowed(bool _onlyWhitelistedAllowed)
        external
        onlyOwner
    {
        onlyWhitelistedAllowed = _onlyWhitelistedAllowed;
    }

    /// @dev pass true to add to whitelist, pass false to remove from whitelist
    function onlyOwner_editWhitelist(address[] memory _addresses, bool _approve)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < _addresses.length; i++) {
            isWhitelisted[_addresses[i]] = _approve;
        }
    }

    ////////////////////////////////////////////////////////////////
    //                  READ CONTRACT                             //
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

        uint256[] memory uints = new uint256[](13);
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
        uints[10] = presaleOpenAt;
        uints[11] = presaleCloseAt;
        uints[12] = presaleScore;

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

    function AAA_developers() external pure returns (string memory) {
        return
            "Smart Contract belong to this DAPP: https://shield-launchpad.netlify.app/ Smart contract made in Pakistan by Muneeb Zubair Khan, Whatsapp +923014440289, Telegram @thinkmuneeb, The UI is made by Abraham Peter, Whatsapp +923004702553, Telegram @Abrahampeterhash. Discord timon#1213. Project done with TrippyBlue and ShieldNet Team.";
    }

    // helper functions

    function hardcapReached() public view returns (bool) {
        return tokenXSold >= hardcap;
    }

    function softcapReached() public view returns (bool) {
        return tokenXSold >= softcap;
    }

    function presaleEnded() public view returns (bool) {
        return block.timestamp > presaleCloseAt;
    }

    function presaleEndedAndSoftcapReached() public view returns (bool) {
        return presaleEnded() && softcapReached();
    }

    function presaleEndedAndSoftcapNotReached() public view returns (bool) {
        return presaleEnded() && !softcapReached();
    }

    // helper modifiers

    modifier presaleNotCancelled() {
        require(!presaleIsCancelled, "Presale should not be cancelled.");
        _;
    }

    modifier hardcapReachedOrPresaleEndedAndSoftcapReached() {
        require(
            hardcapReached() || presaleEndedAndSoftcapReached(),
            "Requirement: Hardcap Reached Or Presale Ended And Softcap Reached"
        );
        _;
    }

    modifier presaleOpen() {
        require(block.timestamp > presaleOpenAt, "Presale is not opened yet.");
        require(block.timestamp < presaleCloseAt, "Presale is closed.");
        _;
    }

    modifier presaleNotBlacklisted() {
        require(
            !presaleIsBlacklisted,
            "Presale is blacklisted by the parent network."
        );
        _;
    }

    modifier presaleApproved() {
        require(
            presaleIsApproved,
            "Presale is not approved by the parent network."
        );
        _;
    }

    modifier userHasAmountTokenToHold() {
        // need to code these require statements in UI, so users do not get exceptions on metamask wallet
        require(
            tokenToHold.balanceOf(msg.sender) >= amountTokenToHold,
            "You need to hold tokens to buy from presale."
        );
        _;
    }

    modifier userIsAllowed() {
        if (onlyWhitelistedAllowed) {
            require(
                isWhitelisted[msg.sender],
                "You should become whitelisted to continue."
            );
        }
        _;
    }

    modifier presaleCancelledOrPresaleEndedAndSoftcapNotReached() {
        require(
            presaleIsCancelled || presaleEndedAndSoftcapNotReached(),
            "Presale should be cancelled or Presale should be ended and softcap should not met"
        );
        _;
    }

    // helper function private
    function buyTokensBookkeeping(uint256 _tokens) private {
        // count tokenXSold
        tokenXSold += _tokens;

        // count tokenXBoughtBy each address, so we can return BUSD if they want
        tokenXBoughtBy[msg.sender] += _tokens;

        // count participants
        if (!isParticipant[msg.sender]) {
            isParticipant[msg.sender] = true;
            participantsCount++;
        }
    }
}
