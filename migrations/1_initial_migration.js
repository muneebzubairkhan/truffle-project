const Migrations = artifacts.require("Migrations");
const ARI = artifacts.require("ARI");

module.exports = async (deployer) => {
  await deployer.deploy(Migrations);
  await deployer.deploy(ARI);
};
