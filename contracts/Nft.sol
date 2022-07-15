// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// import "erc721a/contracts/ERC721A.sol";
// import "erc721a/contracts/extensions/ERC721AQueryable.sol";

import "erc721a@3.3.0/contracts/ERC721A.sol";
import "erc721a@3.3.0/contracts/extensions/ERC721AQueryable.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

contract NftPublicSale is ERC721A("fof", "gog"), ERC721AQueryable, Ownable, ERC2981 {
    using Strings for uint256;

    uint256 public maxSupply = 4000;
    uint256 public nftsForOwner = 100;

    string public metadataIpfsLink1 = "https://gateway.moralisipfs.com/ipfs/Qmec26jwKZPB5Wn9sgL7kJ2z1AbfSR8ckacjveyn4BceGj/50.json";
    string public metadataIpfsLink2 = "https://angryfalcon.pixelartcollection.com/2.json";
    string public metadataIpfsLink3 = "https://gateway.moralisipfs.com/ipfs/QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/30";
    string public metadataIpfsLink4 = "https://gateway.moralisipfs.com/ipfs/QmeSjSinHpPnmXmspMjwiXyN6zS4E9zccariGR3jxcaWtq/40";

    // id minted => meta data id
    mapping(uint256 => uint256) public metadataId;

    constructor() {
        _setDefaultRoyalty(msg.sender, 10_00); // 10.00 %
    }

    ///////////////////////////////////
    //       OVERRIDE CODE STARTS    //
    ///////////////////////////////////

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981, IERC165) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    function tokenURI(uint256 tokenId) public view virtual override(ERC721A, IERC721Metadata) returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        if (metadataId[tokenId] == 1) return metadataIpfsLink1;
        else if (metadataId[tokenId] == 2) return metadataIpfsLink2;
        else if (metadataId[tokenId] == 3) return metadataIpfsLink3;
        else if (metadataId[tokenId] == 4) return metadataIpfsLink4;

        return "not found";
    }

    //////////////////
    //  ONLY OWNER  //
    //////////////////

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;

        payable(msg.sender).transfer(balance);
    }

    function withdrawERC20(IERC20 _erc20) external onlyOwner {
        uint256 balance = _erc20.balanceOf(address(this));

        _erc20.transfer(msg.sender, balance);
    }

    function giftNft(address[] calldata _sendNftsTo, uint256 _howMany, uint option1to4) external onlyOwner {
        require(option1to4 >=1 && option1to4 <= 4, "option should be 1 to 4");
        uint256 _mintAmount = _sendNftsTo.length * _howMany;
        nftsForOwner -= _mintAmount;

        for (uint256 i = 0; i < _mintAmount; i++) metadataId[_currentIndex + i] = option1to4;

        for (uint256 i = 0; i < _sendNftsTo.length; i++) _safeMint(_sendNftsTo[i], _howMany);
    }

    function setDefaultRoyalty(address _receiver, uint96 _feeNumerator) public onlyOwner {
        _setDefaultRoyalty(_receiver, _feeNumerator);
    }

    function setMetadataFolderIpfsLink(
        string memory _metadata1,
        string memory _metadata2,
        string memory _metadata3,
        string memory _metadata4
    ) public onlyOwner {
        metadataIpfsLink1 = _metadata1;
        metadataIpfsLink2 = _metadata2;
        metadataIpfsLink3 = _metadata3;
        metadataIpfsLink4 = _metadata4;
    }

    function getToken() external payable {}

    receive() external payable {}
}

