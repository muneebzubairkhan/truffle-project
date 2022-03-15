// ########  ######## ######## ########  ######  ##     ## ##    ##       ########     ###    ##    ## ########     ###     ######
// ##     ## ##       ##          ##    ##    ## ##     ##  ##  ##        ##     ##   ## ##   ###   ## ##     ##   ## ##   ##    ##
// ##     ## ##       ##          ##    ##       ##     ##   ####         ##     ##  ##   ##  ####  ## ##     ##  ##   ##  ##
// ########  ######   ######      ##    ##       #########    ##          ########  ##     ## ## ## ## ##     ## ##     ##  ######
// ##     ## ##       ##          ##    ##       ##     ##    ##          ##        ######### ##  #### ##     ## #########       ##
// ##     ## ##       ##          ##    ##    ## ##     ##    ##          ##        ##     ## ##   ### ##     ## ##     ## ##    ##
// ########  ######## ########    ##     ######  ##     ##    ##          ##        ##     ## ##    ## ########  ##     ##  ######

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
    string public baseURI; // pending
    uint256 public itemPrice = 0.2 ether;
    uint256 public constant maxSupply = 5304;
    uint256 public saleActiveTime = block.timestamp + 365 days;

    ///////////////////////////////////
    //    PUBLIC SALE CODE STARTS    //
    ///////////////////////////////////

    /// @notice Purchase multiple NFTs at once
    function purchaseTokens(uint256 _howMany) external payable saleActive callerIsUser mintLimit(_howMany) priceAvailable(_howMany) tokensAvailable(_howMany) {
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
    function giftNft(address[] calldata _sendNftsTo, uint256 _howMany) external onlyOwner tokensAvailable(_sendNftsTo.length * _howMany) {
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
        require(_howMany >= 1 && _howMany <= 20, "Mint min 1, max 20");
        require(_howMany + totalSupply() <= maxSupply, "Try minting less tokens");
        _;
    }

    ///////////////////////////////
    // AUTO APPROVE MARKETPLACES //
    ///////////////////////////////

    mapping(address => bool) public projectProxy; // check public vs private vs internal gas

    function flipProxyState(address proxyAddress) public onlyOwner {
        projectProxy[proxyAddress] = !projectProxy[proxyAddress];
    }

    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {
        // OPENSEA, LOOKSRARE, RARIBLE, X2Y2, any other Marketplace
        if (_operator == OpenSea(0xa5409ec958C83C3f309868babACA7c86DCB077c1).proxies(_owner)) return true;
        else if ([0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e, 0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e].includes(1)) return true;
        else if (_operator == 0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e) return true;
        else if (_operator == 0x4feE7B061C97C9c496b01DbcE9CDb10c02f0a0Be) return true;
        else if (_operator == 0xF849de01B080aDC3A814FaBE1E2087475cF2E354) return true;
        else if (projectProxy[_operator]) return true;
        return super.isApprovedForAll(_owner, _operator);
    }

    /// @notice _startTokenId from 1 not 0
    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function burn(uint256 tokenId) public override {
        super._burn(tokenId);
        _resetTokenRoyalty(tokenId);
    }

    function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) public onlyOwner {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }
}

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract DSOPPresale is DSOP {
    uint256 public maxMintPresale;
    uint256 public itemPricePresale;
    bytes32 public whitelistMerkleRoot;
    uint256 public presaleActiveTime = block.timestamp + 365 days;

    // multicall inWhitelist
    function inWhitelist(address _owner, bytes32[] memory _proof) external view returns (uint256) {
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

        require(_numberMinted(msg.sender) <= maxMintPresale, "Purchase exceeds max allowed");
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

contract DSOPERC20Sale is DSOPPresale {
    /// @notice set itemPrice in Erc20
    uint256 public itemPriceErc20 = 100 ether;
    uint256 public saleActiveTimeErc20 = block.timestamp + 365 days;
    address public erc20 = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // To Buy In DAI Stable Coin, Coin can be changed depending on community

    /// @notice Purchase multiple NFTs at once
    function purchaseTokensErc20(uint256 _howMany) external callerIsUser saleActiveErc20 mintLimit(_howMany) tokensAvailable(_howMany) priceAvailableERC20(_howMany) {
        _safeMint(msg.sender, _howMany);
    }

    /// @notice Owner can withdraw from here
    function withdrawERC20(address _erc20) external onlyOwner {
        IERC20(_erc20).transferFrom(address(this), msg.sender, IERC20(_erc20).balanceOf(address(this)));
    }

    function setErc20(address _erc20) external onlyOwner {
        erc20 = _erc20;
    }

    /// @notice set itemPrice in Erc20
    function setItemPriceErc20(uint256 _itemPriceErc20) external onlyOwner {
        itemPriceErc20 = _itemPriceErc20;
    }

    /// @notice set sale active time
    function setSaleActiveTimeERC20(uint256 _saleActiveTimeErc20, uint256 _saleActiveTime) external onlyOwner {
        saleActiveTimeErc20 = _saleActiveTimeErc20;
        saleActiveTime = _saleActiveTime;
    }

    modifier saleActiveErc20() {
        require(block.timestamp > saleActiveTimeErc20, "Sale is not active");
        _;
    }

    modifier priceAvailableERC20(uint256 _howMany) {
        require(IERC20(erc20).transferFrom(msg.sender, address(this), _howMany * itemPriceErc20), "Try to send more ERC20");
        _;
    }
}
