const Migrations = artifacts.require('Migrations');
const MarketPlace = artifacts.require('NFTMarket');
const Biding = artifacts.require('Biding');
const networksConfig = require('../truffle-config');
const { makeHelperCodeForUIDev } = require('./helper');

module.exports = async (deployer, network, accounts) => {
  // if (network === "development") return;

  // console.log('network: ', network);
  await deployer.deploy(Migrations);
  const biding = await deployer.deploy(Biding);
  const marketplace = await deployer.deploy(MarketPlace);
  makeHelperCodeForUIDev(network,{ biding, marketplace });
};
