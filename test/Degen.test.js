const { toWei, fromWei } = require("web3-utils");
// const { makeUiCode } = require("../migrations/helper.js");

const Nft2 = artifacts.require("MetaDegenSociety");
const Nft1 = artifacts.require("GoldenTicket");

contract("Nft", async ([owner, client, parentCompany]) => {
  it("deploy smart contract", async () => {
    //
    let nft = await Nft1.new({ from: owner });
    await nft.setSaleActiveTime(0, { from: owner });
    await nft.purchaseTokens(1, { value: toWei("60", "ether"), from: client });
    console.log(fromWei(await web3.eth.getBalance(owner)));
    await nft.withdraw({ from: owner });
    console.log(fromWei(await web3.eth.getBalance(owner)));

    //
    // makeUiCode("development", { nft });
  });
});

// Error:
// Error: truffle-plugin.json not found in the eth-gas-reporter plugin package!
