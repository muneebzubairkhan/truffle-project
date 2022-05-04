// Alpha Aliens
// https://alphaaliens.io

//     // | |     //          /                     // | |     //
//    //__| |    //  ___     / __      ___         //__| |    // ( )  ___       __      ___
//   / ___  |   // //   ) ) //   ) ) //   ) )     / ___  |   // / / //___) ) //   ) ) ((   ) )
//  //    | |  // //___/ / //   / / //   / /     //    | |  // / / //       //   / /   \ \
// //     | | // //       //   / / ((___( (     //     | | // / / ((____   //   / / //__) )

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";
import "erc721a/contracts/extensions/ERC721AQueryable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

interface OpenSea {
    function proxies(address) external view returns (address);
}

contract AlphaAliensSale is ERC721A("Alpha Aliens", "AA"), Ownable, ERC721AQueryable, ERC2981 {
    uint256 constant mintMin = 1;
    uint256 constant mintMax = 20;
    uint256 constant maxSupply = 9999;
    uint256 itemPrice = 0.025 ether;
    uint256 saleActiveTime = type(uint256).max;
    string baseURI;

    ////////////////////////////
    //    PUBLIC METHODS      //
    ////////////////////////////
    // todo make video
    // todo try reentrancy howmany + totalSupply() video
    // todo emit events, events < public var
    // todo improve staking code, non escrow, if (true false) external call()
    /// @notice Purchase multiple NFTs at once
    function purchaseTokens(uint256 _howMany) external payable {
        require(block.timestamp > saleActiveTime, "Sale is not active");
        require(!Address.isContract(msg.sender), "The caller is a contract");
        require(msg.value == _howMany * itemPrice, "Send correct amount of ETH");
        require(_howMany + totalSupply() <= maxSupply, "Try minting less tokens");
        require(_howMany >= mintMin && _howMany <= mintMax, "Mint within limits");

        _safeMint(msg.sender, _howMany);
    }

    /// @notice Purchase multiple NFTs at once
    function purchaseTokens2() external payable {
        uint256 _howMany = msg.value / itemPrice;
        require(block.timestamp > saleActiveTime, "Sale is not active");
        require(msg.value % itemPrice == 0, "Send correct amount of ETH");
        require(!Address.isContract(msg.sender), "The caller is a contract");
        require(_howMany + totalSupply() <= maxSupply, "Try minting less tokens");
        require(_howMany >= mintMin && _howMany <= mintMax, "Mint within limits");

        _safeMint(msg.sender, _howMany);
    }

    //////////////////////////
    //  ONLY OWNER METHODS  //
    //////////////////////////

    /// @notice Owner can withdraw from here
    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    /// @notice Send NFTs to a list of addresses
    function giftNft(address[] calldata _sendNftsTo, uint256 _howMany) external onlyOwner {
        require(_howMany * _sendNftsTo.length + totalSupply() <= maxSupply, "Try minting less tokens");
        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _howMany);
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

    function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) external onlyOwner {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }

    ///////////////////
    //  HELPER CODE  //
    ///////////////////

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}

contract AlphaAliensPresale is AlphaAliensSale {
    // multiple presale configs
    mapping(uint256 => uint256) maxMintPresales;
    mapping(uint256 => uint256) itemPricePresales;
    mapping(uint256 => bytes32) whitelistMerkleRoots;
    uint256 presaleActiveTime = type(uint256).max;

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

    function purchaseTokensWhitelist(
        uint256 _howMany,
        bytes32[] calldata _proof,
        uint256 _rootNumber
    ) external payable  {
        require(block.timestamp > presaleActiveTime, "Presale is not active");
        require(!Address.isContract(msg.sender), "The caller is a contract");
        require(msg.value == _howMany * itemPricePresales[_rootNumber], "Send correct amount of ETH");
        require(_howMany + totalSupply() <= maxSupply, "Try minting less tokens");
        
        require(_inWhitelist(msg.sender, _proof, _rootNumber), "You are not in presale");
        require(_numberMinted(msg.sender) + _howMany <= maxMintPresales[_rootNumber], "Purchase exceeds max allowed");

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

contract AlphaAliensStaking is AlphaAliensPresale {
    // tokenId => staked (yes or no)
    mapping(uint256 => bool) staked;
    mapping(address => bool) private canStake;

    function addStakingContract(address _operator) external onlyOwner {
        require(Address.isContract(_operator));
        canStake[_operator] = !canStake[_operator];
    }

    function _beforeTokenTransfers(
        address,
        address,
        uint256 startTokenId,
        uint256
    ) internal view override {
        require(!staked[startTokenId], "Unstake tokenId it to transfer");
    }

    // stake / unstake nfts
    function stakeNfts(uint256[] calldata _tokenIds, bool _stake) external {
        require(canStake[msg.sender], "Caller is not whitelisted for staking");
        for (uint256 i = 0; i < _tokenIds.length; i++) staked[_tokenIds[i]] = _stake;
    }
}

contract AlphaAliensAutoApproval is AlphaAliensStaking {
    mapping(address => bool) private allowed;

    function autoApproveMarketplace(address _spender) external onlyOwner {
        allowed[_spender] = !allowed[_spender];
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
        else if (allowed[_operator]) return true;
        return super.isApprovedForAll(_owner, _operator);
    }
}

contract AlphaAliens is AlphaAliensAutoApproval {}
