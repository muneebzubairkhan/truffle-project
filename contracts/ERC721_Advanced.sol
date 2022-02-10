// UNDERGROUND APE CLUB

// Website:  https://undergroundape.club/
// Twitter:  https://twitter.com/undergroundapes
// Medium:   https://medium.com/@undegroundapeclub
// Discord:  https://discord.com/invite/undergroundapes
// Opensea:  https://opensea.io/assets/0xb94b38fcb227350989f95f54f54f43b5fcc3ccff/0
// Contract: https://etherscan.io/address/0xb94b38fcb227350989f95f54f54f43b5fcc3ccff#code

// SPDX-License-Identifier: MIT

// 2274943 * 0.000000050 = 0.11374714999999999
// 2268444 * 0.000000040 = 0.09073776 to 0.1134222
// 2217969
// 2206963 * 0.000000050 = 0.11034814999999999 = 0.08827852
// 2157041 * 0.000000050 = 0.10785204999999999

pragma solidity ^0.8.0;

import "erc721a/contracts/ERC721A.sol";

contract BastardPenguinsComics is ERC721A("Bastard Penguins Comics", "BPC") {
    string public baseURI = "ipfs://QmVTNcKHkqF9LBAKsUJ5AjuRzNMLGwpgqmtE445drcktnx/";

    uint256 public saleActiveTime = block.timestamp + 30 seconds;
    uint256 public itemPrice = 0.02 ether;

    uint256 public maxSupply = 20_000;

    ///////////////////////////////////
    //    PUBLIC SALE CODE STARTS    //
    ///////////////////////////////////

    /// @notice Purchase multiple NFTs at once
    function purchaseTokens(uint256 _howMany) external payable tokensAvailable(_howMany) priceAvailable(_howMany) saleActive {
        require(_howMany <= 20, "Mint min 1, max 20");

        _safeMint(msg.sender, _howMany);
    }

    //////////////////////////
    // ONLY OWNER METHODS   //
    //////////////////////////

    /// @notice Owner can withdraw from here
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;

        payable(0xc66C9f79AAa0c8E6F3d12C4eFc7D7FE7c1f8B89C).transfer((balance * 0.02 ether) / 1 ether);
        payable(0xc66C9f79AAa0c8E6F3d12C4eFc7D7FE7c1f8B89C).transfer(balance);
    }

    /// @notice Change price in case of ETH price changes too much
    function setPrice(uint256 _newPrice) external onlyOwner {
        itemPrice = _newPrice;
    }

    /// @notice set sale active time
    function setSaleActive(uint256 _saleActiveTime) external onlyOwner {
        saleActiveTime = _saleActiveTime;
    }

    /// @notice Hide identity or show identity from here, put images folder here, ipfs folder cid
    function setBaseURI(string memory __baseURI) external onlyOwner {
        baseURI = __baseURI;
    }

    /// @notice set max supply of nft
    function setMaxSupply(uint256 _maxSupply) external onlyOwner {
        maxSupply = _maxSupply;
    }

    ///////////////////////////////////
    //       AIRDROP CODE STARTS     //
    ///////////////////////////////////

    /// @notice Send NFTs to a list of addresses
    function giftNftToList(address[] calldata _sendNftsTo, uint256 _howMany) external onlyOwner tokensAvailable(_sendNftsTo.length) {
        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _howMany);
    }

    /// @notice Send NFTs to a single address
    function giftNftToAddress(address _sendNftsTo, uint256 _howMany) external onlyOwner tokensAvailable(_howMany) {
        _safeMint(_sendNftsTo, _howMany);
    }

    ///////////////////
    // QUERY METHOD  //
    ///////////////////

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    /// @notice get all nfts of a person
    /// @dev  try multicall on ui to remove this function
    function walletOfOwner(address _owner) public view returns (uint256[] memory) {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) tokenIds[i] = tokenOfOwnerByIndex(_owner, i);

        return tokenIds;
    }

    ///////////////////
    //  HELPER CODE  //
    ///////////////////

    modifier saleActive() {
        require(block.timestamp > saleActiveTime, "Sale is not active");
        _;
    }

    modifier tokensAvailable(uint256 _howMany) {
        require(_howMany <= maxSupply - totalSupply(), "Try minting less tokens");
        _;
    }

    modifier priceAvailable(uint256 _howMany) {
        require(msg.value >= _howMany * itemPrice, "Try to send more ETH");
        _;
    }

    modifier onlyOwner() {
        require(0xc18E78C0F67A09ee43007579018b2Db091116B4C == msg.sender, "Caller is not the owner");
        _;
    }

    //////////////////////////////////////
    // AUTO APPROVE OPENSEA & LOOKSRARE //
    //////////////////////////////////////

    // Opensea Registerar Mainnet 0xa5409ec958C83C3f309868babACA7c86DCB077c1
    // Opensea Registerar Rinkeby 0xF57B2c51dED3A29e6891aba85459d600256Cf317

    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {
        address openSeaRegistrar = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
        return ProxyRegisterar(openSeaRegistrar).proxies(_owner) == _operator ? true : super.isApprovedForAll(_owner, _operator);
    }

    // send multiple nfts
    function bulkERC721Nfts(
        IERC721 _token,
        address[] calldata _to,
        uint256[] calldata _id
    ) public {
        require(_to.length == _id.length, "Receivers and IDs are different length");

        for (uint256 i = 0; i < _to.length; i++) _token.safeTransferFrom(msg.sender, _to[i], _id[i]);
    }
}

interface ProxyRegisterar {
    function proxies(address) external view returns (address);
}
