const { fromWei } = require("web3-utils");
const { makeUiCode } = require("./helper");
const toWei = (amount, unit) => web3.utils.toWei("" + amount, unit);

const Nft2 = artifacts.require("MetaDegenSociety");
const Nft1 = artifacts.require("GoldenTicket");
const Migrations = artifacts.require("Migrations");

module.exports = async (deployer, network, [owner1, owner3, owner11, owner]) => {
  // await deployer.deploy(Migrations, { from: owner });

  let goldenTicket = await deployer.deploy(Nft1, { from: owner });
  // let goldenTicket = await Nft1.at(
  //   "0x23A78ee90045069772610efCEa429f0F6462780a"
  // );
  // let metaDegenSociety = await deployer.deploy(Nft2, { from: owner });

  // let goldenTicket = await Nft1.deployed()
  // let metaDegenSociety = await Nft2.deployed();

  // // let goldenTicket = await Nft1.at(
  // //   "0x3321D24907d2800766103541457Fc6358ec81DfD"
  // // );
  // // let metaDegenSociety = await Nft2.at(
  // //   "0x79C89b5997BE60A9757226C6b3B6CfAD7444B658"
  // // );

  // assert("100" === fromWei(await web3.eth.getBalance(owner)));
  //
  // await goldenTicket.setMetaDegenSociety(metaDegenSociety.address, {
  //   from: owner,
  // });
  // await metaDegenSociety.setGoldenTicket(goldenTicket.address, {
  //   from: owner,
  // });
  
  // await goldenTicket.setPrice(toWei(0.01, "ether"), {
  //   from: owner,
  // });
  // await metaDegenSociety.setPrice(toWei(0.02, "ether"), {
  //   from: owner,
  // });

  // await goldenTicket.setSaleActiveTime(0, { from: owner });
  // await goldenTicket.purchaseTokens(4, {
  //   value: toWei("0.00180", "ether"),
  //   from: owner,
  // });
  // // assert("99.9982" === fromWei(await web3.eth.getBalance(owner)));
  // await goldenTicket.withdraw({ from: owner });
  // // assert("100" === fromWei(await web3.eth.getBalance(owner)));

  // //

  // await metaDegenSociety.setSaleActiveTime(0, { from: owner });
  // await metaDegenSociety.purchaseTokens(2, {
  //   value: toWei("0.00180", "ether"),
  //   from: owner,
  // });
  // // assert("99.9982" === fromWei(await web3.eth.getBalance(owner)));
  // await metaDegenSociety.withdraw({ from: owner });
  // // assert("100" === fromWei(await web3.eth.getBalance(owner)));

  // // assert("2" === "" + (await metaDegenSociety.balanceOf(owner)));
  // await metaDegenSociety.purchaseTokensWithGoldenTickets([2, 3], {
  //   from: owner,
  // });
  // // assert("4" === "" + (await metaDegenSociety.balanceOf(owner)));

  // let require;
  // try {
  //   await goldenTicket.safeTransferFrom(owner, owner1, 3, { from: owner });
  //   require = false;
  // } catch (e) {
  //   require = true;
  // }

  // // assert(require);

  // const nftsOfOwner = await goldenTicket.nftsOf(owner);
  // nftsOfOwner.map((nft) => log("token id " + nft));

  //
  // makeUiCode("mumbai", { goldenTicket, metaDegenSociety });
};;

// sudo truffle migrate --reset --network mumbai