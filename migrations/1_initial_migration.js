const Migrations = artifacts.require("Migrations");
const ARI = artifacts.require("ARI");
const Presale = artifacts.require("Presale");
const USDT = artifacts.require("USDT");

module.exports = async (deployer, network, accounts) => {
  // await localDeploy(deployer, accounts);
  // await ropsten(deployer);
  await rinkeby(deployer, accounts);
  // await ethMainnet(deployer);
};

const localDeploy = async (deployer, [_, client, owner, dev]) => {
  await deployer.deploy(Migrations);

  const token = await deployer.deploy(ARI, owner);
  const usdt = await deployer.deploy(USDT);
  const presale = await deployer.deploy(
    Presale,
    token.address,
    usdt.address,
    owner,
    dev
  );

  console.log("ari token", token.address);
  console.log("presale", presale.address);
  console.log("usdt", usdt.address);
};

const rinkeby = async (deployer, accounts) => {
  await deployer.deploy(Migrations);

  const token = await deployer.deploy(ARI, accounts[0]);
  const usdt = await USDT.at("0x81223F51D0f9AAE605f0ea6DF6531Fe52Be75886");

  const presale = await deployer.deploy(
    Presale,
    token.address,
    usdt.address,
    accounts[0],
    accounts[1]
  );
  const tokensForPresale = web3.utils.toWei("250000000");
  await token.transfer(presale.address, tokensForPresale);

  console.log("ari token", token.address);
  console.log("presale", presale.address);
  console.log("usdt", usdt.address);
};

const ethMainnet = async (deployer) => {
  await deployer.deploy(Migrations);

  const token = await deployer.deploy(ARI);
  // const token = await ARI.at(" ");
  const usdt = await USDT.at("0xdac17f958d2ee523a2206206994597c13d831ec7");

  const presale = await deployer.deploy(Presale, token.address, usdt.address);
  const tokensForPresale = web3.utils.toWei("250000000");
  await token.transfer(presale.address, tokensForPresale);

  console.log("ari token", token.address);
  console.log("presale", presale.address);
  console.log("usdt", usdt.address);
};

const ropsten = async (deployer) => {
  await deployer.deploy(Migrations);

  const token = await deployer.deploy(ARI);
  // const usdt = await deployer.deploy(USDT);
  // const token = await ARI.at("0x2F2C69A56c33FEa5750627C352a7A59bBFB43302");
  const usdt = await USDT.at(" ");

  const presale = await deployer.deploy(Presale, token.address, usdt.address);
  const tokensForPresale = web3.utils.toWei("250000000");
  await token.transfer(presale.address, tokensForPresale);

  console.log("ari token", token.address);
  console.log("presale", presale.address);
  console.log("usdt", usdt.address);
};
