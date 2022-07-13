// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

import "erc721a@3.3.0/contracts/ERC721A.sol";
import "erc721a@3.3.0/contracts/extensions/ERC721ABurnable.sol";
import "erc721a@3.3.0/contracts/extensions/ERC721AQueryable.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract JohnSale is ERC721A("John", "J"), Ownable, ERC721AQueryable, ERC721ABurnable, ERC2981 {
    uint256 public constant maxSupply = 1000;
    uint256 public reservedJohn = 10;

    uint256 public freeJohn = 0;
    uint256 public freeMaxJohnPerWallet = 0;
    uint256 public freeSaleActiveTime = type(uint256).max;

    uint256 public firstFreeMints = 11;
    uint256 public maxJohnPerWallet = 22;
    uint256 public johnPrice = 0.0001 ether;
    uint256 public saleActiveTime = type(uint256).max;

    string johnMetadataURI;

    constructor() {
        _mint(msg.sender, 3);
    }

    function buyJohn(uint256 _johnQty) external payable saleActive(saleActiveTime) callerIsUser mintLimit(_johnQty, maxJohnPerWallet) priceAvailableFirstNftFree(_johnQty) johnAvailable(_johnQty) {
        require(_totalMinted() >= freeJohn, "Get your John for free");

        _mint(msg.sender, _johnQty);
    }

    function buyJohnFree(uint256 _johnQty) external saleActive(freeSaleActiveTime) callerIsUser mintLimit(_johnQty, freeMaxJohnPerWallet) johnAvailable(_johnQty) {
        require(_totalMinted() < freeJohn, "John max free limit reached");

        _mint(msg.sender, _johnQty);
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function setJohnPrice(uint256 _newPrice) external onlyOwner {
        johnPrice = _newPrice;
    }

    function setFreeJohn(uint256 _freeJohn) external onlyOwner {
        freeJohn = _freeJohn;
    }

    function setFirstFreeMints(uint256 _firstFreeMints) external onlyOwner {
        firstFreeMints = _firstFreeMints;
    }

    function setReservedJohn(uint256 _reservedJohn) external onlyOwner {
        reservedJohn = _reservedJohn;
    }

    function setMaxJohnPerWallet(uint256 _maxJohnPerWallet, uint256 _freeMaxJohnPerWallet) external onlyOwner {
        maxJohnPerWallet = _maxJohnPerWallet;
        freeMaxJohnPerWallet = _freeMaxJohnPerWallet;
    }

    function setSaleActiveTime(uint256 _saleActiveTime, uint256 _freeSaleActiveTime) external onlyOwner {
        saleActiveTime = _saleActiveTime;
        freeSaleActiveTime = _freeSaleActiveTime;
    }

    function setJohnMetadataURI(string memory _johnMetadataURI) external onlyOwner {
        johnMetadataURI = _johnMetadataURI;
    }

    function giftJohn(address[] calldata _sendNftsTo, uint256 _johnQty) external onlyOwner johnAvailable(_sendNftsTo.length * _johnQty) {
        reservedJohn -= _sendNftsTo.length * _johnQty;
        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _johnQty);
    }

    function _baseURI() internal view override returns (string memory) {
        return johnMetadataURI;
    }

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is a sm");
        _;
    }

    modifier saleActive(uint256 _saleActiveTime) {
        require(block.timestamp > _saleActiveTime, "Sorry but sale is not open");
        _;
    }

    modifier mintLimit(uint256 _johnQty, uint256 _maxJohnPerWallet) {
        require(_numberMinted(msg.sender) + _johnQty <= _maxJohnPerWallet, "John max x wallet exceeded");
        _;
    }

    modifier johnAvailable(uint256 _johnQty) {
        require(_johnQty + totalSupply() + reservedJohn <= maxSupply, "Currently are sold out");
        _;
    }

    modifier priceAvailable(uint256 _johnQty) {
        require(msg.value == _johnQty * johnPrice, "Hey hey, send the right amount of ETH");
        _;
    }

    function getPrice(uint256 _qty) public view returns (uint256 price) {
        uint256 totalPrice = _qty * johnPrice;
        uint256 numberMinted = _numberMinted(msg.sender);
        uint256 discountQty = firstFreeMints > numberMinted ? firstFreeMints - numberMinted : 0;
        uint256 discount = discountQty * johnPrice;
        price = totalPrice > discount ? totalPrice - discount : 0;
    }

    modifier priceAvailableFirstNftFree(uint256 _johnQty) {
        require(msg.value == getPrice(_johnQty), "Hey hey, send the right amount of ETH");
        _;
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, IERC165, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setRoyalty(address _receiver, uint96 _feeNumerator) public onlyOwner {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }
}

contract JohnApprovesMarketplaces is JohnSale {
    mapping(address => bool) private allowed;

    function autoApproveMarketplace(address _spender) public onlyOwner {
        allowed[_spender] = !allowed[_spender];
    }

    function isApprovedForAll(address _owner, address _operator) public view override(ERC721A, IERC721) returns (bool) {
        // Opensea, LooksRare, Rarible, X2y2, Any Other Marketplace

        if (_operator == OpenSea(0xa5409ec958C83C3f309868babACA7c86DCB077c1).proxies(_owner)) return true;
        else if (_operator == 0xf42aa99F011A1fA7CDA90E5E98b277E306BcA83e) return true;
        else if (_operator == 0x4feE7B061C97C9c496b01DbcE9CDb10c02f0a0Be) return true;
        else if (_operator == 0xF849de01B080aDC3A814FaBE1E2087475cF2E354) return true;
        else if (allowed[_operator]) return true;
        return super.isApprovedForAll(_owner, _operator);
    }
}

contract JohnStaking is JohnApprovesMarketplaces {
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
        require(!staked[startTokenId], "Nope, unstake your John first");
    }

    function stakeJohn(uint256[] calldata _tokenIds, bool _stake) external onlyWhitelistedForStaking {
        for (uint256 i = 0; i < _tokenIds.length; i++) staked[_tokenIds[i]] = _stake;
    }
}

interface OpenSea {
    function proxies(address) external view returns (address);
}

contract John is JohnStaking {}
