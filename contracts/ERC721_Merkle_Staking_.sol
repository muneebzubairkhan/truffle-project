// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";

// import "erc721a@3.3.0/contracts/ERC721A.sol";
// import "erc721a@3.3.0/contracts/extensions/ERC721AQueryable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract NftPublicSale is ERC721A("DysfunctionalDogs", "DDs"), ERC721AQueryable, Ownable, ERC2981 {
    using Strings for uint256;

    bool public revealed = false;
    string public notRevealedMetadataFolderIpfsLink;
    uint256 public maxMintAmount = 20;
    uint256 public maxSupply = 10_000;
    uint256 public costPerNft = 0.075 * 1e18;
    uint256 public nftsForOwner = 250;
    string public metadataFolderIpfsLink;
    uint256 public nftPerAddressLimit = 3;
    string constant baseExtension = ".json";
    uint256 public publicmintActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/

    constructor() {
        _setDefaultRoyalty(msg.sender, 10_00); // 10.00 %
    }

    // public
    function purchaseTokens(uint256 _mintAmount) public payable {
        require(block.timestamp > publicmintActiveTime, "the contract is paused");
        uint256 supply = totalSupply();
        require(_mintAmount > 0, "need to mint at least 1 NFT");
        require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
        require(supply + _mintAmount + nftsForOwner <= maxSupply, "max NFT limit exceeded");
        require(msg.value >= costPerNft * _mintAmount, "insufficient funds");

        _safeMint(msg.sender, _mintAmount);
    }

    ///////////////////////////////////
    //       OVERRIDE CODE STARTS    //
    ///////////////////////////////////

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981, IERC165) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return metadataFolderIpfsLink;
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721A, IERC721Metadata) returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        if (revealed == false) return notRevealedMetadataFolderIpfsLink;

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
    }

    //////////////////
    //  ONLY OWNER  //
    //////////////////

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success);
    }

    function giftNft(address[] calldata _sendNftsTo, uint256 _howMany) external onlyOwner {
        nftsForOwner -= _sendNftsTo.length * _howMany;

        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _howMany);
    }

    function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) public onlyOwner {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }

    function revealFlip() public onlyOwner {
        revealed = !revealed;
    }

    function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
        nftPerAddressLimit = _limit;
    }

    function setCostPerNft(uint256 _newCostPerNft) public onlyOwner {
        costPerNft = _newCostPerNft;
    }

    function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }

    function setMetadataFolderIpfsLink(string memory _newMetadataFolderIpfsLink) public onlyOwner {
        metadataFolderIpfsLink = _newMetadataFolderIpfsLink;
    }

    function setNotRevealedMetadataFolderIpfsLink(string memory _notRevealedMetadataFolderIpfsLink) public onlyOwner {
        notRevealedMetadataFolderIpfsLink = _notRevealedMetadataFolderIpfsLink;
    }

    function setSaleActiveTime(uint256 _publicmintActiveTime) public onlyOwner {
        publicmintActiveTime = _publicmintActiveTime;
    }
}

contract NftWhitelistSale is NftPublicSale {
    uint256 public whitelistSupply = 400;
    uint256 public whitelistMinted = 0;

    uint256 public whitelistActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/;
    uint256 public whitelistMaxMint = 3;
    uint256 public itemPriceWhitelist = 0.03 * 1e18;
    
    mapping(address => uint256) public whitelistClaimedBy;
    mapping(address => bool) public onWhitelist;

    function addToWhitelist(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist[addresses[i]] = true;
    }

    function removeFromWhitelist(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist[addresses[i]] = false;
    }

    function purchaseTokensWhitelist(uint256 _howMany) external payable {
        require(whitelistMinted + _howMany <= whitelistSupply, "whitelist limit reached");
        require(_totalMinted() + _howMany + nftsForOwner <= maxSupply, "max NFT limit exceeded");

        require(onWhitelist[msg.sender], "You are not in whitelist");
        require(block.timestamp > whitelistActiveTime, "Whitelist is not active");
        require(msg.value >= _howMany * itemPriceWhitelist, "Try to send more ETH");

        whitelistMinted += _howMany;
        whitelistClaimedBy[msg.sender] += _howMany;

        require(whitelistClaimedBy[msg.sender] <= whitelistMaxMint, "Purchase exceeds max allowed");

        _safeMint(msg.sender, _howMany);
    }

    function setWhitelistMaxMint(uint256 _whitelistMaxMint) external onlyOwner {
        whitelistMaxMint = _whitelistMaxMint;
    }
    function setPriceWhitelist(uint256 _itemPriceWhitelist) external onlyOwner {
        itemPriceWhitelist = _itemPriceWhitelist;
    }

    function setWhitelistActiveTime(uint256 _whitelistActiveTime) external onlyOwner {
        whitelistActiveTime = _whitelistActiveTime;
    }
}

contract NftAutoApproveMarketPlaces is NftWhitelistSale {
    mapping(address => bool) public projectProxy;

    function flipProxyState(address proxyAddress) public onlyOwner {
        projectProxy[proxyAddress] = !projectProxy[proxyAddress];
    }

    function isApprovedForAll(address _owner, address _operator) public view override(ERC721A, IERC721) returns (bool) {
        return projectProxy[_operator] ? true : super.isApprovedForAll(_owner, _operator);
    }
}

contract DysfunctionalDogsNft is NftAutoApproveMarketPlaces {}
