const { toWei } = require("web3-utils");
const { makeUiCode } = require("../migrations/helper.js");

const Nft = artifacts.require("BeetchyPandasERC20Sale");

contract("Nft", async ([owner, client, parentCompany]) => {
  it("deploy smart contract", async () => {
    //
    let nft = await Nft.new({ from: owner });
    console.log(owner === await nft.owner());
    await nft.setSaleActiveTime(0);
    await nft.purchaseTokens(1, {value: toWei("0.03"), from: client});
    //
    makeUiCode("development", { nft });
  });
});

// Error: 
// Error: truffle-plugin.json not found in the eth-gas-reporter plugin package!













