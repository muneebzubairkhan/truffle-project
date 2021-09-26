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
import "./Presale.sol";

interface IName {
    function name() external view returns (string memory);
}

interface ISymbol {
    function symbol() external view returns (string memory);
}

contract PresaleFactory is Ownable {
    mapping(uint256 => Presale) public presales;
    uint256 public lastPresaleIndex = 0;
    IERC20 public busd;

    /// @notice people can see if a presale belongs to this factory or not
    mapping(address => bool) public belongsToThisFactory;

    constructor(address _parentCompany, IERC20 _busd) {
        busd = _busd;
        transferOwnership(_parentCompany);
    }

    struct Box {
        IERC20 tokenX;
        IERC20 lpTokenX;
        IERC20 tokenToHold;
        //
        address presaleEarningWallet;
        //
        uint256 rate;
        uint256 tokenXToLock;
        uint256 lpTokenXToLock;
        uint256 unlockAtTime;
        uint256 amountTokenToHold;
        uint256 hardcap;
        uint256 softcap;
        uint256 presaleOpenAt;
        uint256 presaleCloseAt;
        uint256 unlockTokensAt;
        //
        bool onlyWhitelistedAllowed;
        //
        address[] whitelistAddresses;
        //
        string presaleMediaLinks;
    }

    /// @notice users can create an ICO for erc20 from this function
    /// @dev we used struct Box because solidity gives error of deep stack if we not use it
    function createERC20Presale(Box memory __) external {
        Presale presale = new Presale(
            Presale.Box(
                __.tokenX,
                __.lpTokenX,
                __.tokenToHold,
                busd,
                __.presaleEarningWallet,
                __.hardcap,
                __.softcap,
                __.rate,
                __.amountTokenToHold,
                __.presaleOpenAt,
                __.presaleCloseAt,
                __.unlockTokensAt,
                __.onlyWhitelistedAllowed,
                __.whitelistAddresses,
                __.presaleMediaLinks
            )
        );

        // set that this presale belongs to this factory
        belongsToThisFactory[address(presale)] = true;

        // add presale to the presales list
        presales[lastPresaleIndex++] = presale;

        __.tokenX.transferFrom(msg.sender, address(presale), __.hardcap);
        __.tokenX.transferFrom(
            msg.sender,
            address(presale.tokenXLocker()),
            __.tokenXToLock
        );
        __.lpTokenX.transferFrom(
            msg.sender,
            address(presale.lpTokenXLocker()),
            __.lpTokenXToLock
        );
    }

    ////////////////////////////////////////////////////////////////
    //                  READ CONTRACT                             //
    ////////////////////////////////////////////////////////////////

    /// @dev returns presales address and their corresponding token addresses
    /// token addresses needed to get token name in multicall
    function getSelectedItems(
        Presale[] memory tempPresales, // search results temp presales list
        uint256 selectedCount
    ) private view returns (Presale[] memory, IERC20[] memory) {
        uint256 someI = 0;
        Presale[] memory selectedPresales = new Presale[](selectedCount);
        IERC20[] memory selectedPresalesTokens = new IERC20[](selectedCount);

        // traverse in tempPresales addresses to get only addresses that are not 0x0
        for (uint256 i = 0; i < tempPresales.length; i++) {
            if (address(tempPresales[i]) != address(0)) {
                selectedPresales[someI] = tempPresales[i];
                selectedPresalesTokens[someI++] = tempPresales[i].tokenX();
            }
        }

        return (selectedPresales, selectedPresalesTokens);
    }

    function getPresales(uint256 _index, uint256 _amountToFetch)
        external
        view
        returns (Presale[] memory, IERC20[] memory)
    {
        uint256 selectedCount = 0;
        uint256 currIndex = _index;
        Presale[] memory tempPresales = new Presale[](_amountToFetch);
        for (uint256 i = 0; i < _amountToFetch; i++) {
            if (address(presales[currIndex]) != address(0)) {
                tempPresales[i] = presales[currIndex++];
                selectedCount++;
            } else {
                tempPresales[i] = Presale(address(0));
            }
        }

        return getSelectedItems(tempPresales, selectedCount);
    }

    function getPresaleDetails(address _presale)
        external
        view
        returns (
            address[] memory,
            uint256[] memory,
            bool[] memory
        )
    {
        return Presale(_presale).getPresaleDetails();
    }

    function getTokenName(address _token)
        public
        view
        returns (string memory name)
    {
        return IName(_token).name();
    }

    function getTokenSymbol(address _token)
        public
        view
        returns (string memory symbol)
    {
        return ISymbol(_token).symbol();
    }

    function getPresaleMediaLinks(Presale _presale)
        public
        view
        returns (string memory symbol)
    {
        return _presale.presaleMediaLinks();
    }

    function AAA_developers() public pure returns (string memory) {
        return
            "Smart Contract belong to this DAPP: https://shield-launchpad.netlify.app/ Smart contract made in Pakistan by Muneeb Zubair Khan, Whatsapp +923014440289, Telegram @thinkmuneeb, The UI is made by Abraham Peter, Whatsapp +923004702553, Telegram @Abrahampeterhash. Discord timon#1213. Project done with TrippyBlue and ShieldNet Team.";
    }
}
