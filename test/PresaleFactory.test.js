const { makeUiCode } = require("../migrations/helper.js");

const Nft = artifacts.require("LazyPandas_Advanced");

contract("Presale Generator", async ([owner, client, parentCompany]) => {
  it("deploy smart contract", async () => {
    //
    let nft = await Nft.new({ from: owner });
    console.log(await nft.owner());
    console.log(owner);
    await nft.addToAllowList([owner], { from: owner });
    //
    makeUiCode("development", { nft });
  });
});

