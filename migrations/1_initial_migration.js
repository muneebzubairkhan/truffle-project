const Migrations = artifacts.require("Migrations");
const Rupees = artifacts.require("Rupees");

module.exports = async (deployer) => {
  await deployer.deploy(Migrations);
  await deployer.deploy(Rupees);
};
