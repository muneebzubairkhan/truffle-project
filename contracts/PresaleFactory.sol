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
        address tokenX;
        address lpTokenX;
        address tokenToHold;
        uint256 rate;
        uint256 tokenXToLock;
        uint256 lpTokenXToLock;
        uint256 tokenXToSell;
        uint256 unlockAtTime;
        uint256 amountTokenXToBuyTokenX;
        uint256 hardcap;
        uint256 softcap;
        uint256 presaleOpenAt;
        uint256 presaleCloseAt;
        uint256 unlockTokensAt;
        uint256[] someArr;
    }

    /// @notice users can create an ICO for erc20 from this function
    /// @dev we used _tokens[] because solidity gives error of deep stack if we not use it
    /*
        _tokens
        _tokens[0] tokenX
        _tokens[1] lpTokenX
        _tokens[2] tokenToHold

        uints:
        0 uint256 _rate,
        1 uint256 _tokenXToLock,
        2 uint256 _lpTokenXToLock,
        3 uint256 _tokenXToSell,
        4 uint256 _unlockAtTime,
        5 uint256 _amountTokenXToBuyTokenX,
        6 uint256 _hardcap,
        7 uint256 _softcap,
        8 uint256 _presaleOpenAt,
        9 uint256 _presaleCloseAt,
        10 uint256 _unlockTokensAt,
    */

    function B() external {}

    function A() external {}

    function checkBox(Box memory __) external {}

    function createERC20Presale(
        IERC20[] memory _tokens,
        uint256[] memory uints,
        address _presaleEarningWallet,
        bool _onlyWhitelistedAllowed,
        address[] memory _whitelistAddresses,
        string memory _presaleMediaLinks
    ) external {
        Presale presale = new Presale(
            Presale.Box(
                _tokens[0],
                _tokens[1],
                _tokens[2],
                busd,
                _presaleEarningWallet,
                uints[6],
                uints[7],
                uints[0],
                uints[5],
                uints[8],
                uints[9],
                uints[10],
                _onlyWhitelistedAllowed,
                _whitelistAddresses,
                _presaleMediaLinks
            )
        );

        // set that this presale belongs to this factory
        belongsToThisFactory[address(presale)] = true;

        // add presale to the presales list
        presales[lastPresaleIndex++] = presale;

        _tokens[0].transferFrom(msg.sender, address(presale), uints[3]);
        _tokens[0].transferFrom(
            msg.sender,
            address(presale.tokenXLocker()),
            uints[1]
        );
        _tokens[1].transferFrom(
            msg.sender,
            address(presale.lpTokenXLocker()),
            uints[2]
        );
    }

    /// @dev returns presales address and their corresponding token addresses
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
