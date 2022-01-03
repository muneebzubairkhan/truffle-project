// Hi. If you have any questions or comments in this smart contract please let me know at:
// muneeb.zubair.hash@gmail.com, Whatsapp +923014440289, Telegram @thinkmuneeb, discord: timon#1213, I'm Muneeb Zubair Khan
//
//
// Smart Contract Made by Muneeb Zubair Khan
// The UI is made by Abraham Peter, abraham.peter.hash@gmail.com, Whatsapp +923004702553, Telegram @Abrahampeterhash.
//
//
//
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SnowiesClub is ERC721("Snowies Club", "SNOC") {
    bool public isSaleActive;
    uint256 public itemPrice = 0.125 ether;

    uint256 public circulatingSupply;
    uint256 public reservedSupply = 130;
    uint256 public totalSupply = 10_030;

    address public owner = 0xc18E78C0F67A09ee43007579018b2Db091116B4C;
    address public dev = 0xc66C9f79AAa0c8E6F3d12C4eFc7D7FE7c1f8B89C;

    string public baseURI = "ipfs://QmWF7xMCdMJvHq5G1mXHvJ97brA7VggWR7tT6Cu2vKvH2i/";

    constructor () {
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
        require(isSaleActive, "Sale is not active");
        require(_howMany <= 10, "Mint max 10");
        require(msg.value == _howMany * itemPrice, "Send exact tokens");

        if(_howMany == 10) _howMany++; // some one mints 10 he get 1 nft extra

        for (uint256 i = 0; i < _howMany; i++)
            _mint(msg.sender, ++circulatingSupply);
    }

    //////////////////////////
    // Only Owner Methods   //
    //////////////////////////

    function stopSale() external onlyOwner {
        isSaleActive = false;
    }

    function startSale() external onlyOwner {
        isSaleActive = true;
    }

    // Owner can withdraw ETH from here
    function withdrawETH() external onlyOwner {
        uint256 balance = address(this).balance;

        uint256 _15_percent = (balance * 0.15 ether) / 1 ether;
        uint256 _85_percent = (balance * 0.85 ether) / 1 ether;

        payable(dev).transfer(_15_percent);
        payable(owner).transfer(_85_percent);
    }

    // Change price in case of token prices changes too much
    function setPrice(uint256 _newPrice) external onlyOwner {
        itemPrice = _newPrice;
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

    ///////////////////
    //  Helper Code  //
    ///////////////////

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    modifier tokensAvailable(uint256 _howMany) {
        require(_howMany <= totalSupply - circulatingSupply - reservedSupply, "Try minting less tokens");
        _;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Caller is not the owner");
        _;
    }
}