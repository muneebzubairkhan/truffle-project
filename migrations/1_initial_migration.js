const Migrations = artifacts.require('Migrations');
const IglooToken = artifacts.require('IglooToken');
const { makeHelperCodeForUIDev: makeUiCode } = require('./helper');

module.exports = async (deployer, network, accounts) => {
  // if (network === "development") return;

  // await deployer.deploy(Migrations);
  const nft = await deployer.deploy(IglooToken);
  // makeUiCode(network, { nft });
};
