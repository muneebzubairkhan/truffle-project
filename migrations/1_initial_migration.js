const Nft = artifacts.require("DysfunctionalDogsNft");
const { toWei, fromWei } = require("web3-utils");
// const _Contract_1_ = artifacts.require("_Contract_1_");

module.exports = async (deployer, network, [owner]) => {
  // only run migrations on development network for seeing gas fee on mainnet
  // telegram @thinkmuneeb

  // if (network !== "development") return;

  // await deployer.deploy(Migrations);
  // await deployer.deploy(Nft);

  console.log("aoa");
  let nft = await Nft.deployed();
  console.log(owner === (await nft.owner()));

  await nft.setSale1ActiveTime(0);
  await nft.sale1PurchaseTokens(1, { value: toWei("0.02"), from: owner });

  await nft.setSale4ActiveTime(0);
  await nft.sale4PurchaseTokens(2, { value: toWei("0.04"), from: owner });

  console.log("token 1 from sale 1", await nft.tokenURI(1));
  console.log("token 2 from sale 4", await nft.tokenURI(2));
  console.log("token 3 from sale 4", await nft.tokenURI(3));

  console.log("before", fromWei(await web3.eth.getBalance(owner)));
  await nft.withdraw({ from: owner });
  console.log("after", fromWei(await web3.eth.getBalance(owner)));

  const whitelist1 = [
    owner,
    "0xc18E78C0F67A09ee43007579018b2Db091116B4C",
    "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
    "0xBCb03471E33C68BCdD2bA1D846E4737fedb768Fa",
    "0x590AD8E5Fd87f05B064FCaE86703039d1F0e4350",
    "0x989b691745F7B0139a429d2B36364668a01A39Cf",
  ];

  await nft.setWhitelist2ActiveTime(0);
  await nft.setWhitelist2(whitelist1, { from: owner });
  await nft.purchaseTokensWhitelist2(1, {
    value: toWei("0.01"),
    from: owner,
  });

  await nft.setWhitelist3ActiveTime(0);
  await nft.setWhitelist3(whitelist1, { from: owner });
  await nft.purchaseTokensWhitelist3(1, {
    value: toWei("0.01"),
    from: owner,
  });

  console.log("token 4 from sale 2", await nft.tokenURI(4));
  console.log("token 5 from sale 3", await nft.tokenURI(5));

  console.log("before", fromWei(await web3.eth.getBalance(owner)));
  await nft.withdraw({ from: owner });
  console.log("after", fromWei(await web3.eth.getBalance(owner)));

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