contract NftPublicSale1 is NftPublicSale {
    uint256 public sale1MaxMintAmount = 20;
    uint256 public sale1CostPerNft = 0.02 * 1e18;
    uint256 public sale1NftPerAddressLimit = 3;
    uint256 public sale1PublicMintActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/

    uint256 public publicSale1Supply = 1000;
    uint256 public publicSale1Minted;

    function sale1PurchaseTokens(uint256 _mintAmount) public payable {
        require(block.timestamp > sale1PublicMintActiveTime, "the contract is paused");
        uint256 supply = totalSupply();

        require(_mintAmount <= sale1MaxMintAmount, "Max mint amount per session exceeded");
        require(supply + _mintAmount + nftsForOwner <= maxSupply, "Max NFT limit exceeded");
        require(msg.value == sale1CostPerNft * _mintAmount, "You are sending either low funds or more funds than needed");

        for (uint256 i = 0; i < _mintAmount; i++) metadataId[_currentIndex + i] = 1;

        publicSale1Minted += _mintAmount;
        require(publicSale1Minted <= publicSale1Supply, "Public sale limit reached");

        _safeMint(msg.sender, _mintAmount);
    }

    function setSale1NftPerAddressLimit(uint256 _limit) public onlyOwner {
        sale1NftPerAddressLimit = _limit;
    }

    function setSale1CostPerNft(uint256 _newSale1CostPerNft) public onlyOwner {
        sale1CostPerNft = _newSale1CostPerNft;
    }

    function setSale1MaxMintAmount(uint256 _newSale1MaxMintAmount) public onlyOwner {
        sale1MaxMintAmount = _newSale1MaxMintAmount;
    }

    function setSale1ActiveTime(uint256 _sale1PublicMintActiveTime) public onlyOwner {
        sale1PublicMintActiveTime = _sale1PublicMintActiveTime;
    }
}

contract NftPublicSale2 is NftPublicSale1 {
    uint256 public sale2MaxMintAmount = 20;
    uint256 public sale2CostPerNft = 0.02 * 1e18;
    uint256 public sale2NftPerAddressLimit = 3;
    uint256 public sale2PublicMintActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/

    uint256 public publicSale2Supply = 1000;
    uint256 public publicSale2Minted;

    function sale2PurchaseTokens(uint256 _mintAmount) public payable {
        require(block.timestamp > sale2PublicMintActiveTime, "the contract is paused");
        uint256 supply = totalSupply();

        require(_mintAmount <= sale2MaxMintAmount, "Max mint amount per session exceeded");
        require(supply + _mintAmount + nftsForOwner <= maxSupply, "Max NFT limit exceeded");
        require(msg.value == sale2CostPerNft * _mintAmount, "You are sending either low funds or more funds than needed");

        for (uint256 i = 0; i < _mintAmount; i++) metadataId[_currentIndex + i] = 2;

        publicSale2Minted += _mintAmount;
        require(publicSale2Minted <= publicSale2Supply, "Public sale limit reached");

        _safeMint(msg.sender, _mintAmount);
    }

    function setSale2NftPerAddressLimit(uint256 _limit) public onlyOwner {
        sale2NftPerAddressLimit = _limit;
    }

    function setSale2CostPerNft(uint256 _newSale2CostPerNft) public onlyOwner {
        sale2CostPerNft = _newSale2CostPerNft;
    }

    function setSale2MaxMintAmount(uint256 _newSale2MaxMintAmount) public onlyOwner {
        sale2MaxMintAmount = _newSale2MaxMintAmount;
    }

    function setSale2ActiveTime(uint256 _sale2PublicMintActiveTime) public onlyOwner {
        sale2PublicMintActiveTime = _sale2PublicMintActiveTime;
    }
}

