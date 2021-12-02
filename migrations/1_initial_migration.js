const Migrations = artifacts.require('Migrations');
const MarketPlace = artifacts.require('Marketplace-b')
const Biding = artifacts.require('Biding');
const networksConfig = require('../truffle-config');
const { makeHelperCodeForUIDev } = require('./helper');

module.exports = async (deployer, network, accounts) => {
  // if (network === "development") return;

  // console.log('network: ', network);
  await deployer.deploy(Migrations);
  const biding = await deployer.deploy(Biding);
  await deployer.deploy(
    MarketPlace,
    '0xc18E78C0F67A09ee43007579018b2Db091116B4C',
  );
  // makeHelperCodeForUIDev({ biding, marketplace });
};
