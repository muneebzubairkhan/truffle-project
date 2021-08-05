// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Presale.sol";

contract PresaleFactory {
    Presale[] public presales;

    function createERC20(
        IERC20 _tokenX,
        IERC20 _buyingToken,
        uint256 _rate,
        address _walletOwner,
        bool _onlyWhitelistedAllowed,
        uint256 _amountTokenXToBuyTokenX
    ) external {
        Presale presale = new Presale(
            _tokenX,
            _buyingToken,
            _rate,
            _walletOwner,
            _onlyWhitelistedAllowed,
            _amountTokenXToBuyTokenX
        );
        presales.push(presale);
    }

    function getPresales() external view returns (Presale[] memory) {
        return presales;
    }
}

/*

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
