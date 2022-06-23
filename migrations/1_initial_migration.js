const SmartContract = artifacts.require("DoTheUniverse");

module.exports = async (deployer, network, accounts) => {
  await deployer.deploy(SmartContract);
};
