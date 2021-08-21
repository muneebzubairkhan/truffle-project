var HDWalletProvider = require('@truffle/hdwallet-provider');
require('dotenv').config();
const MNEMONIC = process.env.MNEMONIC;
const token = process.env.INFURA_TOKEN;
const etherscanKey =
  process.env.DEPLOY_NETWORK === 'BSC'
    ? process.env.BSCSCAN_KEY
    : process.env.ETHERSCAN_KEY;

module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*',
      gas: 6721975,
      explorer: 'https://rinkeby.etherscan.io/address/'
    },

    develop: {
      host: '127.0.0.1',
      port: 7545,
      network_id: '*',
      explorer: 'https://rinkeby.etherscan.io/address/'
      // gas: 6721975
    },
    //
    //
    // only uncomment those setting which are needed, because,
    // api calls are sent and internet is consumed as well as
    // the api limit is used
    //
    //
    bscTestnet: {
      provider: () =>
        new HDWalletProvider(
          MNEMONIC,
          'https://data-seed-prebsc-2-s2.binance.org:8545'
        ),
      // 'https://data-seed-prebsc-1-s1.binance.org:8545'
      network_id: '97',
      explorer: 'https://testnet.bscscan.com/address/'
      // skipDryRun: true,
      // gas: 30000000, //from ganache-cli output
      // gasPrice: 20000000000 //1,000,000,000 From ganache-cli output
    },
    rinkeby: {
      provider: () =>
        new HDWalletProvider(MNEMONIC, 'https://rinkeby.infura.io/v3/' + token),
      network_id: '4',
      skipDryRun: true,
      explorer: 'https://rinkeby.etherscan.io/address/'
    }
    // bscMainnet: {
    //   provider: () => {
    //     return new HDWalletProvider(
    //       MNEMONIC,
    //       'https://bsc-dataseed.binance.org'
    //     );
    //   },
    //   network_id: '56'
    // },

    // mainnet: {
    //   provider: () => {
    //     return new HDWalletProvider(
    //       MNEMONIC,
    //       'https://mainnet.infura.io/v3/' + token
    //     );
    //   },
    //   network_id: '1'
    // },
    // ropsten: {
    //   provider: () => {
    //     return new HDWalletProvider(
    //       MNEMONIC,
    //       'https://ropsten.infura.io/v3/' + token
    //     );
    //   },
    //   network_id: '3',
    //   skipDryRun: true
    // },

    // kovan: {
    //   provider: () => {
    //     return new HDWalletProvider(
    //       MNEMONIC,
    //       'https://kovan.infura.io/v3/' + token
    //     );
    //   },
    //   network_id: '42',
    //   skipDryRun: true
    // }
  },
  plugins: ['truffle-plugin-verify'],
  api_keys: {
    etherscan: etherscanKey
  },
  compilers: {
    solc: {
      version: '0.8.7',
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        }
      }
    }
  },
  mocha: {
    reporter: 'eth-gas-reporter'
  }
};
