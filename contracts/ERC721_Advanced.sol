//  Nft Comics
//   _   _ ______ _______
//  | \ | |  ____|__   __|
//  |  \| | |__     | |___
//  | . ` |  __|    | / __|
//  | |\  | |       | \__ \
//  |_| \_|_|       |_|___/

// Website:  http://Nft.club/
// OpenSea:  http://opensea.club/abc/
// SPDX-License-Identifier: MIT
// turn on Optimization, 200
// Etherscan https://rinkeby.etherscan.io/address/0x9ae544af99bda9441787b42533044943ee4b493f#code

pragma solidity ^0.8.0;

import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract NftComics is ERC721A("Nft Comics", "NFTC"), ERC721ABurnable, ERC2981 {
    //
    uint256 public maxSupply = 20_000;
    uint256 public itemPrice = 0.02 ether;
    uint256 public itemPriceErc20 = 200 ether;
    uint256 public itemPriceHolder = 0.01 ether;
    uint256 public saleActiveTime = block.timestamp + 365 days; // test with calculated vs a+b gas diff;
    uint256 public saleActiveTimeErc20 = block.timestamp + 365 days;
    address public erc20 = 0xc3D6F4b97292f8d48344B36268BDd7400180667E; // To Buy In Token, USDT Token
    address public erc721ToHold = 0x350b4CdD07CC5836e30086b993D27983465Ec014; // To Hold Token, Nft
    string public baseURI = "ipfs://QmZdX7nh6CEcXzaicfUm1Qt6o4YsFEvTM6jueyNce5Uwjf/"; // confirm it

    constructor() {
        _setDefaultRoyalty(msg.sender, 10_00); // 10.00 %
        // flipProxyState(0x1AA777972073Ff66DCFDeD85749bDD555C0665dA);
        _safeMint(msg.sender, 2);
    }

    modifier onlyOwner() {
        require(0xe2c135274428FF8183946c3e46560Fa00353753A == msg.sender, "Caller is not the owner");
        _;
    }

    ///////////////////////////////////
    //    PUBLIC SALE CODE STARTS    //
    ///////////////////////////////////

    /// @notice Purchase multiple NFTs at once
    function purchaseTokens(uint256 _howMany) external payable saleActive callerIsUser mintLimit(_howMany) priceAvailable(_howMany) tokensAvailable(_howMany) {
        _safeMint(msg.sender, _howMany);
    }

    /// @notice Purchase multiple NFTs at once
    function purchaseTokensErc20(uint256 _howMany) external callerIsUser saleActiveErc20 mintLimit(_howMany) tokensAvailable(_howMany) priceAvailableERC20(_howMany) {
        _safeMint(msg.sender, _howMany);
    }

    //////////////////////////
    // ONLY OWNER METHODS   //
    //////////////////////////

    /// @notice Owner can withdraw from here
    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    /// @notice Owner can withdraw from here
    function withdrawERC20(address _erc20) external onlyOwner {
        IERC20(_erc20).transferFrom(address(this), msg.sender, IERC20(_erc20).balanceOf(address(this)));
    }

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

    // test multicall
    /// @notice get all nfts of a person
    function walletOfOwner(address _owner) external view returns (uint256[] memory) {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) tokenIds[i] = tokenOfOwnerByIndex(_owner, i);

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

    ///////////////////
    //  HELPER CODE  //
    ///////////////////

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is a contract");
        _;
    }

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
        if (IERC721(erc721ToHold).balanceOf(msg.sender) > 0) require(msg.value >= _howMany * itemPriceHolder, "Try to send more ETH");
        else require(msg.value >= _howMany * itemPrice, "Try to send more ETH");
        _;
    }

    modifier priceAvailableERC20(uint256 _howMany) {
        require(IERC20(erc20).transferFrom(msg.sender, address(this), _howMany * itemPriceErc20), "Try to send more ERC20");
        _;
    }

    ///////////////////////////////
    // AUTO APPROVE MARKETPLACES //
    ///////////////////////////////

    mapping(address => bool) public projectProxy; // check public vs private vs internal gas

    function flipProxyState(address proxyAddress) public onlyOwner {
        projectProxy[proxyAddress] = !projectProxy[proxyAddress];
    }

    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {
        // OPENSEA
        if (_operator == OpenSea(0xa5409ec958C83C3f309868babACA7c86DCB077c1).proxies(_owner)) return true;
        // LOOKSRARE
        else if (_operator == 0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e) return true;
        // RARIBLE
        else if (_operator == 0x4feE7B061C97C9c496b01DbcE9CDb10c02f0a0Be) return true;
        // X2Y2
        else if (_operator == 0xF849de01B080aDC3A814FaBE1E2087475cF2E354) return true;
        // ANY OTHER Marketpalce
        else if (projectProxy[_operator]) return true;
        return super.isApprovedForAll(_owner, _operator);
    }

    // test with self nfts transfer, also try mulicall openzeppelin
    // send multiple nfts
    function bulkTransferERC721(
        IERC721 _token,
        address[] calldata _to,
        uint256[] calldata _id
    ) external {
        if (_to.length == _id.length) revert();

        for (uint256 i = 0; i < _to.length; i++) _token.transferFrom(msg.sender, _to[i], _id[i]);
    }

    // _startTokenId from 1 not 0
    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function burn(uint256 tokenId) public override {
        super._burn(tokenId);
        _resetTokenRoyalty(tokenId);
    }

    function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) public onlyOwner {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }
}