contract NftPublicSale3 is NftPublicSale2 {
    uint256 public sale3MaxMintAmount = 20;
    uint256 public sale3CostPerNft = 0.02 * 1e18;
    uint256 public sale3NftPerAddressLimit = 3;
    uint256 public sale3PublicMintActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/

    uint256 public publicSale3Supply = 1000;
    uint256 public publicSale3Minted;

    function sale3PurchaseTokens(uint256 _mintAmount) public payable {
        require(block.timestamp > sale3PublicMintActiveTime, "the contract is paused");
        uint256 supply = totalSupply();

        require(_mintAmount <= sale3MaxMintAmount, "Max mint amount per session exceeded");
        require(supply + _mintAmount + nftsForOwner <= maxSupply, "Max NFT limit exceeded");
        require(msg.value == sale3CostPerNft * _mintAmount, "You are sending either low funds or more funds than needed");

        for (uint256 i = 0; i < _mintAmount; i++) metadataId[_currentIndex + i] = 3;

        publicSale3Minted += _mintAmount;
        require(publicSale3Minted <= publicSale3Supply, "Public sale limit reached");

        _safeMint(msg.sender, _mintAmount);
    }

    function setSale3NftPerAddressLimit(uint256 _limit) public onlyOwner {
        sale3NftPerAddressLimit = _limit;
    }

    function setSale3CostPerNft(uint256 _newSale3CostPerNft) public onlyOwner {
        sale3CostPerNft = _newSale3CostPerNft;
    }

    function setSale3MaxMintAmount(uint256 _newSale3MaxMintAmount) public onlyOwner {
        sale3MaxMintAmount = _newSale3MaxMintAmount;
    }

    function setSale3ActiveTime(uint256 _sale3PublicMintActiveTime) public onlyOwner {
        sale3PublicMintActiveTime = _sale3PublicMintActiveTime;
    }
}

contract NftPublicSale4 is NftPublicSale3 {
    uint256 public sale4MaxMintAmount = 20;
    uint256 public sale4CostPerNft = 0.02 * 1e18;
    uint256 public sale4NftPerAddressLimit = 3;
    uint256 public sale4PublicMintActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/

    uint256 public publicSale4Supply = 1000;
    uint256 public publicSale4Minted;

    function sale4PurchaseTokens(uint256 _mintAmount) public payable {
        require(block.timestamp > sale4PublicMintActiveTime, "the contract is paused");
        uint256 supply = totalSupply();

        require(_mintAmount <= sale4MaxMintAmount, "Max mint amount per session exceeded");
        require(supply + _mintAmount + nftsForOwner <= maxSupply, "Max NFT limit exceeded");
        require(msg.value == sale4CostPerNft * _mintAmount, "You are sending either low funds or more funds than needed");

        for (uint256 i = 0; i < _mintAmount; i++) metadataId[_currentIndex + i] = 4;

        publicSale4Minted += _mintAmount;
        require(publicSale4Minted <= publicSale4Supply, "Public sale limit reached");

        _safeMint(msg.sender, _mintAmount);
    }

    function setSale4NftPerAddressLimit(uint256 _limit) public onlyOwner {
        sale4NftPerAddressLimit = _limit;
    }

    function setSale4CostPerNft(uint256 _newSale4CostPerNft) public onlyOwner {
        sale4CostPerNft = _newSale4CostPerNft;
    }

    function setSale4MaxMintAmount(uint256 _newSale4MaxMintAmount) public onlyOwner {
        sale4MaxMintAmount = _newSale4MaxMintAmount;
    }

    function setSale4ActiveTime(uint256 _sale4PublicMintActiveTime) public onlyOwner {
        sale4PublicMintActiveTime = _sale4PublicMintActiveTime;
    }
}

