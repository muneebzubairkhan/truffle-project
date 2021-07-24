const Migrations = artifacts.require("Migrations");
const ARI = artifacts.require("ARI");
const Presale = artifacts.require("Presale");
const USDT = artifacts.require("USDT");

module.exports = async (deployer, network, accounts) => {
  await bscMainnet(deployer, accounts);
  // await bscTestnet(deployer, accounts);
  // await localDeploy(deployer, accounts);
  // await ropsten(deployer);
  // await rinkeby(deployer, accounts);
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

const bscMainnet = async (deployer, accounts) => {
  await deployer.deploy(Migrations);

  const walletOwner = "0x8f56641a9EaBF983ab78fF90A83f1AE79F92B4ea";
  const walletDev = "0x9Fc0fB02B1c2429065b5e75E008F4bC220730A13";

  const token = await deployer.deploy(ARI, walletOwner);
  const usdt = await USDT.at("0x55d398326f99059ff775485246999027b3197955");

  const presale = await deployer.deploy(
    Presale,
    token.address,
    usdt.address,
    walletOwner,
    walletDev
  );
  const tokensForPresale = web3.utils.toWei("250000000");
  const tokensForOthers = web3.utils.toWei("750000000");
  await token.transfer(presale.address, tokensForPresale);
  await token.transfer(walletOwner, tokensForOthers);

  console.log("ari token", token.address);
  console.log("presale", presale.address);
  console.log("usdt", usdt.address);
};

const bscTestnet = async (deployer, accounts) => {
  await deployer.deploy(Migrations);

  const token = await deployer.deploy(ARI, accounts[0]);
  const usdt = await deployer.deploy(USDT);
  // const usdt = await USDT.at("0x81223F51D0f9AAE605f0ea6DF6531Fe52Be75886");

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
