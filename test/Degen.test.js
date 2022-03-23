const { toWei, fromWei } = require("web3-utils");
// const { makeUiCode } = require("../migrations/helper.js");

const Nft2 = artifacts.require("MetaDegenSociety");
const Nft1 = artifacts.require("GoldenTicket");

contract("Nft", async ([owner1, owner2, owner]) => {
  it("deploy smart contract", async () => {
    console.log(fromWei(await web3.eth.getBalance(owner)));
    //
    let nft1 = await Nft1.new({ from: owner });
    await nft1.setSaleActiveTime(0, { from: owner });
    await nft1.purchaseTokens(2, {
      value: toWei("12.0", "ether"),
      from: owner,
    });
    console.log(fromWei(await web3.eth.getBalance(owner)));
    await nft1.withdraw({ from: owner });
    console.log(fromWei(await web3.eth.getBalance(owner)));

    //
    let nft2 = await Nft2.new({ from: owner });
    await nft2.setGoldenTicket(nft1.address, { from: owner });
    await nft2.setSaleActiveTime(0, { from: owner });
    await nft2.purchaseTokens(2, {
      value: toWei("24.0", "ether"),
      from: owner,
    });
    console.log(fromWei(await web3.eth.getBalance(owner)));
    await nft2.withdraw({ from: owner });
    console.log(fromWei(await web3.eth.getBalance(owner)));

    await nft2.purchaseTokensWithGoldenTickets([1, 2], {
      from: owner,
    });
    console.log(fromWei(await web3.eth.getBalance(owner)));
    await nft2.withdraw({ from: owner });
    console.log(fromWei(await web3.eth.getBalance(owner)));

    //
    // makeUiCode("development", { nft });
  });
});

// Error:
// Error: truffle-plugin.json not found in the eth-gas-reporter plugin package!
