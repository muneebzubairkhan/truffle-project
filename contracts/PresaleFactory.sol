// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Presale.sol";

contract PresaleFactory is Ownable {
    Presale[] public presales;
    IERC20 public busd;

    constructor(address _parentCompany, IERC20 _busd) {
        busd = _busd;
        transferOwnership(_parentCompany);
    }

    function createERC20(
        IERC20 _tokenX,
        IERC20 _lpTokenX,
        uint256 _rate,
        address _walletOwner,
        bool _onlyWhitelistedAllowed,
        uint256 _amountTokenXToBuyTokenX,
        uint256 _unlockAtTime
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
        presales.push(presale);
    }

    function getPresales() external view returns (Presale[] memory) {
        return presales;
    }
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


function getPresales(uint256 _index, uint256 _amountToFetch)
        external
        view
        returns (address[] memory)
    {
        address[] memory selectedPresales = new address[](_amountToFetch);
        for (
            uint256 i = _index;
            i < presales.length && i < _index + _amountToFetch;
            i++
        ) {
            selectedPresales[i] = (presales[i]);
        }
        return selectedPresales;
    }

*/
