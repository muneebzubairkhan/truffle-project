const { fromWei, toWei } = require("web3-utils");

const Nft2 = artifacts.require("MetaDegenSociety");
const Nft1 = artifacts.require("GoldenTicket");
module.exports = async (deployer, network, [owner1, owner, owner2]) => {
  // only run migrations on development network for seeing gas fee on mainnet
  // telegram @thinkmuneeb

  // if (network !== "development") return;

  // console.log(fromWei(await web3.eth.getBalance(owner)));
  // //
  // let nft1 = await deployer.deploy(Nft1, { from: owner });
  // let nft2 = await deployer.deploy(Nft2, { from: owner });

  // // //
  // let nft1 = await Nft1.deployed();
  // // let nft1 = await deployer.deploy(Nft1, { from: owner });
  // await nft1.setSaleActiveTime(0, { from: owner });
  // await nft1.purchaseTokens(2, {
  //   value: toWei("0.00090", "ether"),
  //   from: owner,
  // });

  // let nft2 = await Nft2.deployed();
  // // let nft2 = await deployer.deploy(Nft2, { from: owner });
  // await nft2.setGoldenTicket(nft1.address, { from: owner });
  // await nft2.setSaleActiveTime(0, { from: owner });
  // await nft2.purchaseTokens(2, {
  //   value: toWei("0.00180", "ether"),
  //   from: owner,
  // });

  // await nft2.purchaseTokensWithGoldenTickets([1, 2], {
  //   from: owner,
  // });

  // await nft2.withdraw({ from: owner });
};;

// sudo truffle migrate --reset --network mumbai