// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "erc721a/contracts/ERC721A.sol";
import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";
// import "erc721a@3.3.0/contracts/ERC721A.sol";
// import "erc721a@3.3.0/contracts/extensions/ERC721ABurnable.sol";
// import "erc721a@3.3.0/contracts/extensions/ERC721AQueryable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract NftsSale is ERC721A("Nfts", "NN"), Ownable, ERC721AQueryable, ERC721ABurnable, ERC2981 {
    uint256 public freeNfts = 2000;
    uint256 public freeMaxNftsPerWallet = 2;
    uint256 public freeSaleActiveTime = type(uint256).max;

    uint256 public maxNftsPerWallet = 10;
    uint256 public nftPrice = 0.0069 ether;
    uint256 public saleActiveTime = type(uint256).max;

    uint256 public constant maxSupply = 8888;

    uint256 public reservedNfts = 888;

    string nftMetadataURI;

    function buyNfts(uint256 _nftsQty) external payable saleActive(saleActiveTime) callerIsUser mintLimit(_nftsQty, maxNftsPerWallet) priceAvailable(_nftsQty) nftsAvailable(_nftsQty) {
        require(_totalMinted() >= freeNfts, "Why pay for Nfts when you can get them for free.");

        _mint(msg.sender, _nftsQty);
    }

    function buyNftsFree(uint256 _nftsQty) external saleActive(freeSaleActiveTime) callerIsUser mintLimit(_nftsQty, freeMaxNftsPerWallet) nftsAvailable(_nftsQty) {
        require(_totalMinted() < freeNfts, "Max free limit reached");

        _mint(msg.sender, _nftsQty);
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function setNftPrice(uint256 _newPrice) external onlyOwner {
        nftPrice = _newPrice;
    }

    function setFreeNfts(uint256 _freeNfts) external onlyOwner {
        freeNfts = _freeNfts;
    }

    function setReservedNfts(uint256 _reservedNfts) external onlyOwner {
        reservedNfts = _reservedNfts;
    }

    function setMaxNftsPerWallet(uint256 _maxNftsPerWallet, uint256 _freeMaxNftsPerWallet) external onlyOwner {
        maxNftsPerWallet = _maxNftsPerWallet;
        freeMaxNftsPerWallet = _freeMaxNftsPerWallet;
    }

    function setSaleActiveTime(uint256 _saleActiveTime, uint256 _freeSaleActiveTime) external onlyOwner {
        saleActiveTime = _saleActiveTime;
        freeSaleActiveTime = _freeSaleActiveTime;
    }

    function setNftMetadataURI(string memory _nftMetadataURI) external onlyOwner {
        nftMetadataURI = _nftMetadataURI;
    }

    function giftNfts(address[] calldata _sendNftsTo, uint256 _nftsQty) external onlyOwner nftsAvailable(_sendNftsTo.length * _nftsQty) {
        reservedNfts -= _sendNftsTo.length * _nftsQty;
        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _nftsQty);
    }

    function _baseURI() internal view override returns (string memory) {
        return nftMetadataURI;
    }

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is a sm");
        _;
    }

    modifier saleActive(uint256 _saleActiveTime) {
        require(block.timestamp > _saleActiveTime, "Please, come back when the sale goes live");
        _;
    }

    modifier mintLimit(uint256 _nftsQty, uint256 _maxNftsPerWallet) {
        require(_numberMinted(msg.sender) + _nftsQty <= _maxNftsPerWallet, "Max x wallet exceeded");
        _;
    }

    modifier nftsAvailable(uint256 _nftsQty) {
        require(_nftsQty + totalSupply() + reservedNfts <= maxSupply, "Sorry, we are sold out");
        _;
    }

    modifier priceAvailable(uint256 _nftsQty) {
        require(msg.value == _nftsQty * nftPrice, "Please, send the exact amount of ETH");
        _;
    }

    // Auto Approve Marketplaces

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

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, IERC165, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setRoyalty(address _receiver, uint96 _feeNumerator) public onlyOwner {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }

    function setName(string memory _name) external onlyOwner{
        _setName(_name);
    }

    function setSymbol(string memory _symbol) external onlyOwner{
        _setSymbol(_symbol);
    }
    /*
    put inside ERC721A

    function _setName(string memory __name) internal {
        _name = __name;
    }

    function _setSymbol(string memory __symbol) internal {
        _symbol = __symbol;
    }

    */
}

contract NftsPresale is NftsSale {
    mapping(uint256 => uint256) public maxMintPresales;
    mapping(uint256 => uint256) public nftPricePresales;
    mapping(uint256 => bytes32) public whitelistMerkleRoots;
    uint256 public presaleActiveTime = type(uint256).max;

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

    function buyNftsWhitelist(
        uint256 _nftsQty,
        bytes32[] calldata _proof,
        uint256 _rootNumber
    ) external payable callerIsUser nftsAvailable(_nftsQty) {
        require(block.timestamp > presaleActiveTime, "Please, come back when the presale goes live");
        require(_inWhitelist(msg.sender, _proof, _rootNumber), "Sorry, you are not allowed");
        require(msg.value == _nftsQty * nftPricePresales[_rootNumber], "Please, send the exact amount of ETH");
        require(_numberMinted(msg.sender) + _nftsQty <= maxMintPresales[_rootNumber], "Max x wallet exceeded");

        _mint(msg.sender, _nftsQty);
    }

    function setPresale(
        uint256 _rootNumber,
        bytes32 _whitelistMerkleRoot,
        uint256 _maxMintPresales,
        uint256 _nftPricePresale
    ) external onlyOwner {
        maxMintPresales[_rootNumber] = _maxMintPresales;
        nftPricePresales[_rootNumber] = _nftPricePresale;
        whitelistMerkleRoots[_rootNumber] = _whitelistMerkleRoot;
    }

    function setPresaleActiveTime(uint256 _presaleActiveTime) external onlyOwner {
        presaleActiveTime = _presaleActiveTime;
    }
}

contract NftsStaking is NftsPresale {
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

    function stakeNfts(uint256[] calldata _tokenIds, bool _stake) external onlyWhitelistedForStaking {
        for (uint256 i = 0; i < _tokenIds.length; i++) staked[_tokenIds[i]] = _stake;
    }
}

interface OpenSea {
    function proxies(address) external view returns (address);
}

contract Nfts is NftsStaking {}
