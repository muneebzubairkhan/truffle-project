const contract = artifacts.require("AirDrop");

module.exports = async (deployer, network, accounts) => {
  await deployer.deploy(contract);
};
