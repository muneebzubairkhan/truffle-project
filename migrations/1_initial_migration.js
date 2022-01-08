const Migrations = artifacts.require('Migrations');
const SnowiesClub = artifacts.require('SnowiesClub');
const { makeHelperCodeForUIDev: makeUiCode } = require('./helper');

module.exports = async (deployer, network, accounts) => {
  // if (network === "development") return;

  // await deployer.deploy(Migrations);
  const nft = await deployer.deploy(SnowiesClub, { from: accounts[1] });
  makeUiCode(network, { nft });
};
