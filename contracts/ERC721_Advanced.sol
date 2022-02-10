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
    //
    uint256 public maxSupply = 20_000;
    uint256 public itemPrice = 0.02 ether;
    uint256 public itemPriceErc20 = 200 ether;
    uint256 public itemPriceHolder = 0.01 ether;
    uint256 public saleActiveTime = block.timestamp + 1 days;
    uint256 public saleActiveTimeErc20 = block.timestamp + 365 days;
    string public baseURI = "ipfs://QmVTNcKHkqF9LBAKsUJ5AjuRzNMLGwpgqmtE445drcktnx/";
    // address public erc20 = 0xc3D6F4b97292f8d48344B36268BDd7400180667E; // IGLOO TOKEN (ERC20)
    // address public erc20 = 0xEf44f26371BF874b5D4c8b49914af169336bc957; // Rinkeby USDC TOKEN ERC20
    address public erc20 = 0xd9145CCE52D386f254917e481eB44e9943F39138; // Remix USDC TOKEN ERC20
    // address public erc721 = 0x350b4CdD07CC5836e30086b993D27983465Ec014; // Bastard Penguins Mainnet
    address public erc721 = 0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8; // Testnet Rinkeby Bastard Penguins

    ///////////////////////////////////
    //    PUBLIC SALE CODE STARTS    //
    ///////////////////////////////////

    /// @notice Purchase multiple NFTs at once
    function purchaseTokens(uint256 _howMany)
        external
        payable
        saleActive
        mintLimit(_howMany)
        priceAvailable(_howMany)
        tokensAvailable(_howMany)
    {
        _safeMint(msg.sender, _howMany);
    }

    /// @notice Purchase multiple NFTs at once
    function purchaseTokensErc20(uint256 _howMany)
        external
        saleActiveErc20
        mintLimit(_howMany)
        tokensAvailable(_howMany)
        priceAvailableERC20(_howMany)
    {
        _safeMint(msg.sender, _howMany);
    }

    //////////////////////////
    // ONLY OWNER METHODS   //
    //////////////////////////

    modifier onlyOwner() {
        // require(0xe2c135274428FF8183946c3e46560Fa00353753A == msg.sender, "Caller is not the owner"); // Mainnet
        // require(0xc18E78C0F67A09ee43007579018b2Db091116B4C == msg.sender, "Caller is not the owner"); // Testnet Rinkeby
        require(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4 == msg.sender, "Caller is not the owner");
        _;
    }

    /// @notice Owner can withdraw from here
    function withdraw() external onlyOwner {
        payable(0xe2c135274428FF8183946c3e46560Fa00353753A).transfer(address(this).balance);
    }

    // todo and see gas savings we can combine all of below in 1 function

    /// @notice Change price in case of ETH price changes too much
    function setPrice(uint256 _newPrice, uint256 _newPriceHolder) external onlyOwner {
        itemPrice = _newPrice;
        itemPriceHolder = _newPriceHolder;
    }

    /// @notice set sale active time
    function setSaleActiveTime(uint256 _saleActiveTime, uint256 _saleActiveTimeErc20) external onlyOwner {
        saleActiveTime = _saleActiveTime;
        saleActiveTimeErc20 = _saleActiveTimeErc20;
    }

    /// @notice Hide identity or show identity from here, put images folder here, ipfs folder cid
    function setBaseURI(string memory __baseURI) external onlyOwner {
        baseURI = __baseURI;
    }

    /// @notice set max supply of nft
    function setMaxSupply(uint256 _maxSupply) external onlyOwner {
        maxSupply = _maxSupply;
    }

    /// @notice set itemPrice in Erc20
    function setErc20(address _erc20) external onlyOwner {
        erc20 = _erc20;
    }

    /// @notice set itemPrice in Erc20
    function setItemPriceErc20(uint256 _itemPriceErc20) external onlyOwner {
        itemPriceErc20 = _itemPriceErc20;
    }

    ///////////////////////////////////
    //       AIRDROP CODE STARTS     //
    ///////////////////////////////////

    /// @notice Send NFTs to a list of addresses
    function giftNft(address[] calldata _sendNftsTo, uint256 _howMany) external onlyOwner tokensAvailable(_sendNftsTo.length * _howMany) {
        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _howMany);
    }

    ///////////////////
    // QUERY METHOD  //
    ///////////////////

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    /// @notice get all nfts of a person
    /// @dev  try multicall on ui to remove this function, also muticall on send tx.
    function walletOfOwner(address _owner) external view returns (uint256[] memory) {
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

    modifier saleActiveErc20() {
        require(block.timestamp > saleActiveTimeErc20, "Sale is not active");
        _;
    }

    modifier mintLimit(uint256 _howMany) {
        require(_howMany >= 1 && _howMany <= 20, "Mint min 1, max 20");
        _;
    }

    modifier tokensAvailable(uint256 _howMany) {
        require(_howMany <= maxSupply - totalSupply(), "Try minting less tokens");
        _;
    }

    modifier priceAvailable(uint256 _howMany) {
        if (IERC721(erc721).balanceOf(msg.sender) > 0) require(msg.value >= _howMany * itemPriceHolder, "Try to send more ETH");
        else require(msg.value >= _howMany * itemPrice, "Try to send more ETH");
        _;
    }

    modifier priceAvailableERC20(uint256 _howMany) {
        require(IERC20(erc20).transferFrom(msg.sender, address(this), _howMany * itemPriceErc20), "Try to send more ERC20");
        _;
    }

    //////////////////////////////////////
    // AUTO APPROVE OPENSEA & LOOKSRARE //
    //////////////////////////////////////

    // Rinkeby
    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {
        /// @dev todo check gas on local vs global variable

        if (_operator == 0x1AA777972073Ff66DCFDeD85749bDD555C0665dA) return true;
        // LOOKSRARE
        else if (_operator == OpenSea(0xF57B2c51dED3A29e6891aba85459d600256Cf317).proxies(_owner)) return true; // OPENSEA
        return super.isApprovedForAll(_owner, _operator);
    }

    // function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {
    //     /// @dev todo check gas on local vs global variable

    //     if (_operator == 0x59728544B08AB483533076417FbBB2fD0B17CE3a) return true; // LOOKSRARE
    //     else if (_operator == OpenSea(0xa5409ec958C83C3f309868babACA7c86DCB077c1).proxies(_owner)) return true; // OPENSEA
    //     return super.isApprovedForAll(_owner, _operator);
    // }

    // send multiple nfts
    function bulkERC721Nfts(
        IERC721 _token,
        address[] calldata _to,
        uint256[] calldata _id
    ) external {
        require(_to.length == _id.length, "Receivers and IDs are different length");

        for (uint256 i = 0; i < _to.length; i++) _token.safeTransferFrom(msg.sender, _to[i], _id[i]);
    }
}

interface OpenSea {
    function proxies(address) external view returns (address);
}

interface IERC20 {
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

// 2403727 * 0.000000050 = 0.12018635
// rename vars to special variables like erc721 to penguins
