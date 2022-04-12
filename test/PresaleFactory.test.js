const { toWei, fromWei } = require("web3-utils");

const Nft = artifacts.require("Boredsone");

contract("Nft", async ([owner, client, parentCompany]) => {
  it("deploy smart contract", async () => {
    let nft = await Nft.new({ from: owner });
    console.log(owner === (await nft.owner()));
    await nft.setSaleActiveTime(0);
    await nft.purchaseTokens(1, { value: toWei("0.1"), from: client });
    console.log(fromWei(await web3.eth.getBalance(owner)));
    await nft.withdraw({ from: owner });
    console.log(fromWei(await web3.eth.getBalance(owner)));
  });
});
