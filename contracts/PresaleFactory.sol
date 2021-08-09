// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Presale.sol";

contract PresaleFactory is Ownable {
    Presale[] public presales;
    IERC20 public busd;

    /// @notice people can see if a presale belongs to this factory or not
    mapping(address => bool) public belongThisFactory;

    constructor(address _parentCompany, IERC20 _busd) {
        busd = _busd;
        transferOwnership(_parentCompany);
    }

    /// @dev users can create an ICO for erc20 from this function
    function createERC20(
        IERC20 _tokenX,
        IERC20 _lpTokenX,
        uint256 _rate,
        uint256 _tokenXToLock,
        uint256 _lpTokenXToLock,
        uint256 _tokenXToSell,
        uint256 _unlockAtTime,
        uint256 _amountTokenXToBuyTokenX,
        address _walletOwner,
        bool _onlyWhitelistedAllowed
    ) external {
        Presale presale = new Presale(
            _tokenX,
            _lpTokenX,
            busd,
            _rate,
            _walletOwner,
            owner(),
            _onlyWhitelistedAllowed,
            _amountTokenXToBuyTokenX,
            _unlockAtTime
        );

        belongThisFactory[address(presale)] = true;
        presales.push(presale);

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

    function getPresales() external view returns (Presale[] memory) {
        return presales;
    }

    function getPresales(uint256 _index, uint256 _amountToFetch)
        external
        view
        returns (Presale[] memory)
    {
        if (_index >= presales.length) return new Presale[](0);

        uint256 goto = _index + _amountToFetch;
        uint256 stopAt = goto >= presales.length ? presales.length : goto;

        Presale[] memory selectedPresales = new Presale[](goto - _index);
        for (uint256 i = _index; i < stopAt; i++) {
            selectedPresales[i] = (presales[i]);
        }
        return selectedPresales;
    }

    function getPresalesWithApproveFilter(
        uint256 _index,
        uint256 _amountToFetch,
        bool presaleIsApproved
    ) external view returns (Presale[] memory) {
        if (_index >= presales.length) return new Presale[](0);

        uint256 goto = _index + _amountToFetch;
        uint256 stopAt = goto >= presales.length ? presales.length : goto;

        Presale[] memory selectedPresales = new Presale[](goto - _index);
        for (uint256 i = _index; i < stopAt; i++) {
            Presale p = presales[i];
            if (presaleIsApproved == p.presaleIsApproved()) {
                selectedPresales[i] = presales[i];
            }
        }
        return selectedPresales;
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
