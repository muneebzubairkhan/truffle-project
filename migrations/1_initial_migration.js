const Migrations = artifacts.require('Migrations');

const ERC20Token = artifacts.require('ERC20Token');
const ERC20TokenFactory = artifacts.require('ERC20TokenFactory');

const Presale = artifacts.require('Presale');
const PresaleFactory = artifacts.require('PresaleFactory');

const Locker = artifacts.require('Locker');

const MAX_INT =
  '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';

const { toWei } = require('web3-utils');
const networksConfig = require('../truffle-config');
const { makeHelperCodeForUIDev } = require('./helper');

module.exports = async (deployer, network, accounts) => {
  // if (network === "development") return;

  // console.log('network: ', network);
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
      lpTokenXAddress = '0xd0c8bd31f616837c912c9aa097b8ce45624da987';
    } else if (network === 'rinkeby') {
      busdAddress = '0x60D4f85E9C78e01c3378fc15cbd222009EC9A4Dd';
      tokenXAddress = '0x7eC6d1aEB55AE52364B0F6Ff47Ef4fe109eeC6eE';
      lpTokenXAddress = '0x57fed6fd1f0c3c37e133b886b6dc96c309da6648';
    } else {
      new Error(
        'Hey Bro, Please provide config here like we did in above lines.',
      );
    }

    busd = await ERC20Token.at(busdAddress);
    tokenX = await ERC20Token.at(tokenXAddress);
    lpTokenX = await ERC20Token.at(lpTokenXAddress);
  }

  // const erc20TokenFactory = await deployer.deploy(ERC20TokenFactory);

  // const presale = await deployer.deploy(
  //   Presale,
  //   (_tokenX_ = '0x95FB36223A312c7fB3Bb05415b1D85771A781Db2'),
  //   (_lpTokenX_ = '0x95FB36223A312c7fB3Bb05415b1D85771A781Db2'),
  //   (_tokenToHold_ = '0x95FB36223A312c7fB3Bb05415b1D85771A781Db2'),
  //   busd.address,
  //   (_rate = toWei('0.2')),
  //   (_walletOwner = '0xc18E78C0F67A09ee43007579018b2Db091116B4C'),
  //   (_onlyWhitelistedAllowed = false),
  //   (_amountTokenXToBuyTokenX = toWei('0')),
  //   [addr1, addr2, '0x95FB36223A312c7fB3Bb05415b1D85771A781Db2'],
  //   socialMedia + socialMedia,
  // );

  const presaleFactory = await deployer.deploy(
    PresaleFactory,
    (_parentCompany = owner),
    busd.address,
    (tokenToHold_ = busd.address),
    (amountTokenToHold_ = 0),
  );

  // if (!(network === 'bscMainnet' || network === 'mainnet')) {
  //   await makePresaleFromFactoryForTesting(presaleFactory, tokenX, lpTokenX);
  //   await makePresaleFromFactoryForTesting(presaleFactory, lpTokenX, tokenX);

  //   const presaleAddress = await presaleFactory.presales(0);
  //   const presale = await Presale.at(presaleAddress);
  //   await presale.onlyParent_editPresaleIsApproved(true);
  // }

  makeHelperCodeForUIDev(network, {
    busd,
    tokenX,
    lpTokenX,
    presaleFactory,
  });
};

const makePresaleFromFactoryForTesting = async (
  presaleFactory,
  tokenX,
  lpTokenX,
) => {
  await tokenX.approve(presaleFactory.address, MAX_INT);
  await lpTokenX.approve(presaleFactory.address, MAX_INT);

  const truncNum = n => Number(Math.trunc(n));

  await presaleFactory.createERC20Presale(
    // ................................token to hold
    [tokenX.address, lpTokenX.address, lpTokenX.address],
    (_rate_ = toWei('0.2')),
    (_tokenXToLock_ = toWei('5.55')),
    (_lpTokenXToLock_ = toWei('10.77')),
    (_tokenXToSell_ = toWei('12.33')), // hard cap
    (_unlockAtTime_ = truncNum(Date.now() / 1000)),
    (_amountTokenXToBuyTokenX_ = '0'),
    (_presaleOwner_ = '0xc18E78C0F67A09ee43007579018b2Db091116B4C'),
    (_onlyWhitelistedAllowed_ = false),
    ['0x95FB36223A312c7fB3Bb05415b1D85771A781Db2'],
    socialMedia,
  );
};

const delimitter = '@$@L';
const socialMedia = `https://www.facebook.com/muneeb.qureshi.50951${delimitter}https://twitter.com/muneeb_butt9?lang=en${delimitter}https://www.instagram.com/muneeb_butt/?hl=en${delimitter}https://docs.google.com/document/d/1_buydr48_P5PSzLc7d1i5DqXA7jpn5dZVNEP_42Birs/edit`;

/*

https://www.ovhcloud.com/it/bare-metal/hosting/?xtor=SEC-13-GOO-[it_int_2020_ovh_baremetal_undefinite_sale_acquisition_srch_offensive()]-[496561848614]-S-[]&gclid=CjwKCAjwsNiIBhBdEiwAJK4khscOu7d1CLdsfI1qBuqc0alOdNY6SwO4pBmfVHZ8rZtrepmAPKawtxoCNt0QAvD_BwE

*/

// .map( () => { () }) I will remove these braces in future
