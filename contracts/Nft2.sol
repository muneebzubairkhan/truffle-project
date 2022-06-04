
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CheekyLionClub is ERC721("Cheeky Lion Club", "CLC") {
    using Strings for uint256;
    
    string public baseURI;
    address owner = msg.sender;
    uint256 public circulatingSupply;

    constructor(){
        mint(250);
    }

    function mint(uint qty) public {
        for (uint256 i = 0; i < qty; i++)
            _mint(owner, ++circulatingSupply);
    }
    
    function setBaseURI(string memory __baseURI) external onlyOwner {
        baseURI = __baseURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "Caller is not the owner");
        _;
    }
}