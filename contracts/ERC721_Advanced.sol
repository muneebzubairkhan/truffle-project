// Alpha Aliens
// https://MysteryBox.io
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";

interface OpenSea {
    function proxies(address) external view returns (address);
}

contract MysteryBox is ERC721A("MysteryBox", "MBA"), ERC721AQueryable {
    /// @notice purchase nft at 0.01 eth
    function purchaseTokens() external payable {
        require(_totalMinted() < 10000, "Sold Out!");
        _safeMint(msg.sender, msg.value / 0.01 ether);
    }

    /// @notice purchase nft for free
    function purchaseTokensFree() external {
        require(_totalMinted() < 2000, "Presale Sold Out!");
        _safeMint(msg.sender, 1);
    }

    function withdraw() external {
        payable(owner).transfer(address(this).balance);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://mysterybox.live/api/";
    }

    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {
        if (_operator == OpenSea(0xa5409ec958C83C3f309868babACA7c86DCB077c1).proxies(_owner)) return true;
        return super.isApprovedForAll(_owner, _operator);
    }
}
