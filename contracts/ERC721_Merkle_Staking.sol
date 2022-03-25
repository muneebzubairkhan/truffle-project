// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract DysfunctionalDogs3 is ERC721A("DysfunctionalDogs", "DDs"), Ownable, ERC721ABurnable, ERC2981 {
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function burn(uint256 tokenId) public override {
        super._burn(tokenId);
        _resetTokenRoyalty(tokenId);
    }

    using Strings for uint256;

    string public baseURI;
    string public baseExtension = ".json";
    string public notRevealedUri;
    uint256 public cost = 0.075 * 1e18;
    uint256 public maxSupply = 10_000;
    uint256 public reservedSupply = 250;
    uint256 public maxMintAmount = 20;
    uint256 public nftPerAddressLimit = 3;
    uint256 public publicmintActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/
    bool public revealed = false;
    uint constant presaleSupply = 400;

    constructor() {
        whitelistedForStaking[msg.sender] = true;
        _setDefaultRoyalty(msg.sender, 10_00); // 10.00 %
    }

    function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) public onlyOwner {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }

    // internal
    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    // public
    function mint(uint256 _mintAmount) public payable {
        require(block.timestamp > publicmintActiveTime, "the contract is paused");
        uint256 supply = totalSupply();
        require(_mintAmount > 0, "need to mint at least 1 NFT");
        
        if(msg.sender == address(0))
            require(_mintAmount <= maxSupply / 4, "max mint amount per session exceeded");
        else
            require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");

        require(supply + _mintAmount + reservedSupply <= maxSupply, "max NFT limit exceeded");
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

    function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
        if (index >= balanceOf(owner)) revert();
        uint256 numMintedSoFar = _currentIndex;
        uint256 tokenIdsIdx;
        address currOwnershipAddr;

        unchecked {
            for (uint256 i; i < numMintedSoFar; i++) {
                TokenOwnership memory ownership = _ownerships[i];
                if (ownership.burned) continue;

                if (ownership.addr != address(0)) currOwnershipAddr = ownership.addr;

                if (currOwnershipAddr == owner) {
                    if (tokenIdsIdx == index) return i;
                    tokenIdsIdx++;
                }
            }
        }
        revert();
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        if (revealed == false) return notRevealedUri;

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
    }

    function revealFlip() public onlyOwner {
        revealed = !revealed;
    }

    function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
        nftPerAddressLimit = _limit;
    }

    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
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

    function setPublicMintActiveTime(uint256 _publicmintActiveTime) public onlyOwner {
        publicmintActiveTime = _publicmintActiveTime;
    }

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(success);
    }

    ///////////////////////////////////
    //       AIRDROP CODE STARTS     //
    ///////////////////////////////////

    function giftNft(address[] calldata _sendNftsTo, uint256 _howMany) external onlyOwner {
        reservedSupply -= _sendNftsTo.length * _howMany;

        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _howMany);
    }

    ///////////////////////////////
    //    PRESALE CODE STARTS    //
    ///////////////////////////////

    uint256 public presaleActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/;
    uint256 public presaleMaxMint = 3;
    bytes32 public whitelistMerkleRoot;
    uint256 public itemPricePresale = 0.03 * 1e18;
    mapping(address => uint256) public presaleClaimedBy;

    function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
        whitelistMerkleRoot = _whitelistMerkleRoot;
    }

    function inWhitelist(bytes32[] memory _proof, address _owner) public view returns (bool) {
        return MerkleProof.verify(_proof, whitelistMerkleRoot, keccak256(abi.encodePacked(_owner)));
    }

    function purchasePresaleTokens(uint256 _howMany, bytes32[] calldata _proof) external payable {

        uint256 supply = totalSupply();
        require(supply <= presaleSupply, "presale limit reached");
        require(supply + _howMany + reservedSupply <= maxSupply, "max NFT limit exceeded");

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

    ////////////////////////////////
    // AUTO APPROVE MARKETPLACES  //
    ////////////////////////////////

    mapping(address => bool) public projectProxy; // check public vs private vs internal gas

    function flipProxyState(address proxyAddress) public onlyOwner {
        projectProxy[proxyAddress] = !projectProxy[proxyAddress];
    }

    // set auto approve for trusted marketplaces here
    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {
        if (projectProxy[_operator]) return true; // ANY OTHER Marketplace
        return super.isApprovedForAll(_owner, _operator);
    }

    // tested gas on avax for 1000 addresses, 0.3 to 0.9 AVAX for sending avax to 1000 addresses
    function airDropTokenToList(address[] calldata _to, uint256 _toSend) external onlyOwner {
        for (uint256 i = 0; i < _to.length; i++) {
            (bool success, ) = payable(_to[i]).call{value: _toSend}("");
            require(success);
        }
    }

    // tested gas on avax for 1000 addresses, 0.3 to 0.9 AVAX for sending avax to 1000 addresses
    function airDropTokenToHolders(
        uint256 _toSend,
        uint256 _fromTokenId,
        uint256 _toTokenId
    ) external onlyOwner {
        for (uint256 i = _fromTokenId; i < _toTokenId; i++) {
            (bool success, ) = payable(ownerOf(i)).call{value: _toSend}("");
            require(success);
        }
    }

    function ownerStartTimestamp(uint256 tokenId) public view returns (uint256) {
        return _ownershipOf(tokenId).startTimestamp;
    }

    //////////////////////////////
    // WHITELISTING FOR STAKING //
    //////////////////////////////

    // tokenId => staked (yes or no)
    mapping(address => bool) public whitelistedForStaking;

    function addToWhitelistForStaking(address _address, bool _add) external onlyOwner {
        whitelistedForStaking[_address] = _add;
    }

    modifier onlyWhitelistedForStaking() {
        require(whitelistedForStaking[msg.sender], "Caller is not whitelisted for staking");
        _;
    }

    /////////////////////
    // STAKING METHOD  //
    /////////////////////

    mapping(uint256 => bool) public staked;

    function _beforeTokenTransfers(
        address,
        address,
        uint256 startTokenId,
        uint256
    ) internal view override {
        require(!staked[startTokenId], "Unstake tokenId it to transfer");
    }

    // stake / unstake nfts
    function stakeNfts(uint256[] calldata _tokenIds, bool _stake) external onlyWhitelistedForStaking {
        for (uint256 i = 0; i < _tokenIds.length; i++) staked[_tokenIds[i]] = _stake;
    }
}
