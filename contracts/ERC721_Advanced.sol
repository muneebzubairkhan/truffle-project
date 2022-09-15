// Crypto Kings Club
// 10,000 Kings are Invading the Metaverse to takeover their throne as the rightful rulers

// Website:
// OpenSea:
// Discord:
// Instagram:
// Twitter:
// Youtube:

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";

// import "erc721a@3.3.0/contracts/ERC721A.sol";
// import "erc721a@3.3.0/contracts/extensions/ERC721ABurnable.sol";
// import "erc721a@3.3.0/contracts/extensions/ERC721AQueryable.sol";

contract CryptoKingsClub is ERC721A("IIIIIIIIIIII", "IIIIIIIIIIII"), ERC721AQueryable, ERC721ABurnable, ERC2981, Ownable, ReentrancyGuard {
    // Main Sale
    uint256 public itemPrice = 0.12 ether;
    uint256 public constant maxSupply = 4999;
    uint256 public saleActiveTime = type(uint256).max;
    string public imagesFolder = "ipfs://QmNQnbjuesfcSMzcDShxZU1oGQjXaQWvYXchNYWHeieonh/";

    // Whitelist
    bytes32 public whitelistMerkleRoot;
    uint256 public itemPriceWhitelist = 0.09 ether;
    uint256 public whitelistActiveTime = type(uint256).max;

    // Per Wallet Limit
    uint256 public maxKingsPerWallet = 2;

    // Auto Approve Marketplaces
    mapping(address => bool) public approvedProxy;

    constructor() {
        _setDefaultRoyalty(msg.sender, 10_00); // 10.00%
    }

    /// @notice Purchase multiple NFTs at once
    function purchaseKings(uint256 _qty) external payable nonReentrant {
        _safeMint(msg.sender, _qty);

        require(totalSupply() <= maxSupply, "Try mint less");
        require(tx.origin == msg.sender, "The caller is a contract");
        require(block.timestamp > saleActiveTime, "Sale is not active");
        require(msg.value == _qty * itemPrice, "Try to send exact amount of ETH");
        require(_numberMinted(msg.sender) <= maxKingsPerWallet, "max kings per wallet reached");
    }

    /// @notice Owner can withdraw from here
    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    /// @notice Change price in case of ETH price changes too much
    function setPrice(uint256 _newPrice) external onlyOwner {
        itemPrice = _newPrice;
    }
   
    function setMaxKingsPerWallet(uint256 _maxKingsPerWallet) external onlyOwner {
        maxKingsPerWallet = _maxKingsPerWallet;
    }

    /// @notice set sale active time
    function setSaleActiveTime(uint256 _saleActiveTime) external onlyOwner {
        saleActiveTime = _saleActiveTime;
    }

    /// @notice Hide identity or show identity from here, put images folder here, ipfs folder cid
    function setImagesFolder(string memory __imagesFolder) external onlyOwner {
        imagesFolder = __imagesFolder;
    }

    /// @notice Send NFTs to a list of addresses
    function giftNft(address[] calldata _sendNftsTo, uint256 _qty) external onlyOwner {
        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _qty);
        require(totalSupply() <= maxSupply, "Try minting less");
    }

    ////////////////////
    // SYSTEM METHODS //
    ////////////////////

    function _baseURI() internal view override returns (string memory) {
        return imagesFolder;
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, IERC165, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) external onlyOwner {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }

    receive() external payable {}

    function receiveCoin() external payable {}

    ///////////////////////////////
    // AUTO APPROVE MARKETPLACES //
    ///////////////////////////////

    function autoApproveMarketplace(address _marketplace) external onlyOwner {
        approvedProxy[_marketplace] = !approvedProxy[_marketplace];
    }

    function isApprovedForAll(address _owner, address _operator) public view override(ERC721A, IERC721) returns (bool) {
        return approvedProxy[_operator] ? true : super.isApprovedForAll(_owner, _operator);
    }

    ////////////////
    // Whitelist  //
    ////////////////

    function purchaseKingsWhitelist(uint256 _qty, bytes32[] calldata _proof) external payable nonReentrant {
        _safeMint(msg.sender, _qty);

        require(totalSupply() <= maxSupply, "Try mint less");
        require(tx.origin == msg.sender, "The caller is a contract");
        require(inWhitelist(msg.sender, _proof), "You are not in whitelist");
        require(block.timestamp > whitelistActiveTime, "Whitelist is not active");
        require(msg.value == _qty * itemPriceWhitelist, "Try to send exact amount of ETH");
        require(_numberMinted(msg.sender) <= maxKingsPerWallet, "max kings per wallet reached");
    }

    function inWhitelist(address _owner, bytes32[] memory _proof) public view returns (bool) {
        return MerkleProof.verify(_proof, whitelistMerkleRoot, keccak256(abi.encodePacked(_owner)));
    }

    function setWhitelistActiveTime(uint256 _whitelistActiveTime) external onlyOwner {
        whitelistActiveTime = _whitelistActiveTime;
    }

    function setWhitelistItemPrice(uint256 _itemPriceWhitelist) external onlyOwner {
        itemPriceWhitelist = _itemPriceWhitelist;
    }

    function setWhitelist(bytes32 _whitelistMerkleRoot) external onlyOwner {
        whitelistMerkleRoot = _whitelistMerkleRoot;
    }
}