interface OpenSea {
    function proxies(address) external view returns (address);
}

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract PresaleNft is NftComics {
    // multiple presale configs
    mapping(uint256 => uint256) public maxMintPresales;
    mapping(uint256 => uint256) public itemPricePresales;
    mapping(uint256 => bytes32) public whitelistMerkleRoots;
    uint256 public presaleActiveTime = block.timestamp + 365 days;

    // multicall inWhitelist
    function inWhitelist(
        address _owner,
        bytes32[] memory _proof,
        uint256 _from,
        uint256 _to
    ) external view returns (uint256) {
        for (uint256 i = _from; i < _to; i++) if (_inWhitelist(_owner, _proof, i)) return i;
        return type(uint256).max;
    }

    function _inWhitelist(
        address _owner,
        bytes32[] memory _proof,
        uint256 _rootNumber
    ) private view returns (bool) {
        return MerkleProof.verify(_proof, whitelistMerkleRoots[_rootNumber], keccak256(abi.encodePacked(_owner)));
    }

    function purchasePresaleTokens(
        uint256 _howMany,
        bytes32[] calldata _proof,
        uint256 _rootNumber
    ) external payable callerIsUser tokensAvailable(_howMany) {
        require(block.timestamp > presaleActiveTime, "Presale is not active");
        require(_inWhitelist(msg.sender, _proof, _rootNumber), "You are not in presale");
        require(_numberMinted(msg.sender) <= maxMintPresales[_rootNumber], "Purchase exceeds max allowed");
        require(msg.value >= _howMany * itemPricePresales[_rootNumber], "Try to send more ETH");

        _safeMint(msg.sender, _howMany);
    }

    function setPresale(
        uint256 _rootNumber,
        bytes32 _whitelistMerkleRoot,
        uint256 _maxMintPresales,
        uint256 _itemPricePresale
    ) external onlyOwner {
        maxMintPresales[_rootNumber] = _maxMintPresales;
        itemPricePresales[_rootNumber] = _itemPricePresale;
        whitelistMerkleRoots[_rootNumber] = _whitelistMerkleRoot;
    }

    function setPresaleActiveTime(uint256 _presaleActiveTime) external onlyOwner {
        presaleActiveTime = _presaleActiveTime;
    }
}

/*
    using Address for address;
    using Strings for uint256;

    // Compiler will pack this into a single 256bit word.
    struct TokenOwnership {
        // The address of the owner.
        address addr;
        // Keeps track of the start time of ownership with minimal overhead for tokenomics.
        uint64 startTimestamp;
        // Whether the token has been burned.
        bool burned;
    }

    // Compiler will pack this into a single 256bit word.
    struct AddressData {
        // Realistically, 2**64-1 is more than enough.
        uint64 balance;
        // Keeps track of mint count with minimal overhead for tokenomics.
        uint64 numberMinted;
        // Keeps track of burn count with minimal overhead for tokenomics.
        uint64 numberBurned;
        // For miscellaneous variable(s) pertaining to the address
        // (e.g. number of whitelist mint slots used).
        // If there are multiple variables, please pack them into a uint64.
        uint64 aux;
    }

    // The tokenId of the next token to be minted.
    uint256 internal _currentIndex;

    // The number of tokens burned.
    uint256 internal _burnCounter;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to ownership details
    // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
    mapping(uint256 => TokenOwnership) internal _ownerships;

    // Mapping owner address to address data
    mapping(address => AddressData) private _addressData;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

*/
