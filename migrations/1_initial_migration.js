const Migrations = artifacts.require("Migrations");
const ARI = artifacts.require("ARI");
const Presale = artifacts.require("Presale");
const USDT = artifacts.require("USDT");

module.exports = async (deployer) => {
  await deployer.deploy(Migrations);

  const token = await deployer.deploy(ARI);
  // const usdt = await deployer.deploy(USDT);
  // const token = await ARI.at("0x2F2C69A56c33FEa5750627C352a7A59bBFB43302");
  const usdt = await USDT.at("0x81223F51D0f9AAE605f0ea6DF6531Fe52Be75886");

  const presale = await deployer.deploy(Presale, token.address, usdt.address);
  const tokensForPresale = web3.utils.toWei("250000000");
  await token.transfer(presale.address, tokensForPresale);

  console.log("token", token.address);
  console.log("usdt", usdt.address);
  console.log("presale", presale.address);
};
