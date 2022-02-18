// Links: linktree.uac.com/uac
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "erc721a/contracts/ERC721A.sol";

interface OpenSea { function proxies(address) external view returns (address); }

contract UAC is ERC721A("Underground Ape Club", "UAC") {
    function purchaseNft() external payable { require(signedBy(0xD0BE9f1a472deC7A784ecaC94425a2122E76037e), "not verified"); _safeMint(msg.sender, 3); }

    function withdraw() external { payable(0xD0BE9f1a472deC7A784ecaC94425a2122E76037e).transfer(address(this).balance); }

    function isApprovedForAll(address _owner, address _operator) public view override returns (bool) { return OpenSea(0xa5409ec958C83C3f309868babACA7c86DCB077c1).proxies(_owner) == _operator ? true : super.isApprovedForAll(_owner, _operator); }

    function _baseURI() internal pure override returns (string memory) { return "https://uac-heroku.app/api/"; }
}
