// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract UfBro is ERC721A("Name Nft", "Symbol NFT", 100), Ownable {
    using Strings for uint256;

    string public baseURI;
    string public baseExtension = ".json";
    string public notRevealedUri;
    uint256 public cost = 0.0375 ether;
    uint256 public maxSupply = 4000;
    uint256 public maxMintAmount = 20;
    uint256 public nftPerAddressLimit = 3;
    bool public paused = false;
    bool public revealed = false;
    bool public onlyWhitelisted = true;
    mapping(address => uint256) public addressMintedBalance;

    // white list variables
    uint256 public itemPricePresale = 0.025 ether;
    bool public isAllowListActive;
    uint256 public allowListMaxMint = 3;
    mapping(address => bool) public onAllowList;
    mapping(address => uint256) public allowListClaimedBy;

    //   constructor(

    //   ) ERC721("UFBro Aliens", "UFBRO") {

    //     string memory _initBaseURI="";
    //     string memory _initNotRevealedUri="";
    //     setBaseURI(_initBaseURI);
    //     setNotRevealedURI(_initNotRevealedUri);
    //   }

    // constructor(
    //     string memory _name,
    //     string memory _symbol,
    //     string memory _initBaseURI,
    //     string memory _initNotRevealedUri
    // ) ERC721A(_name, _symbol, 1000) {
    //     setBaseURI(_initBaseURI);
    //     setNotRevealedURI(_initNotRevealedUri);
    // }

    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    ////////////////////
    //   ALLOWLIST    //
    ////////////////////

    function addToAllowList(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++)
            onAllowList[addresses[i]] = true;
    }

    function removeFromAllowList(address[] calldata addresses)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < addresses.length; i++)
            onAllowList[addresses[i]] = false;
    }

    function purchasePresaleTokens(uint256 _mintAmount) external payable {
        require(_mintAmount > 0, "need to mint at least 1 NFT");
        uint256 supply = totalSupply();

        require(supply <= 555, "Presale is sold out.");

        require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
        require(isAllowListActive, "Allowlist is not active");
        require(onAllowList[msg.sender], "You are not in allowlist");
        require(
            allowListClaimedBy[msg.sender] + _mintAmount <= allowListMaxMint,
            "Purchase exceeds max allowed"
        );
        require(
            msg.value >= _mintAmount * itemPricePresale,
            "Try to send more ETH"
        );

        allowListClaimedBy[msg.sender] += _mintAmount;

        _safeMint(msg.sender, _mintAmount);
    }

    // public
    function mint(uint256 _mintAmount) public payable {
        require(!paused, "the contract is paused");
        uint256 supply = totalSupply();
        require(_mintAmount > 0, "need to mint at least 1 NFT");
        require(
            _mintAmount <= maxMintAmount,
            "max mint amount per session exceeded"
        );
        require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
        require(msg.value >= cost * _mintAmount, "insufficient funds");

        _safeMint(msg.sender, _mintAmount);
    }

    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        if (revealed == false) {
            return notRevealedUri;
        }

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        (tokenId + 1).toString(),
                        baseExtension
                    )
                )
                : "";
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

    function setBaseExtension(string memory _newBaseExtension)
        public
        onlyOwner
    {
        baseExtension = _newBaseExtension;
    }

    function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
        notRevealedUri = _notRevealedURI;
    }

    // set limit of allowlist
    function setAllowListMaxMint(uint256 _allowListMaxMint) external onlyOwner {
        allowListMaxMint = _allowListMaxMint;
    }

    // Change presale price in case of ETH price changes too much
    function setPricePresale(uint256 _itemPricePresale) external onlyOwner {
        itemPricePresale = _itemPricePresale;
    }

    function setIsAllowListActive(bool _isAllowListActive) external onlyOwner {
        isAllowListActive = _isAllowListActive;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function setOnlyWhitelisted(bool _state) public onlyOwner {
        onlyWhitelisted = _state;
    }

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success);
    }

    ///////////////////////////////////
    //       AIRDROP CODE STARTS     //
    ///////////////////////////////////

    // Send NFTs to a list of addresses
    function giftNftToList(address[] calldata _sendNftsTo) external onlyOwner {
        require(
            totalSupply() + _sendNftsTo.length <= maxSupply,
            "max NFT limit exceeded"
        );

        for (uint256 i = 0; i < _sendNftsTo.length; i++)
            _safeMint(_sendNftsTo[i], 1);
    }

    // Send NFTs to a single address
    function giftNftToAddress(address _sendNftsTo, uint256 _howMany)
        external
        onlyOwner
    {
        require(
            totalSupply() + _howMany <= maxSupply,
            "max NFT limit exceeded"
        );

        _safeMint(_sendNftsTo, _howMany);
    }
}
