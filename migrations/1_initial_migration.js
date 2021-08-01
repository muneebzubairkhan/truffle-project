const Migrations = artifacts.require("Migrations");
const USDT = artifacts.require("USDT");
const RedToken = artifacts.require("RedToken");
const BlueToken = artifacts.require("BlueToken");

module.exports = async (deployer, network, accounts) => {
  await localDeploy(deployer, accounts);
  // await rinkeby(deployer, accounts);
  // await ethMainnet(deployer);
};

const localDeploy = async (deployer, [_, client, owner, dev]) => {
  await deployer.deploy(Migrations);

  const usdt = await deployer.deploy(USDT);
  const redToken = await deployer.deploy(RedToken);
  const blueToken = await deployer.deploy(BlueToken);

  console.log(`const usdt = "${usdt.address}";`);
  console.log(`const redToken = "${redToken.address}";`);
  console.log(`const blueToken = "${blueToken.address}";`);
  console.log(`// const migrations = "${Migrations.address}";`);
};

const rinkeby = async (deployer, accounts) => {
  await deployer.deploy(Migrations);

  const usdt = await USDT.at();
  const red = await RedToken.at();
  const blue = await BlueToken.at();

  console.log("usdt", usdt.address);
};

const ethMainnet = async (deployer) => {};
