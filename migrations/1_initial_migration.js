const Migrations = artifacts.require("Migrations");

const ERC20Token = artifacts.require("ERC20Token");
const ERC20TokenFactory = artifacts.require("ERC20TokenFactory");

const Presale = artifacts.require("Presale");
const PresaleFactory = artifacts.require("PresaleFactory");

const Locker = artifacts.require("Locker");

module.exports = async (deployer, network, accounts) => {
  await defaultDeploy(deployer, accounts);
  // await rinkeby(deployer, accounts);
  // await ethMainnet(deployer);
};

const defaultDeploy = async (deployer, [client, dev, owner]) => {
  await deployer.deploy(Migrations);

  const presale = await deployer.deploy(
    Presale,
    (_tokenX = "0x95FB36223A312c7fB3Bb05415b1D85771A781Db2"),
    (_lpTokenX = "0x95FB36223A312c7fB3Bb05415b1D85771A781Db2"),
    (_rate = toWei("0.2")),
    (_walletOwner = "0xc18E78C0F67A09ee43007579018b2Db091116B4C"),
    (_parentCompany = owner),
    (_onlyWhitelistedAllowed = false),
    (_amountTokenXToBuyTokenX = toWei("0")),
    (_unlockAtTime = "" + Date.now())
  );
  const presaleFactory = await deployer.deploy(
    PresaleFactory,
    (_parentCompany = owner)
  );

  const erc20Token = await deployer.deploy(
    ERC20Token,
    owner,
    "BUSD",
    "BUSD",
    toWei("10000")
  );
  const erc20TokenFactory = await deployer.deploy(ERC20TokenFactory);

  const locker = await deployer.deploy(
    Locker,
    erc20Token.address,
    owner,
    Date.now()
  );

  const fs = require("fs");
  let res = "// bscTestnet:\n";
  res += wrapper({ locker });
  res += wrapper({ erc20Token });
  res += wrapper({ erc20TokenFactory });
  res += wrapper({ presale });
  res += wrapper({ presaleFactory });
  // res += wrapper({ Migrations });

  fs.writeFile("latestContracts.js", res, console.log);
};

const rinkeby = async (deployer, accounts) => {};

const ethMainnet = async (deployer) => {};

const toWei = web3.utils.toWei;

// send variable in input as {someVariable}
const wrapper = (obj) => {
  const [varName] = Object.keys(obj);
  return `const ${varName} = new web.eth.Contract(JSON.parse('${JSON.stringify(
    obj[varName].abi
  )}'), "${obj[varName].address}");\n\n`;
};

const hour = 60 * 60 * 1000;
