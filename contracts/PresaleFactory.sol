// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./Presale.sol";

contract PresaleFactory is Ownable {
    bool public test = false;

    function setTest(bool ok) external {
        test = ok;
    }

    mapping(uint256 => Presale) public presales;
    uint256 public lastPresaleIndex = 0;
    IERC20 public busd;

    /// @notice people can see if a presale belongs to this factory or not
    mapping(address => bool) public belongsToThisFactory;
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
        // require(
        //     address(presaleOf[_tokenX]) == address(0),
        //     "Presale already exist for this token"
        // );

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
        belongsToThisFactory[address(presale)] = true;
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

    function getSelectedItems(
        Presale[] memory tempPresales,
        uint256 selectedCount
    ) private pure returns (Presale[] memory) {
        uint256 someI = 0;
        Presale[] memory selectedPresales = new Presale[](selectedCount);

        // traverse in tempPresales addresses to get only addresses that are not 0x0
        for (uint256 i = 0; i < tempPresales.length; i++) {
            if (address(tempPresales[i]) != address(0))
                selectedPresales[someI++] = tempPresales[i];
        }

        return selectedPresales;
    }

    function getPresales(uint256 _index, uint256 _amountToFetch)
        external
        view
        returns (Presale[] memory)
    {
        uint256 selectedCount = 0;
        uint256 currIndex = _index;
        Presale[] memory tempPresales = new Presale[](_amountToFetch);
        for (uint256 i = 0; i < _amountToFetch; i++) {
            if (address(presales[currIndex]) != address(0)) {
                tempPresales[i] = presales[currIndex++];
                selectedCount++;
            }
        }

        return getSelectedItems(tempPresales, selectedCount);
    }

    function getPresales(
        uint256 _index,
        uint256 _amountToFetch,
        bool _approvedValue // this method can be used to get approved and not approved presales
    ) external view returns (Presale[] memory) {
        uint256 selectedCount = 0;
        uint256 currIndex = _index;
        Presale[] memory tempPresales = new Presale[](_amountToFetch);
        for (uint256 i = 0; i < _amountToFetch; i++) {
            if (
                address(presales[currIndex]) != address(0) &&
                presales[currIndex].presaleIsApproved() == _approvedValue
            ) {
                tempPresales[i] = presales[currIndex++];
                selectedCount++;
            }
        }

        return getSelectedItems(tempPresales, selectedCount);
    }

    function getPresales(
        uint256 _index,
        uint256 _amountToFetch,
        uint256 _tier // this method can be used to get tier 1,2,3 presales
    ) external view returns (Presale[] memory) {
        uint256 selectedCount = 0;
        uint256 currIndex = _index;
        Presale[] memory tempPresales = new Presale[](_amountToFetch);
        for (uint256 i = 0; i < _amountToFetch; i++) {
            if (
                address(presales[currIndex]) != address(0) &&
                presales[currIndex].tier() == _tier
            ) {
                tempPresales[i] = presales[currIndex++];
                selectedCount++;
            }
        }

        return getSelectedItems(tempPresales, selectedCount);
    }

    function getPresalesAppliedForClosing(
        uint256 _index,
        uint256 _amountToFetch
    ) external view returns (Presale[] memory) {
        uint256 selectedCount = 0;
        uint256 currIndex = _index;
        Presale[] memory tempPresales = new Presale[](_amountToFetch);
        for (uint256 i = 0; i < _amountToFetch; i++) {
            if (
                address(presales[currIndex]) != address(0) &&
                presales[currIndex].presaleAppliedForClosing() == true
            ) {
                tempPresales[i] = presales[currIndex++];
                selectedCount++;
            }
        }

        return getSelectedItems(tempPresales, selectedCount);
    }

    function getPresales(
        uint256 _index,
        uint256 _amountToFetch,
        address _owner // this method can be used to get _owner's presales
    ) external view returns (Presale[] memory) {
        uint256 selectedCount = 0;
        uint256 currIndex = _index;
        Presale[] memory tempPresales = new Presale[](_amountToFetch);
        for (uint256 i = 0; i < _amountToFetch; i++) {
            if (
                address(presales[currIndex]) != address(0) &&
                presales[currIndex].owner() == _owner
            ) {
                tempPresales[i] = presales[currIndex++];
                selectedCount++;
            }
        }

        return getSelectedItems(tempPresales, selectedCount);
    }

    // func return all rates of 50 presales

    // see that 10 size array returns what on 3 elems in it, function getStopPoint private returns (uint256) {}
}

/*


    // uint256,
    // uint256,
    // uint256,
    // uint256,
    // uint256,
    // uint256,
    // uint8,
    // bool,
    // bool,
    // bool



notes:
getAddresIsTrustedOrNot
get approved presales
get not approved presales (for admin)
get rejected presales (for admin)
get presales of a specific person
// get presales with unlock liquidity request
disbanding projects
get presale which wan to be approved
get locked amount of a presale, (compare run time total vs save total on each transaction)
write multiple presales...
Plus more...




*/
