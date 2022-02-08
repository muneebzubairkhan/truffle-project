const { makeUiCode } = require("../migrations/helper.js");

const Nft = artifacts.require("Nft");

contract("Nft", async ([owner, client, parentCompany]) => {
  it("deploy smart contract", async () => {
    //
    let nft = await Nft.new({ from: owner });
    console.log(await nft.owner());
    console.log(owner);
    await nft.addToAllowlist([owner], { from: owner });
    //
    makeUiCode("development", { nft });
  });
});












