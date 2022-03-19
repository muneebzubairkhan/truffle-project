const { toWei, fromWei } = require("web3-utils");
const { makeUiCode } = require("../migrations/helper.js");
const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");
const { toChecksumAddress } = require("web3-utils");

const Nft = artifacts.require("DSOPPresale");

contract("Nft", async ([owner, client, parentCompany]) => {
  it("deploy smart contract", async () => {
    //
    let nft = await Nft.new({ from: owner });
    
    //
    makeUiCode("development", { nft });
  });
});

// Error:
// Error: truffle-plugin.json not found in the eth-gas-reporter plugin package!
