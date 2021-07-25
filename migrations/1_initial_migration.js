const Migrations = artifacts.require("Migrations");
const DogeBTC = artifacts.require("DogeBTC");
const IterableMapping = artifacts.require("IterableMapping");

module.exports = async (deployer, network, accounts) => {
  // await localDeploy(deployer, accounts);
  await bscTestnet(deployer, accounts);
  // await rinkeby(deployer);
};

const localDeploy = async (deployer, [_, client, owner, dev]) => {
  await deployer.deploy(Migrations);
  await deployer.deploy(IterableMapping);
  await deployer.link(IterableMapping, DogeBTC);
  await deployer.deploy(DogeBTC);
};


const bscTestnet = async (deployer, [_, client, owner, dev]) => {
  await deployer.deploy(Migrations);
  await deployer.deploy(IterableMapping);
  await deployer.link(IterableMapping, DogeBTC);
  await deployer.deploy(DogeBTC);
};
