const Migrations = artifacts.require("Migrations");
const USDT = artifacts.require("USDT");
const RedToken = artifacts.require("RedToken");
const BlueToken = artifacts.require("BlueToken");
const ERC20Generator = artifacts.require("ERC20Generator");

module.exports = async (deployer, network, accounts) => {
  await defaultDeploy(deployer, accounts);
  // await rinkeby(deployer, accounts);
  // await ethMainnet(deployer);
};

const defaultDeploy = async (deployer, [_, client, owner, dev]) => {
  await deployer.deploy(Migrations);

  const erc20Generator = await deployer.deploy(ERC20Generator);
  const usdt = await deployer.deploy(USDT);
  const redToken = await deployer.deploy(RedToken);
  const blueToken = await deployer.deploy(BlueToken);

  console.log(`const usdt = "${usdt.address}";`);
  console.log(`const redToken = "${redToken.address}";`);
  console.log(`const blueToken = "${blueToken.address}";`);
  console.log(`const erc20Generator = "${erc20Generator.address}";`); 
  console.log(`// const migrations = "${Migrations.address}";`);
};

const rinkeby = async (deployer, accounts) => {};

const ethMainnet = async (deployer) => {};
