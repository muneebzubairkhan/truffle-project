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
      value: toWei("0.00090", "ether"),
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
      value: toWei("0.00180", "ether"),
      from: owner,
    });
    console.log(fromWei(await web3.eth.getBalance(owner)));
    await nft2.withdraw({ from: owner });
    console.log(fromWei(await web3.eth.getBalance(owner)));

    console.log("" + (await nft2.balanceOf(owner)));
    await nft2.purchaseTokensWithGoldenTickets([1, 2], {
      from: owner,
    });
    console.log("" + (await nft2.balanceOf(owner)));

    //
    // makeUiCode("development", { nft });
  });
});

// Error:
// Error: truffle-plugin.json not found in the eth-gas-reporter plugin package!
