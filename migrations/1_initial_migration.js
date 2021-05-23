const Migrations = artifacts.require("Migrations");
const USDT = artifacts.require("USDT");

module.exports = async (deployer) => {
  await deployer.deploy(Migrations);
  await deployer.deploy(USDT);
};
