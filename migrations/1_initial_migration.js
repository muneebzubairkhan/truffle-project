const Migrations = artifacts.require("Migrations");
// const USDT = artifacts.require("USDT");
// const RedToken = artifacts.require("RedToken");
// const BlueToken = artifacts.require("BlueToken");
// const ERC20Generator = artifacts.require("ERC20Generator");
// const TokenERC20 = artifacts.require("TokenERC20");
const PresaleFactory = artifacts.require("PresaleFactory");
const Presale = artifacts.require("Presale");

module.exports = async (deployer, network, accounts) => {
  await defaultDeploy(deployer, accounts);
  // await rinkeby(deployer, accounts);
  // await ethMainnet(deployer);
};

const defaultDeploy = async (deployer, [owner, client, dev]) => {
  await deployer.deploy(Migrations);

  const presaleFactory = await deployer.deploy(PresaleFactory);

  const _tokenX = "0x95FB36223A312c7fB3Bb05415b1D85771A781Db2",
    _buyingToken = "0x1b3eD3dE93190E9E4D367d4c1801d8e1Ed1a4D6a",
    _rate = toWei("0.2"),
    _walletOwner = "0xc18E78C0F67A09ee43007579018b2Db091116B4C",
    _onlyWhitelistedAllowed = false,
    _amountTokenXToBuyTokenX = toWei("0");

  const presale = await deployer.deploy(
    Presale,
    _tokenX,
    _buyingToken,
    _rate,
    _walletOwner,
    _onlyWhitelistedAllowed,
    _amountTokenXToBuyTokenX
  );

  // const erc20Generator = await deployer.deploy(ERC20Generator);
  // const erc20Token = await deployer.deploy(
  //   TokenERC20,
  //   owner,
  //   "USDC",
  //   "USDC",
  //   toWei("10000")
  // );
  // const usdt = await deployer.deploy(USDT);
  // const redToken = await deployer.deploy(RedToken);
  // const blueToken = await deployer.deploy(BlueToken);

  console.log("bscTestnet:");
  // console.log(`const usdt = "${usdt.address}";`);
  // console.log(`const redToken = "${redToken.address}";`);
  // console.log(`const blueToken = "${blueToken.address}";`);
  // console.log(`const erc20Token = "${erc20Token.address}";`);
  // console.log(`const erc20Generator = "${erc20Generator.address}";`);
  console.log(`const presaleFactory = "${presaleFactory.address}";`);
  console.log(`const presale = "${presale.address}";`);
  console.log(`// const migrations = "${Migrations.address}";`);
};

const rinkeby = async (deployer, accounts) => {};

const ethMainnet = async (deployer) => {};

const toWei = web3.utils.toWei;
