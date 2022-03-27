const { fromWei, toWei } = require("web3-utils");

const Nft2 = artifacts.require("MetaDegenSociety");
const Nft1 = artifacts.require("GoldenTicket");
module.exports = async (deployer, network, [owner, account2, account3]) => {
  // only run migrations on development network for seeing gas fee on mainnet
  // telegram @thinkmuneeb

  // if (network !== "development") return;

  console.log(fromWei(await web3.eth.getBalance(owner)));
  //
  let nft1 = await deployer.deploy(Nft1, { from: owner });
  await nft1.setSaleActiveTime(0, { from: owner });
  await nft1.purchaseTokens(2, {
    value: toWei("0.00120", "ether"),
    from: owner,
  });
  console.log(fromWei(await web3.eth.getBalance(owner)));
  await nft1.withdraw({ from: owner });
  console.log(fromWei(await web3.eth.getBalance(owner)));

  //
  let nft2 = await deployer.deploy(Nft2, { from: owner });
  await nft2.setGoldenTicket(nft1.address, { from: owner });
  await nft2.setSaleActiveTime(0, { from: owner });
  await nft2.purchaseTokens(2, {
    value: toWei("0.00240", "ether"),
    from: owner,
  });
  console.log(fromWei(await web3.eth.getBalance(owner)));
  await nft2.withdraw({ from: owner });
  console.log(fromWei(await web3.eth.getBalance(owner)));

  await nft2.purchaseTokensWithGoldenTickets([1, 2], {
    from: owner,
    value: toWei("0.00120", "ether"),
  });
  console.log(fromWei(await web3.eth.getBalance(owner)));
  await nft2.withdraw({ from: owner });
  console.log(fromWei(await web3.eth.getBalance(owner)));
};
