// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";

contract BBSale is ERC721A("BB", "BB"), Ownable, ERC721AQueryable, ERC721ABurnable, ERC2981 {
    uint256 public constant maxSupply = 8888;
    uint256 public reservedBBs = 777;
    uint256 public maxBBsPerWallet = 10;

    uint256 public freeBBs = 2777;
    uint256 public freeMaxBBsPerWallet = 2;
    uint256 public freeSaleActiveTime = type(uint256).max;

    uint256 public bbPrice = 0.01 ether;
    uint256 public saleActiveTime = type(uint256).max;

    uint256 public firstFreeSaleActiveTime = type(uint256).max;

    string bbMetadataURI;

    function buyBBsPaid(uint256 _bbsQty) external payable saleActive(saleActiveTime) callerIsUser mintLimit(_bbsQty, maxBBsPerWallet) priceAvailable(_bbsQty) bbsAvailable(_bbsQty) {
        require(_totalMinted() >= freeBBs, "Get bbs for free");

        _mint(msg.sender, _bbsQty);
    }

    function buyBBsFirstFreeRestPaid(uint256 _bbsQty) external payable saleActive(firstFreeSaleActiveTime) callerIsUser mintLimit(_bbsQty, maxBBsPerWallet) priceAvailableFirstNftFree(_bbsQty) bbsAvailable(_bbsQty) {
        require(_totalMinted() >= freeBBs, "Get bbs for free");

        _mint(msg.sender, _bbsQty);
    }

    function buyBBsFree(uint256 _bbsQty) external saleActive(freeSaleActiveTime) callerIsUser mintLimit(_bbsQty, freeMaxBBsPerWallet) bbsAvailable(_bbsQty) {
        require(_totalMinted() < freeBBs, "Max free limit reached");

        _mint(msg.sender, _bbsQty);
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function setBBPrice(uint256 _newPrice) external onlyOwner {
        bbPrice = _newPrice;
    }

    function setFreeBBs(uint256 _freeBBs) external onlyOwner {
        freeBBs = _freeBBs;
    }

    function setReservedBBs(uint256 _reservedBBs) external onlyOwner {
        reservedBBs = _reservedBBs;
    }

    function setMaxBBsPerWallet(uint256 _maxBBsPerWallet, uint256 _freeMaxBBsPerWallet) external onlyOwner {
        maxBBsPerWallet = _maxBBsPerWallet;
        freeMaxBBsPerWallet = _freeMaxBBsPerWallet;
    }

    function setSaleActiveTime(
        uint256 _saleActiveTime,
        uint256 _freeSaleActiveTime,
        uint256 _firstFreeSaleActiveTime
    ) external onlyOwner {
        saleActiveTime = _saleActiveTime;
        freeSaleActiveTime = _freeSaleActiveTime;
        firstFreeSaleActiveTime = _firstFreeSaleActiveTime;
    }

    function setBBMetadataURI(string memory _bbMetadataURI) external onlyOwner {
        bbMetadataURI = _bbMetadataURI;
    }

    function giftBBs(address[] calldata _sendNftsTo, uint256 _bbsQty) external onlyOwner bbsAvailable(_sendNftsTo.length * _bbsQty) {
        reservedBBs -= _sendNftsTo.length * _bbsQty;
        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _bbsQty);
    }

    function _baseURI() internal view override returns (string memory) {
        return bbMetadataURI;
    }

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is a sm");
        _;
    }

    modifier saleActive(uint256 _saleActiveTime) {
        require(block.timestamp > _saleActiveTime, "Please, come back when the sale goes live");
        _;
    }

    modifier mintLimit(uint256 _bbsQty, uint256 _maxBBsPerWallet) {
        require(_numberMinted(msg.sender) + _bbsQty <= _maxBBsPerWallet, "Max x wallet exceeded");
        _;
    }

    modifier bbsAvailable(uint256 _bbsQty) {
        require(_bbsQty + totalSupply() + reservedBBs <= maxSupply, "Sorry, we are sold out");
        _;
    }

    modifier priceAvailable(uint256 _bbsQty) {
        require(msg.value == _bbsQty * bbPrice, "Please, send the exact amount of ETH");
        _;
    }

    function getPrice(uint256 _qty) public view returns (uint256 price) {
        if (_numberMinted(msg.sender) == 0) price = (_qty * bbPrice) - bbPrice;
        else price = _qty * bbPrice;
    }

    modifier priceAvailableFirstNftFree(uint256 _bbsQty) {
        require(msg.value == getPrice(_bbsQty), "Please, send the exact amount of ETH");
        _;
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, IERC721A, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setRoyalty(address _receiver, uint96 _feeNumerator) public onlyOwner {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }
}

contract BBApprovesMarketplaces is BBSale {
    mapping(address => bool) private allowed;

    function autoApproveMarketplace(address _spender) public onlyOwner {
        allowed[_spender] = !allowed[_spender];
    }

    function isApprovedForAll(address _owner, address _operator) public view override(ERC721A, IERC721A) returns (bool) {
        // Opensea, LooksRare, Rarible, X2y2, Any Other Marketplace

        if (_operator == OpenSea(0xa5409ec958C83C3f309868babACA7c86DCB077c1).proxies(_owner)) return true;
        else if (_operator == 0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e) return true;
        else if (_operator == 0x4feE7B061C97C9c496b01DbcE9CDb10c02f0a0Be) return true;
        else if (_operator == 0xF849de01B080aDC3A814FaBE1E2087475cF2E354) return true;
        else if (allowed[_operator]) return true;
        return super.isApprovedForAll(_owner, _operator);
    }
}

contract BBStaking is BBApprovesMarketplaces {
    mapping(address => bool) public canStake;

    function addToWhitelistForStaking(address _operator) external onlyOwner {
        canStake[_operator] = !canStake[_operator];
    }

    modifier onlyWhitelistedForStaking() {
        require(canStake[msg.sender], "This contract is not allowed to stake");
        _;
    }

    mapping(uint256 => bool) public staked;

    function _beforeTokenTransfers(
        address,
        address,
        uint256 startTokenId,
        uint256
    ) internal view override {
        require(!staked[startTokenId], "Please, unstake the NFT first");
    }

    function stakeBBs(uint256[] calldata _tokenIds, bool _stake) external onlyWhitelistedForStaking {
        for (uint256 i = 0; i < _tokenIds.length; i++) staked[_tokenIds[i]] = _stake;
    }
}

interface OpenSea {
    function proxies(address) external view returns (address);
}

contract BB is BBStaking {}
