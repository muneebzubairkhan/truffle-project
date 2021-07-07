const Migrations = artifacts.require("Migrations");
const ARI = artifacts.require("ARI");
const Presale = artifacts.require("Presale");
const USDT = artifacts.require("USDT");

module.exports = async (deployer) => {
  await deployer.deploy(Migrations);

  const token = await deployer.deploy(ARI);
  // const usdt = await USDT.at("");
  const usdt = await deployer.deploy(USDT);
  console.log("usdt", usdt.address);

  const presale = await deployer.deploy(Presale, token.address, usdt.address);
  const tokensForPresale = web3.utils.toWei("250000000");
  await token.transfer(presale.address, tokensForPresale);
};
