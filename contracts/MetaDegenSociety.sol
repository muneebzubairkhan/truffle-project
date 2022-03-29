//   __  __        _            _____                                _____               _        _
//  |  \/  |      | |          |  __ \                              / ____|             (_)      | |
//  | \  / |  ___ | |_  __ _   | |  | |  ___   __ _   ___  _ __    | (___    ___    ___  _   ___ | |_  _   _
//  | |\/| | / _ \| __|/ _` |  | |  | | / _ \ / _` | / _ \| '_ \    \___ \  / _ \  / __|| | / _ \| __|| | | |
//  | |  | ||  __/| |_| (_| |  | |__| ||  __/| (_| ||  __/| | | |   ____) || (_) || (__ | ||  __/| |_ | |_| |
//  |_|  |_| \___| \__|\__,_|  |_____/  \___| \__, | \___||_| |_|  |_____/  \___/  \___||_| \___| \__| \__, |
//                                             __/ |                                                    __/ |
//                                            |___/                                                    |___/

// Website:    https://metadegensociety.io/
// OpenSea:    https://opensea.io/collection/metadegensociety/
// Discord:    https://discord.com/invite/ZXPx9WbQWk
// Instagram:  https://www.instagram.com/metadegensociety/
// Twitter:    https://twitter.com/meta_degen
// Youtube:    https://www.youtube.com/channel/UC6a0zWMSsulw6hWXkquIEtg
// TikTok:     https://www.tiktok.com/@metadegensociety
// Medium:     https://medium.com/@metadegensociety

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "erc721a/contracts/extensions/ERC721ABurnable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "erc721a/contracts/ERC721A.sol";

contract MetaDegenSociety is ERC721A("Meta Degen Society", "MDS"), ERC721ABurnable, ERC2981, Ownable, ReentrancyGuard {
    string baseURI = "ipfs://QmTePqY26AcTBNzThaJdSyobDtJRJpDx7ime9m81ji1iXV/";
    uint256 saleActiveTime = block.timestamp + 365 days;
    uint256 constant maxSupply = 9999;
    uint256 mintableSupply = 9700;
    uint256 itemPrice = 0.00090 ether;

    ERC721A goldenTicket;
    mapping(uint256 => bool) public redeemed;

    constructor() {
        _setDefaultRoyalty(msg.sender, 10_00); // 10.00%
    }

    /// @notice Purchase multiple NFTs at once
    function purchaseTokens(uint256 _howMany) external payable nonReentrant {
        // mint nfts
        _safeMint(msg.sender, _howMany);

        // full fill some requirements
        require(totalSupply() <= mintableSupply, "Try mint less");
        require(tx.origin == msg.sender, "The caller is a contract");
        require(_howMany >= 1 && _howMany <= 50, "Mint min 1, max 50");
        require(block.timestamp > saleActiveTime, "Sale is not active");

        // Pay the price
        require(msg.value == _howMany * itemPrice, "Send correct amount of ETH");
    }

    /// @notice Purchase multiple NFTs at once
    function purchaseTokensWithGoldenTickets(uint256[] memory _goldenTicketIds) external nonReentrant {
        // mint nfts
        uint256 _howMany = _goldenTicketIds.length;
        _safeMint(msg.sender, _howMany);

        // full fill some requirements
        require(totalSupply() <= mintableSupply, "Try mint less");
        require(tx.origin == msg.sender, "The caller is a contract");
        require(_howMany >= 1 && _howMany <= 50, "Mint min 1, max 50");
        require(block.timestamp > saleActiveTime, "Sale is not active");

        // Pay the price
        for (uint256 i = 0; i < _howMany; i++) {
            require(goldenTicket.ownerOf(_goldenTicketIds[i]) == msg.sender, "You are not golden ticket owner.");
            require(!redeemed[_goldenTicketIds[i]], "Golden ticket already redeemed.");
            redeemed[_goldenTicketIds[i]] = true;
        }
    }

    /// @notice Owner can withdraw from here
    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function setGoldenTicket(ERC721A _goldenTicket) external onlyOwner {
        goldenTicket = _goldenTicket;
    }

    /// @notice Change price in case of ETH price changes too much
    function setPrice(uint256 _newPrice) external onlyOwner {
        itemPrice = _newPrice;
    }

    /// @notice set sale active time
    function setSaleActiveTime(uint256 _saleActiveTime) external onlyOwner {
        saleActiveTime = _saleActiveTime;
    }

    /// @notice set mintableSupply
    function setMintableSupply(uint256 _mintableSupply) external onlyOwner {
        require(_mintableSupply <= maxSupply, "put a number less than max supply");
        mintableSupply = _mintableSupply;
    }

    /// @notice Hide identity or show identity from here, put images folder here, ipfs folder cid
    function setBaseURI(string memory __baseURI) external onlyOwner {
        baseURI = __baseURI;
    }

    /// @notice Send NFTs to a list of addresses
    function giftNft(address[] calldata _sendNftsTo, uint256 _howMany) external onlyOwner nonReentrant {
        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _howMany);
        require(totalSupply() <= maxSupply, "Try minting less");
    }

    ////////////////////
    // HELPER METHOD  //
    ////////////////////

    /// @notice get all nfts of a person
    function walletOfOwner(address _owner) external view returns (uint256[] memory) {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        return tokenIds;
    }

    function tokenOfOwnerByIndex(address _owner, uint256 index) public view returns (uint256) {
        if (index >= balanceOf(_owner)) revert();
        uint256 numMintedSoFar = _currentIndex;
        uint256 tokenIdsIdx;
        address currOwnershipAddr;
        unchecked {
            for (uint256 i; i < numMintedSoFar; i++) {
                TokenOwnership memory ownership = _ownerships[i];
                if (ownership.burned) continue;
                if (ownership.addr != address(0)) currOwnershipAddr = ownership.addr;
                if (currOwnershipAddr == _owner) {
                    if (tokenIdsIdx == index) return i;
                    tokenIdsIdx++;
                }
            }
        }
        revert();
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721A, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function burn(uint256 tokenId) public override {
        super._burn(tokenId);
        _resetTokenRoyalty(tokenId);
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

    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) {
        return projectProxy[_operator] ? true : super.isApprovedForAll(_owner, _operator);
    }

    /////////////////////////////////
    // Meta Degen Society Presale  //
    /////////////////////////////////

    uint256 presaleActiveTime = block.timestamp + 365 days;
    uint256 itemPricePresale = 0.1 ether;
    bytes32 whitelistMerkleRoot;

    function purchaseTokensPresale(uint256 _howMany, bytes32[] calldata _proof) external payable nonReentrant {
        _safeMint(msg.sender, _howMany);

        require(totalSupply() <= mintableSupply, "Try mint less");
        require(tx.origin == msg.sender, "The caller is a contract");
        require(_howMany >= 1 && _howMany <= 50, "Mint min 1, max 50");
        require(inWhitelist(msg.sender, _proof), "You are not in presale");
        require(block.timestamp > presaleActiveTime, "Presale is not active");
        require(msg.value == _howMany * itemPricePresale, "Send correct amount of ETH");
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
