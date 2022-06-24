const SmartContract = artifacts.require("TheHodlerz");

module.exports = async (deployer, network, accounts) => {
  await deployer.deploy(SmartContract);
};
