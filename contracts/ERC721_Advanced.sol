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

contract Boredsone is ERC721A("Boredsone", "BS"), ERC721AQueryable, ERC721ABurnable, ERC2981, Ownable, ReentrancyGuard {
    string baseURI = "ipfs://QmNQnbjuesfcSMzcDShxZU1oGQjXaQWvYXchNYWHeieonh/";
    uint256 saleActiveTime = type(uint256).max;
    uint256 constant maxSupply = 4999;
    uint256 itemPrice = 0.12 ether;

    constructor() {
        _setDefaultRoyalty(msg.sender, 10_00); // 10.00%
    }

    /// @notice Purchase multiple NFTs at once
    function purchaseTokens(uint256 _howMany) external payable nonReentrant {
        _safeMint(msg.sender, _howMany);

        require(totalSupply() <= maxSupply, "Try mint less");
        require(tx.origin == msg.sender, "The caller is a contract");
        require(_howMany <= 50, "Mint min 1, max 50");
        require(block.timestamp > saleActiveTime, "Sale is not active");
        require(msg.value == _howMany * itemPrice, "Try to send exact amount of ETH");
    }

    /// @notice Owner can withdraw from here
    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    /// @notice Change price in case of ETH price changes too much
    function setPrice(uint256 _newPrice) external onlyOwner {
        itemPrice = _newPrice;
    }

    /// @notice set sale active time
    function setSaleActiveTime(uint256 _saleActiveTime) external onlyOwner {
        saleActiveTime = _saleActiveTime;
    }

    /// @notice Hide identity or show identity from here, put images folder here, ipfs folder cid
    function setBaseURI(string memory __baseURI) external onlyOwner {
        baseURI = __baseURI;
    }

    /// @notice Send NFTs to a list of addresses
    function giftNft(address[] calldata _sendNftsTo, uint256 _howMany) external onlyOwner {
        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _howMany);
        require(totalSupply() <= maxSupply, "Try minting less");
    }

    ////////////////////
    // SYSTEM METHODS //
    ////////////////////

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
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

    function receiveCoin() external payable {}

    receive() external payable {}

    ///////////////////////////////
    // AUTO APPROVE MARKETPLACES //
    ///////////////////////////////

    mapping(address => bool) projectProxy;

    function flipProxyState(address proxyAddress) external onlyOwner {
        projectProxy[proxyAddress] = !projectProxy[proxyAddress];
    }

    function isApprovedForAll(address _owner, address _operator) public view override(ERC721A, IERC721) returns (bool) {
        return projectProxy[_operator] ? true : super.isApprovedForAll(_owner, _operator);
    }

    //////////////
    // Presale  //
    //////////////

    uint256 presaleActiveTime = 1650297600;
    uint256 itemPricePresale = 0.09 ether;
    bytes32 whitelistMerkleRoot;

    function purchaseTokensPresale(uint256 _howMany, bytes32[] calldata _proof) external payable nonReentrant {
        _safeMint(msg.sender, _howMany);

        require(totalSupply() <= maxSupply, "Try mint less");
        require(tx.origin == msg.sender, "The caller is a contract");
        require(_howMany <= 50, "Mint min 1, max 50");
        require(inWhitelist(msg.sender, _proof), "You are not in presale");
        require(block.timestamp > presaleActiveTime, "Presale is not active");
        require(msg.value == _howMany * itemPricePresale, "Try to send exact amount of ETH");
    }

    function inWhitelist(address _owner, bytes32[] memory _proof) public view returns (bool) {
        return MerkleProof.verify(_proof, whitelistMerkleRoot, keccak256(abi.encodePacked(_owner)));
    }

    function setPresaleActiveTime(uint256 _presaleActiveTime) external onlyOwner {
        presaleActiveTime = _presaleActiveTime;
    }

    function setPresaleItemPrice(uint256 _itemPricePresale) external onlyOwner {
        itemPricePresale = _itemPricePresale;
    }

    function setWhitelist(bytes32 _whitelistMerkleRoot) external onlyOwner {
        whitelistMerkleRoot = _whitelistMerkleRoot;
    }
}

interface OpenSea {
    function proxies(address) external view returns (address);
}
