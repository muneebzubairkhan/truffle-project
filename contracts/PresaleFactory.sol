// SPDX-License-Identifier: MIT
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

    /// @notice users can create an ICO for erc20 from this function
    /// @dev we used _tokens[] because solidity gives error of deep stack if we not use it
    /// @param _tokens _tokens[0] is tokenX and _tokens[1] is lpTokenX and _tokens[2] is tokenToHold
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
    function createERC20Presale(
        IERC20[] memory _tokens,
        uint256[] memory uints,
        address _presaleEarningWallet,
        bool _onlyWhitelistedAllowed,
        address[] memory _whitelistAddresses,
        string memory _presaleMediaLinks
    ) external {
        Presale presale = new Presale(
            [_tokens[0], _tokens[1], _tokens[2], busd],
            _presaleEarningWallet,
            _whitelistAddresses,
            [
                uints[6],
                uints[7],
                uints[0],
                uints[5],
                uints[8],
                uints[9],
                uints[10]
            ],
            _onlyWhitelistedAllowed,
            _presaleMediaLinks
        );

        // presale belongs to this factory
        belongsToThisFactory[address(presale)] = true;

        // add presale to presales list
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

    function developers() public pure returns (string memory) {
        return
            "This smart contract is Made in Pakistan by Muneeb Zubair Khan, Whatsapp +923014440289, Telegram @thinkmuneeb, https://shield-launchpad.netlify.app/ and this UI is made by Abraham Peter, Whatsapp +923004702553, Telegram @Abrahampeterhash. Discord timon#1213. We did it with TrippyBlue and the team from ShieldNet.";
    }
}
