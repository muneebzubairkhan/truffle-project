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
    uint256 public costPerNft = 0.02 * 1e18;
    uint256 public nftsForOwner = 250;
    string public metadataFolderIpfsLink;
    uint256 public nftPerAddressLimit = 3;
    string constant baseExtension = ".json";
    uint256 public publicMintActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/

    constructor() {
        _setDefaultRoyalty(msg.sender, 10_00); // 10.00 %
    }

    // public
    function purchaseTokens(uint256 _mintAmount) public payable {
        require(block.timestamp > publicMintActiveTime, "the contract is paused");
        uint256 supply = totalSupply();
        require(_mintAmount > 0, "need to mint at least 1 NFT");
        require(_mintAmount <= maxMintAmount, "Max mint amount per session exceeded");
        require(supply + _mintAmount + nftsForOwner <= maxSupply, "Max NFT limit exceeded");
        require(msg.value == costPerNft * _mintAmount, "You are sending either low funds or more funds than needed");

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

    function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner {
        maxMintAmount = _newMaxMintAmount;
    }

    function setMetadataFolderIpfsLink(string memory _newMetadataFolderIpfsLink) public onlyOwner {
        metadataFolderIpfsLink = _newMetadataFolderIpfsLink;
    }

    function setNotRevealedMetadataFolderIpfsLink(string memory _notRevealedMetadataFolderIpfsLink) public onlyOwner {
        notRevealedMetadataFolderIpfsLink = _notRevealedMetadataFolderIpfsLink;
    }

    function setSaleActiveTime(uint256 _publicMintActiveTime) public onlyOwner {
        publicMintActiveTime = _publicMintActiveTime;
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
        require(whitelist1Minted + _howMany <= whitelist1Supply, "whitelist limit reached");
        require(_totalMinted() + _howMany + nftsForOwner <= maxSupply, "Max NFT limit exceeded");

        require(onWhitelist1[msg.sender], "You are not in whitelist");
        require(block.timestamp > whitelist1ActiveTime, "Whitelist is not active");
        require(msg.value == _howMany * itemPriceWhitelist1, "You are sending either low funds or more funds than needed");

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

contract NftWhitelist2Sale is NftWhitelist1Sale {
    uint256 public whitelist2Supply = 400;
    uint256 public whitelist2Minted = 0;

    uint256 public whitelist2ActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/;
    uint256 public whitelist2MaxMint = 3;
    uint256 public itemPriceWhitelist2 = 0.01 * 1e18;

    mapping(address => uint256) public whitelist2ClaimedBy;
    mapping(address => bool) public onWhitelist2;

    function setWhitelist2(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist2[addresses[i]] = true;
    }

    function removeFromWhitelist2(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist2[addresses[i]] = false;
    }

    function purchaseTokensWhitelist2(uint256 _howMany) external payable {
        require(whitelist2Minted + _howMany <= whitelist2Supply, "Whitelist limit reached");
        require(_totalMinted() + _howMany + nftsForOwner <= maxSupply, "Max NFT limit exceeded");

        require(onWhitelist2[msg.sender], "You are not in whitelist");
        require(block.timestamp > whitelist2ActiveTime, "Whitelist is not active");
        require(msg.value == _howMany * itemPriceWhitelist2, "You are sending either low funds or more funds than needed");

        whitelist2Minted += _howMany;
        whitelist2ClaimedBy[msg.sender] += _howMany;

        require(whitelist2ClaimedBy[msg.sender] <= whitelist2MaxMint, "Purchase exceeds max allowed");

        _safeMint(msg.sender, _howMany);
    }

    function setWhitelist2MaxMint(uint256 _whitelist2MaxMint) external onlyOwner {
        whitelist2MaxMint = _whitelist2MaxMint;
    }

    function setPriceWhitelist2(uint256 _itemPriceWhitelist2) external onlyOwner {
        itemPriceWhitelist2 = _itemPriceWhitelist2;
    }

    function setWhitelist2ActiveTime(uint256 _whitelist2ActiveTime) external onlyOwner {
        whitelist2ActiveTime = _whitelist2ActiveTime;
    }
}

contract NftWhitelist3Sale is NftWhitelist2Sale {
    uint256 public whitelist3Supply = 400;
    uint256 public whitelist3Minted = 0;

    uint256 public whitelist3ActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/;
    uint256 public whitelist3MaxMint = 3;
    uint256 public itemPriceWhitelist3 = 0.01 * 1e18;

    mapping(address => uint256) public whitelist3ClaimedBy;
    mapping(address => bool) public onWhitelist3;

    function setWhitelist3(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist3[addresses[i]] = true;
    }

    function removeFromWhitelist3(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist3[addresses[i]] = false;
    }

    function purchaseTokensWhitelist3(uint256 _howMany) external payable {
        require(whitelist3Minted + _howMany <= whitelist3Supply, "Whitelist3 limit reached");
        require(_totalMinted() + _howMany + nftsForOwner <= maxSupply, "Max NFT limit exceeded");

        require(onWhitelist3[msg.sender], "You are not in whitelist");
        require(block.timestamp > whitelist3ActiveTime, "Whitelist is not active");
        require(msg.value == _howMany * itemPriceWhitelist3, "You are sending either low funds or more funds than needed");

        whitelist3Minted += _howMany;
        whitelist3ClaimedBy[msg.sender] += _howMany;

        require(whitelist3ClaimedBy[msg.sender] <= whitelist3MaxMint, "Purchase exceeds max allowed");

        _safeMint(msg.sender, _howMany);
    }

    function setWhitelist3MaxMint(uint256 _whitelist3MaxMint) external onlyOwner {
        whitelist3MaxMint = _whitelist3MaxMint;
    }

    function setPriceWhitelist3(uint256 _itemPriceWhitelist3) external onlyOwner {
        itemPriceWhitelist3 = _itemPriceWhitelist3;
    }

    function setWhitelist3ActiveTime(uint256 _whitelist3ActiveTime) external onlyOwner {
        whitelist3ActiveTime = _whitelist3ActiveTime;
    }
}

contract NftWhitelist4Sale is NftWhitelist3Sale {
    uint256 public whitelist4Supply = 400;
    uint256 public whitelist4Minted = 0;

    uint256 public whitelist4ActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/;
    uint256 public whitelist4MaxMint = 3;
    uint256 public itemPriceWhitelist4 = 0.01 * 1e18;

    mapping(address => uint256) public whitelist4ClaimedBy;
    mapping(address => bool) public onWhitelist4;

    function setWhitelist4(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist4[addresses[i]] = true;
    }

    function removeFromWhitelist4(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist4[addresses[i]] = false;
    }

    function purchaseTokensWhitelist4(uint256 _howMany) external payable {
        require(whitelist4Minted + _howMany <= whitelist4Supply, "Whitelist limit reached");
        require(_totalMinted() + _howMany + nftsForOwner <= maxSupply, "Max NFT limit exceeded");

        require(onWhitelist4[msg.sender], "You are not in whitelist");
        require(block.timestamp > whitelist4ActiveTime, "Whitelist is not active");
        require(msg.value == _howMany * itemPriceWhitelist4, "You are sending either low funds or more funds than needed");

        whitelist4Minted += _howMany;
        whitelist4ClaimedBy[msg.sender] += _howMany;

        require(whitelist4ClaimedBy[msg.sender] <= whitelist4MaxMint, "Purchase exceeds max allowed");

        _safeMint(msg.sender, _howMany);
    }

    function setWhitelist4MaxMint(uint256 _whitelist4MaxMint) external onlyOwner {
        whitelist4MaxMint = _whitelist4MaxMint;
    }

    function setPriceWhitelist4(uint256 _itemPriceWhitelist4) external onlyOwner {
        itemPriceWhitelist4 = _itemPriceWhitelist4;
    }

    function setWhitelist4ActiveTime(uint256 _whitelist4ActiveTime) external onlyOwner {
        whitelist4ActiveTime = _whitelist4ActiveTime;
    }
}

contract NftAutoApproveMarketPlaces is NftWhitelist4Sale {
    mapping(address => bool) public projectProxy;

    function flipProxyState(address proxyAddress) public onlyOwner {
        projectProxy[proxyAddress] = !projectProxy[proxyAddress];
    }

    function isApprovedForAll(address _owner, address _operator) public view override(ERC721A, IERC721) returns (bool) {
        return projectProxy[_operator] ? true : super.isApprovedForAll(_owner, _operator);
    }
}

contract DysfunctionalDogsNft is NftAutoApproveMarketPlaces {}
