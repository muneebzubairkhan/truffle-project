const Migrations = artifacts.require('Migrations');
const BTCSTtLTC = artifacts.require('BTCSTtLTC');

module.exports = async (deployer, network, accounts) => {
  // await localDeploy(deployer, accounts);
  await bscTestnet(deployer, accounts);
  // await rinkeby(deployer);
};

const localDeploy = async (deployer, [_, client, owner, dev]) => {
  await deployer.deploy(Migrations);
  await deployer.deploy(BTCSTtLTC);
};

const bscTestnet = async (deployer, [_, client, owner, dev]) => {
  await deployer.deploy(Migrations);
  await deployer.deploy(BTCSTtLTC);
};
