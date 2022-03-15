// d8888b. .d8888.  .d88b.  d8888b.
// 88  `8D 88'  YP .8P  Y8. 88  `8D
// 88   88 `8bo.   88    88 88oodD'
// 88   88   `Y8b. 88    88 88~~~'
// 88  .8D db   8D `8b  d8' 88
// Y8888D' `8888Y'  `Y88P'  88

// Website:    https://www.DSOP.club/
// OpenSea:    https://opensea.io/collection/DSOP
// Twitter:    https://twitter.com/DSOP
// Instagram:  https://www.instagram.com/DSOP/
// Discord:    https://discord.com/invite/7rqy7PxmD9

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "erc721a/contracts/extensions/ERC721ABurnable.sol";

interface OpenSea {
    function proxies(address) external view returns (address);
}

contract DSOP is ERC721A("Decentraland Series Of Poker", "DSOP"), ERC721ABurnable, ERC2981, Ownable {
    string baseURI; // pending
    uint256 itemPrice = 0.2 ether;
    uint256 constant maxSupply = 5304;
    uint256 saleActiveTime = block.timestamp + 365 days;

    ///////////////////////////////////
    //    PUBLIC SALE CODE STARTS    //
    ///////////////////////////////////

    /// @notice Purchase multiple NFTs at once
    function purchaseTokens(uint256 _howMany) external payable saleActive mintLimits(_howMany) priceAvailable(_howMany) {
        _safeMint(msg.sender, _howMany);
    }

    //////////////////////////
    // ONLY OWNER METHODS   //
    //////////////////////////

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

    /// @notice Hide identity or show identity from here, put images folder here, ipfs folder cid
    function setBaseURI(string memory __baseURI) external onlyOwner {
        baseURI = __baseURI;
    }

    ///////////////////////////////////
    //       AIRDROP CODE STARTS     //
    ///////////////////////////////////

    /// @notice Send NFTs to a list of addresses
    function giftNft(address[] calldata _sendNftsTo, uint256 _howMany) external onlyOwner {
        require(_sendNftsTo.length * _howMany + totalSupply() <= maxSupply, "Try minting less");
        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _howMany);
    }

    ////////////////////
    // HELPER METHOD  //
    ////////////////////

    /// @notice get all nfts of a person
    function walletOfOwner(address _owner) external view returns (uint256[] memory) {
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

    ///////////////////
    //  HELPER CODE  //
    ///////////////////

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    modifier saleActive() {
        require(block.timestamp > saleActiveTime, "Sale is not active");
        _;
    }

    modifier priceAvailable(uint256 _howMany) {
        require(msg.value >= _howMany * itemPrice, "Try to send more ETH");
        _;
    }

    modifier mintLimits(uint256 _howMany) {
        require(tx.origin == msg.sender, "The caller is a contract");
        require(_howMany >= 1 && _howMany <= 10, "Mint min 1, max 10");
        require(_howMany + totalSupply() <= maxSupply, "Try minting less tokens");
        _;
    }

    ///////////////////////////////
    // AUTO APPROVE MARKETPLACES //
    ///////////////////////////////

    mapping(address => bool) projectProxy;

    function flipProxyState(address proxyAddress) external onlyOwner {
        projectProxy[proxyAddress] = !projectProxy[proxyAddress];
    }

    // Auto Approve any Marketplace, Opensea, Looksrare, Rarible, X2Y2,
    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {
        return
            projectProxy[_operator] ||
                _operator == OpenSea(0xa5409ec958C83C3f309868babACA7c86DCB077c1).proxies(_owner) ||
                _operator == 0xF849de01B080aDC3A814FaBE1E2087475cF2E354 ||
                _operator == 0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e ||
                _operator == 0x4feE7B061C97C9c496b01DbcE9CDb10c02f0a0Be
                ? true
                : super.isApprovedForAll(_owner, _operator);
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
}

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract DSOPPresale is DSOP {
    uint256 maxMintPresale;
    uint256 itemPricePresale;
    bytes32 whitelistMerkleRoot;
    uint256 presaleActiveTime = block.timestamp + 365 days;

    // multicall inWhitelist
    function inWhitelist(address _owner, bytes32[] memory _proof) external view returns (bool) {
        if (_inWhitelist(_owner, _proof)) return true;
        return false;
    }

    function _inWhitelist(address _owner, bytes32[] memory _proof) private view returns (bool) {
        return MerkleProof.verify(_proof, whitelistMerkleRoot, keccak256(abi.encodePacked(_owner)));
    }

    function purchasePresaleTokens(uint256 _howMany, bytes32[] calldata _proof) external payable mintLimits(_howMany) {
        require(block.timestamp > presaleActiveTime, "Presale is not active");
        require(_inWhitelist(msg.sender, _proof), "You are not in presale");
        require(msg.value >= _howMany * itemPricePresale, "Try to send more ETH");

        _safeMint(msg.sender, _howMany);
    }

    function numberMinted(address _owner) external view returns (uint256) {
        return _numberMinted(_owner);
    }

    function setPresale(
        bytes32 _whitelistMerkleRoot,
        uint256 _maxMintPresales,
        uint256 _itemPricePresale
    ) external onlyOwner {
        maxMintPresale = _maxMintPresales;
        itemPricePresale = _itemPricePresale;
        whitelistMerkleRoot = _whitelistMerkleRoot;
    }

    function setPresaleActiveTime(uint256 _presaleActiveTime) external onlyOwner {
        presaleActiveTime = _presaleActiveTime;
    }
}
