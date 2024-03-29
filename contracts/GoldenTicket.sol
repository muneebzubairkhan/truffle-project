//   __  __        _            _____                                _____               _        _
//  |  \/  |      | |          |  __ \                              / ____|             (_)      | |
//  | \  / |  ___ | |_  __ _   | |  | |  ___   __ _   ___  _ __    | (___    ___    ___  _   ___ | |_  _   _
//  | |\/| | / _ \| __|/ _` |  | |  | | / _ \ / _` | / _ \| '_ \    \___ \  / _ \  / __|| | / _ \| __|| | | |
//  | |  | ||  __/| |_| (_| |  | |__| ||  __/| (_| ||  __/| | | |   ____) || (_) || (__ | ||  __/| |_ | |_| |
//  |_|  |_| \___| \__|\__,_|  |_____/  \___| \__, | \___||_| |_|  |_____/  \___/  \___||_| \___| \__| \__, |
//                                             __/ |                                                    __/ |
//                                            |___/                                                    |___/

// Website:    https://metadegensociety.io/
// OpenSea:    https://opensea.io/collection/metadegensociety/
// Discord:    https://discord.com/invite/ZXPx9WbQWk
// Instagram:  https://www.instagram.com/metadegensociety/
// Twitter:    https://twitter.com/meta_degen
// Youtube:    https://www.youtube.com/channel/UC6a0zWMSsulw6hWXkquIEtg
// TikTok:     https://www.tiktok.com/@metadegensociety
// Medium:     https://medium.com/@metadegensociety

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";

contract GoldenTicket is ERC721A("Golden Ticket", "GT"), ERC721ABurnable, ERC2981, Ownable, ReentrancyGuard {
    string baseURI = "ipfs://QmfKgWoKSDDU1qnLwGuRQq3wfW3fPrue4wEWGNgXfFkZHw/";
    uint256 saleActiveTime = type(uint256).max;

    uint256 constant maxSupply = 1000;
    uint256 public reservedSupply = 450;

    uint256 itemPrice = 45 ether;

    constructor() {
        flipProxyState(0x58807baD0B376efc12F5AD86aAc70E78ed67deaE); // Auto Approve OpenSea Polygon
    }

    /// @notice Purchase multiple NFTs at once
    function purchaseTokens(uint256 _howMany) external payable nonReentrant {
        // mint nfts
        _safeMint(msg.sender, _howMany);

        // full fill some requirements
        require(totalSupply() + reservedSupply <= maxSupply, "Try mint less");
        require(tx.origin == msg.sender, "The caller is a contract");
        require(_howMany >= 1 && _howMany <= 50, "Mint min 1, max 50");
        require(block.timestamp > saleActiveTime, "Sale is not active");

        // Pay the price
        require(msg.value == _howMany * itemPrice, "Send correct amount of ETH");
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
    function giftNft(address[] calldata _sendNftsTo, uint256 _howMany) external onlyOwner nonReentrant {
        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _howMany);

        reservedSupply -= _sendNftsTo.length * _howMany; // below 0 it gives error
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
        return projectProxy[_operator] ? true : super.isApprovedForAll(_owner, _operator);
    }

    ///////////////////////////////////////
    // CAN NOT SELL A USED GOLDEN TICKET //
    ///////////////////////////////////////

    address metaDegenSociety;

    function setMetaDegenSociety(address _metaDegenSociety) external onlyOwner {
        metaDegenSociety = _metaDegenSociety;
    }

    function burnRedeemed(address _owner, uint256[] memory _tokenIds) external {
        require(msg.sender == metaDegenSociety, "You are not MetaDegenSociety");

        for (uint256 i = 0; i < _tokenIds.length; i++) {
            require(_owner == ownerOf(_tokenIds[i]), "You are not owner");
            burn(_tokenIds[i]);
        }
    }
}
