const { makeHelperCodeForUIDev: makeUiCode } = require("./helper");

module.exports = async (deployer, network, accounts) => {
  // if (network === "development") return;
  // await deployer.deploy(Migrations);
  // let contracts = {};
  // console.log({ contracts });
  // try {
  //   {
  //     const _1 = artifacts.require("_1");
  //     const __1 = await deployer.deploy();
  //     contracts = { ...contracts, __1 };
  //     console.log({ contracts });
  //   }
  //   const _1 = artifacts.require("_1");
  //   const __1 = await deployer.deploy(_1);
  //   contracts = { ...contracts, __1 };
  //   console.log({ contracts: __1.address });
  //   const _2 = artifacts.require("_2");
  //   const __2 = await deployer.deploy(_2);
  //   contracts = { ...contracts, __2 };
  //   // const _3 = artifacts.require("_3");
  //   // const __3 = await deployer.deploy(_3);
  //   // contracts = { ...contracts, __3 };
  //   // const nft = await deployer.deploy(NftStaking, { from: accounts[1] });
  // } catch (e) {
  //   makeUiCode(network, contracts);
  //   JSON.stringify(contracts, null, 4);
  //   // console.log(contracts);
  //   console.log("error hehe " + e.message);
  // }
};

// console.log(JSON.stringify({ contracts }, null, 4));
