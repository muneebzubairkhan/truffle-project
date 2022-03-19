const __1 = artifacts.require("Visitors");
const __2 = artifacts.require("VisitorsAddress");

module.exports = async (deployer, network, accounts) => {
  let _1 = await deployer.deploy(__1, { from: accounts[2] });
  let _2 = await deployer.deploy(__2, { from: accounts[2] });
};
