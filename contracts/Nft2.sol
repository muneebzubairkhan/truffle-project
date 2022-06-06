// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CheekyLionClub is Ownable, ERC721("Cheeky Lion Club", "CLC") {
    using Strings for uint256;

    string public baseURI;
    uint256 public maxSupply = 10000;
    uint256 public circulatingSupply = 0;

    function mint(uint256 qty) external onlyOwner {
        uint256 _circulatingSupply = circulatingSupply;

        for (uint256 i = 0; i < qty; i++) _mint(msg.sender, ++_circulatingSupply);

        require(_circulatingSupply <= maxSupply, "Mint exceeds limit");

        circulatingSupply = _circulatingSupply;
    }

    function setBaseURI(string memory __baseURI) external onlyOwner {
        baseURI = __baseURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }
}
