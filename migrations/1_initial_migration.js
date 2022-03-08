const Migrations = artifacts.require("Migrations");
const Nft = artifacts.require("FoxNationDAOERC20");
// const _Contract_1_ = artifacts.require("_Contract_1_");

module.exports = async (deployer, network, accounts) => {
  // only run migrations on development network for seeing gas fee on mainnet
  // telegram @thinkmuneeb

  // if (network !== "development") return;

  // await deployer.deploy(Migrations);
  await deployer.deploy(Nft);

  // try {
  //   // await deployer.deploy(_Contract_1_);

  //   // const _2 = artifacts.require("_2");
  //   // const __2 = await deployer.deploy(_2);

  //   // const _3 = artifacts.require("_3");
  //   // const __3 = await deployer.deploy(_3);
  // } catch (e) {
  //   e && console.log(e.message);
  // }
};

// console.log(JSON.stringify({ contracts }, null, 4));