contract NftWhitelist1Sale is NftPublicSale4 {
    uint256 public whitelist1Supply = 400;
    uint256 public whitelist1Minted;

    uint256 public whitelist1ActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/;
    uint256 public whitelist1MaxMint = 3;
    uint256 public itemPriceWhitelist1 = 0.01 * 1e18;

    mapping(address => uint256) public whitelist1ClaimedBy;
    mapping(address => bool) public onWhitelist1;

    function setWhitelist1(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist1[addresses[i]] = true;
    }

    function removeFromWhitelist1(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist1[addresses[i]] = false;
    }

    function purchaseTokensWhitelist1(uint256 _howMany) external payable {
        require(whitelist1Minted + _howMany <= whitelist1Supply, "whitelist limit reached");
        require(_totalMinted() + _howMany + nftsForOwner <= maxSupply, "Max NFT limit exceeded");

        require(onWhitelist1[msg.sender], "You are not in whitelist");
        require(block.timestamp > whitelist1ActiveTime, "Whitelist is not active");
        require(msg.value == _howMany * itemPriceWhitelist1, "You are sending either low funds or more funds than needed");

        whitelist1Minted += _howMany;
        whitelist1ClaimedBy[msg.sender] += _howMany;

        require(whitelist1ClaimedBy[msg.sender] <= whitelist1MaxMint, "Purchase exceeds max allowed");

        for (uint256 i = 0; i < _howMany; i++) metadataId[_currentIndex + i] = 1;

        _safeMint(msg.sender, _howMany);
    }

    function setWhitelist1MaxMint(uint256 _whitelist1MaxMint) external onlyOwner {
        whitelist1MaxMint = _whitelist1MaxMint;
    }

    function setPriceWhitelist1(uint256 _itemPriceWhitelist1) external onlyOwner {
        itemPriceWhitelist1 = _itemPriceWhitelist1;
    }

    function setWhitelist1ActiveTime(uint256 _whitelist1ActiveTime) external onlyOwner {
        whitelist1ActiveTime = _whitelist1ActiveTime;
    }
}

contract NftWhitelist2Sale is NftWhitelist1Sale {
    uint256 public whitelist2Supply = 400;
    uint256 public whitelist2Minted;

    uint256 public whitelist2ActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/;
    uint256 public whitelist2MaxMint = 3;
    uint256 public itemPriceWhitelist2 = 0.01 * 1e18;

    mapping(address => uint256) public whitelist2ClaimedBy;
    mapping(address => bool) public onWhitelist2;

    function setWhitelist2(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist2[addresses[i]] = true;
    }

    function removeFromWhitelist2(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist2[addresses[i]] = false;
    }

    function purchaseTokensWhitelist2(uint256 _howMany) external payable {
        require(whitelist2Minted + _howMany <= whitelist2Supply, "Whitelist limit reached");
        require(_totalMinted() + _howMany + nftsForOwner <= maxSupply, "Max NFT limit exceeded");

        require(onWhitelist2[msg.sender], "You are not in whitelist");
        require(block.timestamp > whitelist2ActiveTime, "Whitelist is not active");
        require(msg.value == _howMany * itemPriceWhitelist2, "You are sending either low funds or more funds than needed");

        whitelist2Minted += _howMany;
        whitelist2ClaimedBy[msg.sender] += _howMany;

        require(whitelist2ClaimedBy[msg.sender] <= whitelist2MaxMint, "Purchase exceeds max allowed");

        for (uint256 i = 0; i < _howMany; i++) metadataId[_currentIndex + i] = 2;

        _safeMint(msg.sender, _howMany);
    }

    function setWhitelist2MaxMint(uint256 _whitelist2MaxMint) external onlyOwner {
        whitelist2MaxMint = _whitelist2MaxMint;
    }

    function setPriceWhitelist2(uint256 _itemPriceWhitelist2) external onlyOwner {
        itemPriceWhitelist2 = _itemPriceWhitelist2;
    }

    function setWhitelist2ActiveTime(uint256 _whitelist2ActiveTime) external onlyOwner {
        whitelist2ActiveTime = _whitelist2ActiveTime;
    }
}

