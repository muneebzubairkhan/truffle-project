const SmartContract = artifacts.require("John");

module.exports = async (deployer, network, accounts) => {
  await deployer.deploy(SmartContract);
};
