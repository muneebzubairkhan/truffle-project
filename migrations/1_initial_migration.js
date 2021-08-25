const Migrations = artifacts.require('Migrations');

const ExmplToken = artifacts.require('ExmplToken');

module.exports = async (deployer, network, accounts) => {
  // if (network === "development") return;

  console.log('network: ', network);
  await deployer.deploy(Migrations);
  await deployer.deploy(ExmplToken);

  // await defaultDeploy(deployer, network, accounts);
  // await rinkeby(deployer, accounts);
  // await ethMainnet(deployer);
};
