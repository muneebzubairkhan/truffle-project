const Migrations = artifacts.require('Migrations');

const ERC20Token = artifacts.require('ERC20Token');
const ERC20TokenFactory = artifacts.require('ERC20TokenFactory');

const Presale = artifacts.require('Presale');
const PresaleFactory = artifacts.require('PresaleFactory');

const Locker = artifacts.require('Locker');

const networksConfig = require('../truffle-config');

module.exports = async (deployer, network, accounts) => {
  // if (network === "development") return;

  console.log('network: ', network);
  await deployer.deploy(Migrations);
  await defaultDeploy(deployer, network, accounts);
  // await rinkeby(deployer, accounts);
  // await ethMainnet(deployer);
};

const defaultDeploy = async (deployer, network, [owner, addr1, addr2]) => {
  let busd, busdAddress, tokenX, tokenXAddress, lpTokenX, lpTokenXAddress;

  if (network === 'develop' || network === 'development') {
    busd = await deployer.deploy(
      ERC20Token,
      owner,
      'BUSD',
      'BUSD',
      toWei('10000'),
    );
    tokenX = await deployer.deploy(
      ERC20Token,
      owner,
      'Red Token',
      'RED',
      toWei('10000'),
    );
    lpTokenX = await deployer.deploy(
      ERC20Token,
      owner,
      'Red Token',
      'RED',
      toWei('10000'),
    );
  } else {
    if (network === 'bscTestnet') {
      busdAddress = '0xec828b4305be12B9B3E8F584FCE8ACDCc56c86E7';
      tokenXAddress = '0x95FB36223A312c7fB3Bb05415b1D85771A781Db2';
      lpTokenXAddress = '0x95FB36223A312c7fB3Bb05415b1D85771A781Db2';
    } else if (network === 'rinkeby') {
      busdAddress = '0x60D4f85E9C78e01c3378fc15cbd222009EC9A4Dd';
      tokenXAddress = '0x7eC6d1aEB55AE52364B0F6Ff47Ef4fe109eeC6eE';
      lpTokenXAddress = '0x57fed6fd1f0c3c37e133b886b6dc96c309da6648';
    } else {
      new Error('Hey Bro, Please provide config here');
    }

    busd = await ERC20Token.at(busdAddress);
    tokenX = await ERC20Token.at(tokenXAddress);
    lpTokenX = await ERC20Token.at(lpTokenXAddress);
  }

  // const erc20TokenFactory = await deployer.deploy(ERC20TokenFactory);

  const presale = await deployer.deploy(
    Presale,
    (_tokenX = '0x95FB36223A312c7fB3Bb05415b1D85771A781Db2'),
    (_lpTokenX_ = '0x95FB36223A312c7fB3Bb05415b1D85771A781Db2'),
    busd.address,
    (_rate = toWei('0.2')),
    (_walletOwner = '0xc18E78C0F67A09ee43007579018b2Db091116B4C'),
    (_onlyWhitelistedAllowed = false),
    (_amountTokenXToBuyTokenX = toWei('0')),
    [addr1, addr2, '0x95FB36223A312c7fB3Bb05415b1D85771A781Db2'],
  );

  const presaleFactory = await deployer.deploy(
    PresaleFactory,
    (_parentCompany = owner),
    busd.address,
  );

  if (!(network === 'bscMainnet' || network === 'mainnet'))
    await makePresaleFromFactoryForTesting(presaleFactory, tokenX);

  // 100% 11.26am
  // 75% 12.26pm
  const locker = await deployer.deploy(Locker, busd.address, owner, Date.now());

  // generate some helper links and code and save in a file
  // if (network !== 'development')
  {
    const fs = require('fs');
    let res = `// ${up(network)}:\n`;

    // console.log({ networksConfig });

    console.log(
      'networksConfig.networks[network]: ',
      networksConfig.networks[network],
    );

    const { explorerUrl, web3Provider } = networksConfig.networks[network];
    console.log({
      explorerUrl,
      web3Provider,
    });

    res += makeExplorerLink(explorerUrl, {
      busd,
      tokenX,
      lpTokenX,
      presale,
      presaleFactory,
      locker,
    });
    res += '//\n//=========================\n\n';
    res += makeContractObjects(web3Provider, {
      busd,
      tokenX,
      lpTokenX,
      presale,
      presaleFactory,
      locker,
    });

    fs.writeFile('smart-contracts.js', res, console.log);
  }
};

