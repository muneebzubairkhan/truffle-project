const Migrations = artifacts.require('Migrations');
const NftStaking = artifacts.require("NftStaking");
const { makeHelperCodeForUIDev: makeUiCode } = require('./helper');

module.exports = async (deployer, network, accounts) => {
  // if (network === "development") return;

  await deployer.deploy(Migrations);
  const nft = await deployer.deploy(NftStaking, { from: accounts[1] });
  makeUiCode(network, { nft });
};
