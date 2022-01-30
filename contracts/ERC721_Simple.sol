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

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";


contract LazyPandas_Simple is ERC721("LazyPandas", "LPS"), ERC721Enumerable, ERC721Burnable {
    string public baseURI;
    bool public isSaleActive;
    uint256 public circulatingSupply;
    uint256 public itemPrice = 0.15 ether;
    uint256 public itemPricePresale = 0.08 ether;
    uint256 public constant maxSupply = 7999;

    address public owner = 0xc18E78C0F67A09ee43007579018b2Db091116B4C;
    address public dev = 0x903f0F7bBF9Ad74F50e58B5D32D2AcE3b358eA77;

    bool public isAllowListActive;
    uint256 public allowListMaxMint = 3;
    mapping(address => bool) public onAllowList;
    mapping(address => uint256) public allowListClaimedBy;

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

    ////////////////////
    //    PRESALE     //
    ////////////////////

    // Purchase multiple NFTs at once
    function purchasePresaleTokens(uint256 _howMany)
        external
        payable
        tokensAvailable(_howMany)
    {
        require(isAllowListActive, "Allowlist is not active");
        require(onAllowList[msg.sender], "You are not in allowlist");
        require(
            allowListClaimedBy[msg.sender] + _howMany <= allowListMaxMint,
            "Purchase exceeds max allowed"
        );
        require(
            msg.value >= _howMany * itemPricePresale,
            "Try to send more ETH"
        );

        allowListClaimedBy[msg.sender] += _howMany;

        for (uint256 i = 0; i < _howMany; i++)
            _mint(msg.sender, ++circulatingSupply);
    }

    ////////////////////
    //  PUBLIC SALE   //
    ////////////////////

    // Purchase multiple NFTs at once
    function purchaseTokens(uint256 _howMany)
        external
        payable
        tokensAvailable(_howMany)
    {
        require(
            isSaleActive,
            "Sale is not active"
        );
        require(_howMany > 0 && _howMany <= 10, "Mint min 1, max 10");
        require(msg.value >= _howMany * itemPrice, "Try to send more ETH");

        for (uint256 i = 0; i < _howMany; i++)
            _mint(msg.sender, ++circulatingSupply);
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

    // set limit of allowlist
    function setAllowListMaxMint(uint256 _allowListMaxMint) external onlyOwner {
        allowListMaxMint = _allowListMaxMint;
    }

    // Change price in case of ETH price changes too much
    function setPrice(uint256 _newPrice) external onlyOwner {
        itemPrice = _newPrice;
    }

    // Change presale price in case of ETH price changes too much
    function setPricePresale(uint256 _itemPricePresale) external onlyOwner {
        itemPricePresale = _itemPricePresale;
    }

    // Hide identity or show identity from here
    function setBaseURI(string memory __baseURI) external onlyOwner {
        baseURI = __baseURI;
    }

    // Send NFTs to a list of addresses
    function giftNftToList(address[] calldata _sendNftsTo)
        external
        onlyOwner
        tokensAvailable(_sendNftsTo.length)
    {
        for (uint256 i = 0; i < _sendNftsTo.length; i++)
            _mint(_sendNftsTo[i], ++circulatingSupply);
    }

    // Send NFTs to a single address
    function giftNftToAddress(address _sendNftsTo, uint256 _howMany)
        external
        onlyOwner
        tokensAvailable(_howMany)
    {
        for (uint256 i = 0; i < _howMany; i++)
            _mint(_sendNftsTo, ++circulatingSupply);
    }

    function setIsAllowListActive(bool _isAllowListActive) external onlyOwner {
        isAllowListActive = _isAllowListActive;
    }

    function setSaleActive(bool _isSaleActive) external onlyOwner {
        isSaleActive = _isSaleActive;
    }

    /*

     function setSaleActive() external onlyOwner {
        isSaleActive = true;
    }

    function setSaleNotActive() external onlyOwner {
        isSaleActive = false;
    }


    function flipSale() public onlyOwner {
        hasSaleStarted = !hasSaleStarted;
    }
    */

    ///////////////////
    // Query Method  //
    ///////////////////

    function tokensRemaining() public view returns (uint256) {
        return maxSupply - circulatingSupply;
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
        require(owner == msg.sender, "Ownable: caller is not the owner");
        _;
    }    

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}