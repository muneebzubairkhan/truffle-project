const Migrations = artifacts.require("Migrations");
const __1 = artifacts.require("Visitors");
const __2 = artifacts.require("VisitorsAddress");

module.exports = async (deployer, network, accounts) => {
  let _1 = await deployer.deploy(__1);
  let _2 = await deployer.deploy(__2);
};

