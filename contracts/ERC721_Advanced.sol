// Hi. If you have any questions or comments in this smart contract please let me know at:
// Whatsapp +923014440289, Telegram @thinkmuneeb, discord: timon#1213, I'm Muneeb Zubair Khan
//
//
// Smart Contract Made by Muneeb Zubair Khan
// The UI is made by Abraham Peter, Whatsapp +923004702553, Telegram @Abrahampeterhash.
//
//
//
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "erc721a/contracts/ERC721A.sol";

contract Nft is ERC721A("Non Fungible Token", "NFT") {
    string public baseURI =
        "ipfs://QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/";

    bool public isSaleActive;
    uint256 public itemPrice = 0.15 ether;
    uint256 public itemPricePresale = 0.08 ether;
    uint256 public immutable maxSupply = 7999;

    // address public owner = 0xc18E78C0F67A09ee43007579018b2Db091116B4C;
    address public owner = msg.sender;
    address public dev = 0x903f0F7bBF9Ad74F50e58B5D32D2AcE3b358eA77;

    ///////////////////////////////
    //    PRESALE CODE STARTS    //
    ///////////////////////////////

    bool public isAllowlistActive;
    uint256 public allowlistMaxMint = 3;
    mapping(address => bool) public onAllowlist;
    mapping(address => uint256) public allowlistClaimedBy;

    function addToAllowlist(address[] calldata addresses, bool _add)
        external
        onlyOwner
    {
        for (uint256 i = 0; i < addresses.length; i++)
            onAllowlist[addresses[i]] = _add;
    }

    // Purchase multiple NFTs at once
    function purchasePresaleTokens(uint256 _howMany)
        external
        payable
        tokensAvailable(_howMany)
    {
        require(isAllowlistActive, "Allowlist is not active");
        require(onAllowlist[msg.sender], "You are not in allowlist");
        require(
            allowlistClaimedBy[msg.sender] + _howMany <= allowlistMaxMint,
            "Purchase exceeds max allowed"
        );
        require(
            msg.value >= _howMany * itemPricePresale,
            "Try to send more ETH"
        );

        allowlistClaimedBy[msg.sender] += _howMany;

        _safeMint(msg.sender, _howMany);
    }

    // set limit of allowlist
    function setAllowlistMaxMint(uint256 _allowlistMaxMint) external onlyOwner {
        allowlistMaxMint = _allowlistMaxMint;
    }

    // Change presale price in case of ETH price changes too much
    function setPricePresale(uint256 _itemPricePresale) external onlyOwner {
        itemPricePresale = _itemPricePresale;
    }

    function setIsAllowlistActive(bool _isAllowlistActive) external onlyOwner {
        isAllowlistActive = _isAllowlistActive;
    }

    ///////////////////////////////////
    //    PUBLIC SALE CODE STARTS    //
    ///////////////////////////////////

    // Purchase multiple NFTs at once
    function purchaseTokens(uint256 _howMany)
        external
        payable
        tokensAvailable(_howMany)
    {
        require(isSaleActive, "Sale is not active");
        require(_howMany > 0 && _howMany <= 10, "Mint min 1, max 10");
        require(msg.value >= _howMany * itemPrice, "Try to send more ETH");

        _safeMint(msg.sender, _howMany);
    }

    //////////////////////////
    // Only Owner Methods   //
    //////////////////////////

    // Owner can withdraw from here
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;

        uint256 _70_percent = (balance * 0.70 ether) / 1 ether;
        uint256 _30_percent = (balance * 0.30 ether) / 1 ether;

        payable(owner).transfer(_70_percent);
        payable(dev).transfer(_30_percent);
    }

    // Change price in case of ETH price changes too much
    function setPrice(uint256 _newPrice) external onlyOwner {
        itemPrice = _newPrice;
    }

    function setSaleActive(bool _isSaleActive) external onlyOwner {
        isSaleActive = _isSaleActive;
    }

    // Hide identity or show identity from here
    function setBaseURI(string memory __baseURI) external onlyOwner {
        baseURI = __baseURI;
    }

    ///////////////////////////////////
    //       AIRDROP CODE STARTS     //
    ///////////////////////////////////

    // Send NFTs to a list of addresses
    function giftNftToList(address[] calldata _sendNftsTo, uint256 _howMany)
        external
        onlyOwner
        tokensAvailable(_sendNftsTo.length)
    {
        for (uint256 i = 0; i < _sendNftsTo.length; i++)
            _safeMint(_sendNftsTo[i], _howMany);
    }

    // Send NFTs to a single address
    function giftNftToAddress(address _sendNftsTo, uint256 _howMany)
        external
        onlyOwner
        tokensAvailable(_howMany)
    {
        _safeMint(_sendNftsTo, _howMany);
    }

    ///////////////////
    // Query Method  //
    ///////////////////

    function tokensRemaining() public view returns (uint256) {
        return maxSupply - totalSupply();
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    ///////////////////
    //  Helper Code  //
    ///////////////////

    modifier tokensAvailable(uint256 _howMany) {
        require(_howMany <= tokensRemaining(), "Try minting less tokens");
        _;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Caller is not the owner");
        _;
    }

    /////////////////////
    // Staking Method  //
    /////////////////////

    // tokenId => staked (yes or no)
    mapping(uint256 => bool) public staked;
    mapping(address => bool) public whitelisted;

    function _beforeTokenTransfers(
        address,
        address,
        uint256 startTokenId,
        uint256 quantity
    ) internal view override {
        for (uint256 i = startTokenId; i < startTokenId + quantity; i++)
            require(!staked[i], "Unstake tokenId it to transfer");
    }

    // stake / unstake nfts
    function stakeNfts(uint256[] calldata _tokenIds, bool _stake)
        external
        onlyWhitelisted
    {
        for (uint256 i = 0; i < _tokenIds.length; i++)
            staked[_tokenIds[i]] = _stake;
    }

    // add / remove from whitelist who can stake / unstake
    function addToWhitelist(address _address, bool _add) external onlyOwner {
        whitelisted[_address] = _add;
    }

    modifier onlyWhitelisted() {
        require(whitelisted[msg.sender], "Caller is not whitelisted");
        _;
    }
}
