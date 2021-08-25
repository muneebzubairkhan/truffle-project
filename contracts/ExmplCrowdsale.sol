// contracts/ExmplCrowdsale.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.5.5;

import "@openzeppelin/contracts/crowdsale/Crowdsale.sol";
import "@openzeppelin/contracts/crowdsale/distribution/PostDeliveryCrowdsale.sol";
import "@openzeppelin/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "@openzeppelin/contracts/crowdsale/validation/TimedCrowdsale.sol";

/**
 * @title ExmplCrowdsale
 * @dev Formed and tested crowdsale.
 */
contract ExmplCrowdsale is
    Crowdsale,
    CappedCrowdsale,
    TimedCrowdsale,
    PostDeliveryCrowdsale
{
    constructor(
        uint256 rate,
        address payable wallet,
        IERC20 token,
        uint256 cap, // total cap, in wei
        uint256 openingTime, // opening time in unix epoch seconds
        uint256 closingTime // closing time in unix epoch seconds
    )
        public
        PostDeliveryCrowdsale()
        Crowdsale(rate, wallet, token)
        CappedCrowdsale(cap)
        TimedCrowdsale(openingTime, closingTime)
    {}
}
