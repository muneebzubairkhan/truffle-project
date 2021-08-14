const Migrations = artifacts.require("Migrations");

const ERC20Token = artifacts.require("ERC20Token");
const ERC20TokenFactory = artifacts.require("ERC20TokenFactory");

const Presale = artifacts.require("Presale");
const PresaleFactory = artifacts.require("PresaleFactory");

const Locker = artifacts.require("Locker");

module.exports = async (deployer, network, accounts) => {
  console.log("network: ", network);
  await defaultDeploy(deployer, network, accounts);
  // await rinkeby(deployer, accounts);
  // await ethMainnet(deployer);
};

const defaultDeploy = async (deployer, network, [client, dev, owner]) => {
  await deployer.deploy(Migrations);
  let busd, tokenX;

  if (network === "development") {
    busd = await deployer.deploy(
      ERC20Token,
      owner,
      "BUSD",
      "BUSD",
      toWei("10000")
    );
    tokenX = await deployer.deploy(
      ERC20Token,
      owner,
      "Red Token",
      "RED",
      toWei("10000")
    );
  } else {
    const busdAddress = "0xec828b4305be12B9B3E8F584FCE8ACDCc56c86E7";
    const tokenXAddress = "0x95FB36223A312c7fB3Bb05415b1D85771A781Db2";
    busd = await ERC20Token.at(busdAddress);
    tokenX = await ERC20Token.at(tokenXAddress);
  }
  // const erc20TokenFactory = await deployer.deploy(ERC20TokenFactory);

  const presale = await deployer.deploy(
    Presale,
    (_tokenX = "0x95FB36223A312c7fB3Bb05415b1D85771A781Db2"),
    (_lpTokenX = "0x95FB36223A312c7fB3Bb05415b1D85771A781Db2"),
    busd.address,
    (_rate = toWei("0.2")),
    (_walletOwner = "0xc18E78C0F67A09ee43007579018b2Db091116B4C"),
    (_parentCompany = owner),
    (_onlyWhitelistedAllowed = false),
    (_amountTokenXToBuyTokenX = toWei("0")),
    (_unlockAtTime = "" + Date.now())
  );
  const presaleFactory = await deployer.deploy(
    PresaleFactory,
    (_parentCompany = owner),
    busd.address
  );

  const locker = await deployer.deploy(Locker, busd.address, owner, Date.now());

  // todo later improve it, i.e take explorer as input
  const fs = require("fs");
  let res = "// bscTestnet:\n";
  res += makeExplorerLink({ locker });
  res += makeExplorerLink({ busd });
  res += makeExplorerLink({ tokenX });
  res += makeExplorerLink({ presale });
  res += makeExplorerLink({ presaleFactory });
  res += makeExplorerLink({ Migrations });
  res += "//=========================\n\n";
  res += makeContractObject({ locker });
  res += makeContractObject({ busd });
  res += makeContractObject({ tokenX });
  res += makeContractObject({ presale });
  res += makeContractObject({ presaleFactory });

  fs.writeFile("smart-contracts.js", res, console.log);
};

const rinkeby = async (deployer, accounts) => {};

const ethMainnet = async (deployer) => {};

const toWei = web3.utils.toWei;

// send variable in input as {someVariable}
const makeContractObject = (obj) => {
  const [varName] = Object.keys(obj);
  return `export const ${varName} = new web.eth.Contract(JSON.parse('${JSON.stringify(
    obj[varName].abi
  )}'), "${obj[varName].address}");\n`;
};

const makeExplorerLink = (obj) => {
  const [varName] = Object.keys(obj);
  return `// ${varName} https://testnet.bscscan.com/address/${obj[varName].address}/#contracts\n\n`;
};

const hour = 60 * 60 * 1000;
7;


/*

https://www.ovhcloud.com/it/bare-metal/hosting/?xtor=SEC-13-GOO-[it_int_2020_ovh_baremetal_undefinite_sale_acquisition_srch_offensive()]-[496561848614]-S-[]&gclid=CjwKCAjwsNiIBhBdEiwAJK4khscOu7d1CLdsfI1qBuqc0alOdNY6SwO4pBmfVHZ8rZtrepmAPKawtxoCNt0QAvD_BwE

*/