// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./Presale.sol";

contract PresaleFactory is Ownable {
    mapping(uint256 => Presale) public presales;
    uint256 public lastPresaleIndex = 0;

    IERC20 public busd;

    /// @notice people can see if a presale belongs to this factory or not
    mapping(address => bool) public belongThisFactory;
    mapping(IERC20 => Presale) public presaleOf;

    constructor(address _parentCompany, IERC20 _busd) {
        busd = _busd;
        transferOwnership(_parentCompany);
    }

    /// @dev users can create an ICO for erc20 from this function
    function createERC20Presale(
        IERC20 _tokenX,
        IERC20 _lpTokenX,
        uint256 _rate,
        uint256 _tokenXToLock,
        uint256 _lpTokenXToLock,
        uint256 _tokenXToSell,
        uint256 _unlockAtTime,
        uint256 _amountTokenXToBuyTokenX,
        address _presaleEarningWallet,
        bool _onlyWhitelistedAllowed,
        address[] memory _whitelistAddresses
    ) external {
        require(
            address(presaleOf[_tokenX]) == address(0),
            "Presale already exist for this token"
        );

        Presale presale = new Presale(
            _tokenX,
            _lpTokenX,
            busd,
            _rate,
            _presaleEarningWallet,
            owner(),
            _onlyWhitelistedAllowed,
            _amountTokenXToBuyTokenX,
            _unlockAtTime,
            _whitelistAddresses
        );

        presaleOf[_tokenX] = presale;
        belongThisFactory[address(presale)] = true;
        presales[lastPresaleIndex++] = presale;

        _tokenX.transferFrom(
            msg.sender,
            address(presale.tokenXLocker()),
            _tokenXToLock
        );
        _lpTokenX.transferFrom(
            msg.sender,
            address(presale.lpTokenXLocker()),
            _lpTokenXToLock
        );
        _tokenX.transferFrom(msg.sender, address(presale), _tokenXToSell);
    }

    // function getPresales() external view returns (Presale[] memory) {
    //     return presales;
    // }

    function getSomePresales(uint256 _index, uint256 _amountToFetch)
        external
        view
        returns (Presale[] memory)
    {
        // if (_index >= presales.length) return new Presale[](0);

        uint256 selectedCount = 0;
        uint256 currIndex = _index;
        Presale[] memory selectedPresales = new Presale[](_amountToFetch);
        for (uint256 i = 0; i < _amountToFetch; i++) {
            selectedPresales[i] = presales[currIndex++];

            if (address(presales[currIndex]) != address(0)) {
                selectedCount++;
            }
        }

        uint256 someI = 0;
        Presale[] memory resPresales = new Presale[](selectedCount + 1);
        // traverse in selectedPresales to get only addresses that are not 0x0
        for (uint256 i = 0; i < _amountToFetch; i++) {
            if (address(selectedPresales[i]) != address(0))
                resPresales[someI++] = selectedPresales[i];
        }

        return resPresales;
    }

    function getOnePresale(uint256 index)
        external
        view
        returns (uint256, uint256)
    {
        Presale p = presales[index];
        return (p.rate(), p.tier());
    }
    // see that 10 size array returns what on 3 elems in it, function getStopPoint private returns (uint256) {}
}

/*
notes:
getAddresIsTrustedOrNot
get trusted presales
get approved presales
get presales of a specific person
get presales with unlock liquidity request
get presale which wan to be approved
get locked amount of a presale, (compare run time total vs save total on each transaction)
write multiple presales...
Plus more...




*/
