// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract DysfunctionalDogs is ERC721A("DysfunctionalDogs", "DDs"), Ownable {
    using Strings for uint256;

    string public baseURI;
    string public baseExtension = ".json";
    string public notRevealedUri;
    uint256 public cost = 0.075 ether;
    uint256 public maxSupply = 10000;
    uint256 public maxMintAmount = 20;
    uint256 public nftPerAddressLimit = 3;
    uint256 public publicmintActiveTime = block.timestamp + 30 days; // https://www.epochconverter.com/
    bool public revealed = false;

    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    // public
    function mint(uint256 _mintAmount) public payable {
        require(block.timestamp > publicmintActiveTime, "the contract is paused");
        uint256 supply = totalSupply();
        require(_mintAmount > 0, "need to mint at least 1 NFT");
        require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
        require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
        require(msg.value >= cost * _mintAmount, "insufficient funds");

        _safeMint(msg.sender, _mintAmount);
    }

    function walletOfOwner(address _owner) public view returns (uint256[] memory) {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        if (revealed == false) {
            return notRevealedUri;
        }

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
    }

    //only owner
    function reveal() public onlyOwner {
        revealed = true;
    }

    function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
        nftPerAddressLimit = _limit;
    }

    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    function publicMint(uint256 _state) public onlyOwner {
        publicmintActiveTime = _state;
    }

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success);
    }

    ///////////////////////////////////
    //       AIRDROP CODE STARTS     //
    ///////////////////////////////////

    // Send NFTs to a list of addresses
    function giftNftToList(address[] calldata _sendNftsTo) external onlyOwner {
        require(totalSupply() + _sendNftsTo.length <= maxSupply, "max NFT limit exceeded");

        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], 1);
    }

    // Send NFTs to a single address
    function giftNftToAddress(address _sendNftsTo, uint256 _howMany) external onlyOwner {
        require(totalSupply() + _howMany <= maxSupply, "max NFT limit exceeded");

        _safeMint(_sendNftsTo, _howMany);
    }

    ///////////////////////////////
    //    PRESALE CODE STARTS    //
    ///////////////////////////////

    uint256 public presaleActiveTime;
    uint256 public presaleMaxMint = 3;
    bytes32 public whitelistMerkleRoot;
    uint256 public itemPricePresale = 0.03 ether;
    mapping(address => uint256) public presaleClaimedBy;

    function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
        whitelistMerkleRoot = _whitelistMerkleRoot;
    }

    function inWhitelist(bytes32[] memory _proof, address _owner) public view returns (bool) {
        return MerkleProof.verify(_proof, whitelistMerkleRoot, keccak256(abi.encodePacked(_owner)));
    }

    function purchasePresaleTokens(uint256 _howMany, bytes32[] calldata _proof) external payable {
        uint256 supply = totalSupply();
        require(supply + _howMany <= maxSupply, "max NFT limit exceeded");

        require(inWhitelist(_proof, msg.sender), "You are not in presale");
        require(block.timestamp > presaleActiveTime, "Presale is not active");
        require(msg.value >= _howMany * itemPricePresale, "Try to send more ETH");

        presaleClaimedBy[msg.sender] += _howMany;

        require(presaleClaimedBy[msg.sender] <= presaleMaxMint, "Purchase exceeds max allowed");

        _safeMint(msg.sender, _howMany);
    }

    // set limit of presale
    function setPresaleMaxMint(uint256 _presaleMaxMint) external onlyOwner {
        presaleMaxMint = _presaleMaxMint;
    }

    // Change presale price in case of ETH price changes too much
    function setPricePresale(uint256 _itemPricePresale) external onlyOwner {
        itemPricePresale = _itemPricePresale;
    }

    function setPresaleActiveTime(uint256 _presaleActiveTime) external onlyOwner {
        presaleActiveTime = _presaleActiveTime;
    }

    ///////////////////////////
    // AUTO APPROVE OPENSEA  //
    ///////////////////////////

    // Opensea Registerar Mainnet 0xa5409ec958C83C3f309868babACA7c86DCB077c1
    // Opensea Registerar Rinkeby 0xF57B2c51dED3A29e6891aba85459d600256Cf317
    address openSeaRegistrar = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;

    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {
        return ProxyRegisterar(openSeaRegistrar).proxies(_owner) == _operator ? true : super.isApprovedForAll(_owner, _operator);
    }

    // infuture address changes for opensea registrar
    function editOpenSeaRegisterar(address _openSeaRegistrar) external onlyOwner {
        openSeaRegistrar = _openSeaRegistrar;
    }

    // just in case openSeaRegistrar is not present we use this contract as openSeaRegistrar
    function proxies(address) external pure returns (address) {
        return address(0);
    }
}

interface ProxyRegisterar {
    function proxies(address) external view returns (address);
}

// 2870871 * 0.000000035 = 0.1005 ETH to deploy at gas 35