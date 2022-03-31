const { fromWei, toWei } = require("web3-utils");

const Nft2 = artifacts.require("MetaDegenSociety");
const Nft1 = artifacts.require("GoldenTicket");
module.exports = async (deployer, network, [owner1, owner, owner2]) => {
  // let nft1 = await deployer.deploy(Nft1, { from: owner });
  // let nft2 = await deployer.deploy(Nft2, { from: owner });

  // let nft1 = await Nft1.deployed();
};;

// sudo truffle migrate --reset --network mumbai