contract NftWhitelist3Sale is NftWhitelist2Sale {
    uint256 public whitelist3Supply = 400;
    uint256 public whitelist3Minted;

    uint256 public whitelist3ActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/;
    uint256 public whitelist3MaxMint = 3;
    uint256 public itemPriceWhitelist3 = 0.01 * 1e18;

    mapping(address => uint256) public whitelist3ClaimedBy;
    mapping(address => bool) public onWhitelist3;

    function setWhitelist3(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist3[addresses[i]] = true;
    }

    function removeFromWhitelist3(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist3[addresses[i]] = false;
    }

    function purchaseTokensWhitelist3(uint256 _howMany) external payable {
        require(whitelist3Minted + _howMany <= whitelist3Supply, "Whitelist limit reached");
        require(_totalMinted() + _howMany + nftsForOwner <= maxSupply, "Max NFT limit exceeded");

        require(onWhitelist3[msg.sender], "You are not in whitelist");
        require(block.timestamp > whitelist3ActiveTime, "Whitelist is not active");
        require(msg.value == _howMany * itemPriceWhitelist3, "You are sending either low funds or more funds than needed");

        whitelist3Minted += _howMany;
        whitelist3ClaimedBy[msg.sender] += _howMany;

        require(whitelist3ClaimedBy[msg.sender] <= whitelist3MaxMint, "Purchase exceeds max allowed");

        for (uint256 i = 0; i < _howMany; i++) metadataId[_currentIndex + i] = 3;

        _safeMint(msg.sender, _howMany);
    }

    function setWhitelist3MaxMint(uint256 _whitelist3MaxMint) external onlyOwner {
        whitelist3MaxMint = _whitelist3MaxMint;
    }

    function setPriceWhitelist3(uint256 _itemPriceWhitelist3) external onlyOwner {
        itemPriceWhitelist3 = _itemPriceWhitelist3;
    }

    function setWhitelist3ActiveTime(uint256 _whitelist3ActiveTime) external onlyOwner {
        whitelist3ActiveTime = _whitelist3ActiveTime;
    }
}

contract NftWhitelist4Sale is NftWhitelist3Sale {
    uint256 public whitelist4Supply = 400;
    uint256 public whitelist4Minted;

    uint256 public whitelist4ActiveTime = block.timestamp + 365 days; // https://www.epochconverter.com/;
    uint256 public whitelist4MaxMint = 3;
    uint256 public itemPriceWhitelist4 = 0.01 * 1e18;

    mapping(address => uint256) public whitelist4ClaimedBy;
    mapping(address => bool) public onWhitelist4;

    function setWhitelist4(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist4[addresses[i]] = true;
    }

    function removeFromWhitelist4(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) onWhitelist4[addresses[i]] = false;
    }

    function purchaseTokensWhitelist4(uint256 _howMany) external payable {
        require(whitelist4Minted + _howMany <= whitelist4Supply, "Whitelist limit reached");
        require(_totalMinted() + _howMany + nftsForOwner <= maxSupply, "Max NFT limit exceeded");

        require(onWhitelist4[msg.sender], "You are not in whitelist");
        require(block.timestamp > whitelist4ActiveTime, "Whitelist is not active");
        require(msg.value == _howMany * itemPriceWhitelist4, "You are sending either low funds or more funds than needed");

        whitelist4Minted += _howMany;
        whitelist4ClaimedBy[msg.sender] += _howMany;

        require(whitelist4ClaimedBy[msg.sender] <= whitelist4MaxMint, "Purchase exceeds max allowed");

        for (uint256 i = 0; i < _howMany; i++) metadataId[_currentIndex + i] = 4;

        _safeMint(msg.sender, _howMany);
    }

    function setWhitelist4MaxMint(uint256 _whitelist4MaxMint) external onlyOwner {
        whitelist4MaxMint = _whitelist4MaxMint;
    }

    function setPriceWhitelist4(uint256 _itemPriceWhitelist4) external onlyOwner {
        itemPriceWhitelist4 = _itemPriceWhitelist4;
    }

    function setWhitelist4ActiveTime(uint256 _whitelist4ActiveTime) external onlyOwner {
        whitelist4ActiveTime = _whitelist4ActiveTime;
    }
}

contract NftAutoApproveMarketPlaces is NftWhitelist4Sale {
    mapping(address => bool) public projectProxy;

    function flipProxyState(address proxyAddress) public onlyOwner {
        projectProxy[proxyAddress] = !projectProxy[proxyAddress];
    }

    function isApprovedForAll(address _owner, address _operator) public view override(ERC721A, IERC721) returns (bool) {
        return projectProxy[_operator] ? true : super.isApprovedForAll(_owner, _operator);
    }
}

contract DysfunctionalDogsNft is NftAutoApproveMarketPlaces {}
