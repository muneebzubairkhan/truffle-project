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

contract NftWhitelist1Sale is NftPublicSale {
    uint256 public whitelist1Supply = 400;
    uint256 public whitelist1Minted = 0;

    uint256 public whitelist1ActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/;
    uint256 public whitelist1MaxMint = 3;
    uint256 public itemPriceWhitelist1 = 0.01 * 1e18;
    
    mapping(address => uint256) public whitelist1ClaimedBy;
    mapping(address => bool) public onWhitelist1;

    function setWhitelist1(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist1[addresses[i]] = true;
    }

    function removeFromWhitelist1(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist1[addresses[i]] = false;
    }

    function purchaseTokensWhitelist1(uint256 _howMany) external payable {
        require(whitelist1Minted + _howMany <= whitelist1Supply, "whitelist1 limit reached");
        require(_totalMinted() + _howMany + nftsForOwner <= maxSupply, "max NFT limit exceeded");

        require(onWhitelist1[msg.sender], "You are not in whitelist1");
        require(block.timestamp > whitelist1ActiveTime, "Whitelist1 is not active");
        require(msg.value >= _howMany * itemPriceWhitelist1, "Try to send more ETH");

        whitelist1Minted += _howMany;
        whitelist1ClaimedBy[msg.sender] += _howMany;

        require(whitelist1ClaimedBy[msg.sender] <= whitelist1MaxMint, "Purchase exceeds max allowed");

        _safeMint(msg.sender, _howMany);
    }

    function setWhitelist1MaxMint(uint256 _whitelist1MaxMint) external onlyOwner {
        whitelist1MaxMint = _whitelist1MaxMint;
    }
    function setPriceWhitelist1(uint256 _itemPriceWhitelist1) external onlyOwner {
        itemPriceWhitelist1 = _itemPriceWhitelist1;
    }

    function setWhitelist1ActiveTime(uint256 _whitelist1ActiveTime) external onlyOwner {
        whitelist1ActiveTime = _whitelist1ActiveTime;
    }
}

contract NftAutoApproveMarketPlaces is NftWhitelist1Sale {
    mapping(address => bool) public projectProxy;

    function flipProxyState(address proxyAddress) public onlyOwner {
        projectProxy[proxyAddress] = !projectProxy[proxyAddress];
    }

    function isApprovedForAll(address _owner, address _operator) public view override(ERC721A, IERC721) returns (bool) {
        return projectProxy[_operator] ? true : super.isApprovedForAll(_owner, _operator);
    }
}

contract DysfunctionalDogsNft is NftAutoApproveMarketPlaces {}
