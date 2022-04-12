// Boredsone is The First Metaverse Theme Park!

// Website:    https://boredsone.com/
// OpenSea:    https://opensea.io/collection/boredsone/
// Discord:    https://discord.com/invite/boredsone
// Instagram:  https://www.instagram.com/boredsone/
// Twitter:    https://twitter.com/Boredsone
// Youtube:    https://www.youtube.com/watch?v=fmKltVVaVeI

// 88888888ba                                                 88                                                   
// 88      "8b                                                88                                                   
// 88      ,8P                                                88                                                   
// 88aaaaaa8P'   ,adPPYba,   8b,dPPYba,   ,adPPYba,   ,adPPYb,88  ,adPPYba,   ,adPPYba,   8b,dPPYba,    ,adPPYba,  
// 88""""""8b,  a8"     "8a  88P'   "Y8  a8P_____88  a8"    `Y88  I8[    ""  a8"     "8a  88P'   `"8a  a8P_____88  
// 88      `8b  8b       d8  88          8PP"""""""  8b       88   `"Y8ba,   8b       d8  88       88  8PP"""""""  
// 88      a8P  "8a,   ,a8"  88          "8b,   ,aa  "8a,   ,d88  aa    ]8I  "8a,   ,a8"  88       88  "8b,   ,aa  
// 88888888P"    `"YbbdP"'   88           `"Ybbd8"'   `"8bbdP"Y8  `"YbbdP"'   `"YbbdP"'   88       88   `"Ybbd8"'  
                                                                                                                

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";

contract Boredsone is ERC721A("Boredsone", "BS"), ERC721ABurnable, ERC2981, Ownable, ReentrancyGuard {
    string baseURI = "ipfs://QmTePqY26AcTBNzThaJdSyobDtJRJpDx7ime9m81ji1iXV/";
    uint256 saleActiveTime = type(uint256).max;

    uint256 constant maxSupply = 9999;
    uint256 reservedSupply = 450;

    uint256 itemPrice = 1 ether;

    constructor() {
        _setDefaultRoyalty(msg.sender, 3_00); // 3.00%
    }

    /// @notice Purchase multiple NFTs at once
    function purchaseTokens(uint256 _howMany) external payable nonReentrant {
        // mint nfts
        _safeMint(msg.sender, _howMany);

        // Pay the price
        require(msg.value == _howMany * itemPrice, "Send correct amount of ETH");

        // full fill some requirements
        require(totalSupply() + reservedSupply <= maxSupply, "Try mint less");
        require(tx.origin == msg.sender, "The caller is a contract");
        require(block.timestamp > saleActiveTime, "Sale is not active");

        require(_howMany >= 1 && _howMany <= 50, "Mint min 1, max 50");
    }

    /// @notice Owner can withdraw from here
    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    /// @notice Change price in case of ETH price changes too much
    function setPrice(uint256 _newPrice) external onlyOwner {
        itemPrice = _newPrice;
    }

    /// @notice set sale active time
    function setSaleActiveTime(uint256 _saleActiveTime) external onlyOwner {
        saleActiveTime = _saleActiveTime;
    }

    /// @notice set reservedSupply
    function setReservedSupply(uint256 _reservedSupply) external onlyOwner {
        require(_reservedSupply <= maxSupply, "put a number less than max supply");
        reservedSupply = _reservedSupply;
    }

    /// @notice Hide identity or show identity from here, put images folder here, ipfs folder cid
    function setBaseURI(string memory __baseURI) external onlyOwner {
        baseURI = __baseURI;
    }

    /// @notice Send NFTs to a list of addresses
    function giftNft(address[] calldata _sendNftsTo, uint256 _howMany) external onlyOwner {
        reservedSupply -= _sendNftsTo.length * _howMany; // below 0 it gives error
        
        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _howMany);
    }

    ////////////////////
    // HELPER METHOD  //
    ////////////////////

    /// @notice get all nfts of a person
    function nftsOf(address _owner) external view returns (uint256[] memory) {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        return tokenIds;
    }

    function tokenOfOwnerByIndex(address _owner, uint256 index) public view returns (uint256) {
        if (index >= balanceOf(_owner)) revert();
        uint256 numMintedSoFar = _currentIndex;
        uint256 tokenIdsIdx;
        address currOwnershipAddr;
        unchecked {
            for (uint256 i; i < numMintedSoFar; i++) {
                TokenOwnership memory ownership = _ownerships[i];
                if (ownership.burned) continue;
                if (ownership.addr != address(0)) currOwnershipAddr = ownership.addr;
                if (currOwnershipAddr == _owner) {
                    if (tokenIdsIdx == index) return i;
                    tokenIdsIdx++;
                }
            }
        }
        revert();
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721A, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function burn(uint256 tokenId) public override {
        super._burn(tokenId);
        _resetTokenRoyalty(tokenId);
    }

    function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) external onlyOwner {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }

    function receiveCoin() external payable {}

    receive() external payable {}

    ///////////////////////////////
    // AUTO APPROVE MARKETPLACES //
    ///////////////////////////////

    mapping(address => bool) projectProxy;

    function flipProxyState(address proxyAddress) public onlyOwner {
        projectProxy[proxyAddress] = !projectProxy[proxyAddress];
    }

    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {
        return
            projectProxy[_operator] || // Auto Approve any Marketplace,
                _operator == OpenSea(0xa5409ec958C83C3f309868babACA7c86DCB077c1).proxies(_owner) ||
                _operator == 0xF849de01B080aDC3A814FaBE1E2087475cF2E354 || // Looksrare
                _operator == 0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e || // Rarible
                _operator == 0x4feE7B061C97C9c496b01DbcE9CDb10c02f0a0Be // X2Y2
                ? true
                : super.isApprovedForAll(_owner, _operator);
    }
}

interface OpenSea {
    function proxies(address) external view returns (address);
}    