const makePresaleFromFactoryForTesting = async (presaleFactory, tokenX) => {
  await presaleFactory.createERC20Presale(
    tokenX.address,
    tokenX.address,
    (_rate_ = toWei('0.2')),
    (_tokenXToLock_ = '0'),
    (_lpTokenXToLock_ = '0'),
    (_tokenXToSell_ = '0'),
    (_unlockAtTime_ = '0'),
    (_amountTokenXToBuyTokenX_ = '0'),
    (_presaleEarningWallet_ = '0xc18E78C0F67A09ee43007579018b2Db091116B4C'),
    (_onlyWhitelistedAllowed_ = false),
    ['0x95FB36223A312c7fB3Bb05415b1D85771A781Db2'],
  );
};

// const rinkeby = async (deployer, accounts) => {};

const ethMainnet = async deployer => {};

const toWei = web3.utils.toWei;

// capitalizeFirstLetter
const up = s => s.charAt(0).toUpperCase() + s.slice(1);

// send variable in input as {someVariable}
// obj is variables object (it contains variables)
const makeContractObjects = (obj, web3Provider) => {
  const boiledWeb3 = `
  // if you want to do only get calls then you can use defaultWeb3.

  import Web3 from 'web3';
  
  export const defaultWeb3 = new Web3(
    'https://data-seed-prebsc-2-s2.binance.org:8545'
  );
  
  `;

  return (
    boiledWeb3 +
    Object.keys(obj)
      .map(varName =>
        boil(varName, stringify(obj[varName].abi), obj[varName].address),
      )
      .join('\n\n')
  );
};

const boil = (varName, abi, address) =>
  `
  export const ${varName}Address = '${address}';
  export const ${varName}Abi = JSON.parse(
    '${abi}'
  );
  export const getContract${up(
    varName,
  )} = (web3 = defaultWeb3, address = ${varName}Address) => 
    new web3.eth.Contract(
      ${varName}Abi, address
    );
  `;

const makeExplorerLink = (explorerUrl = '', obj) => {
  const vars = Object.keys(obj);

  let data = '';
  vars.map(contractName => {
    data += `// ${up(contractName)} ${explorerUrl}${
      obj[contractName].address
    }\n`;
  });

  return data;
};

// explorerUrlFor = network => {
//   let url;
//   if (network === 'rinkeby') url = '';
//   else if (network === 'rinkeby') url = 'https://rinkeby.etherscan.io/address/';
//   else if (network === 'rinkeby') url = 'https://rinkeby.etherscan.io/address/';
//   else if (network === 'rinkeby') url = 'https://rinkeby.etherscan.io/address/';
//   else if (network === 'rinkeby') url = 'https://rinkeby.etherscan.io/address/';
// };

const hour = 60 * 60 * 1000;
7;
const stringify = JSON.stringify;
/*

https://www.ovhcloud.com/it/bare-metal/hosting/?xtor=SEC-13-GOO-[it_int_2020_ovh_baremetal_undefinite_sale_acquisition_srch_offensive()]-[496561848614]-S-[]&gclid=CjwKCAjwsNiIBhBdEiwAJK4khscOu7d1CLdsfI1qBuqc0alOdNY6SwO4pBmfVHZ8rZtrepmAPKawtxoCNt0QAvD_BwE

*/

// .map( () => { () }) I will remove these braces in future
// done: (todo later improve it, i.e take explorer as input)
