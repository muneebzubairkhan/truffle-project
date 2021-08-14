var HDWalletProvider = require("@truffle/hdwallet-provider");
require("dotenv").config();
const MNEMONIC = process.env.MNEMONIC;
const token = process.env.INFURA_TOKEN;
const etherscanKey = process.env.BSCSCAN_KEY;
// const etherscanKey = process.env.ETHERSCAN_KEY;
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
      gas: 6721975,
    },
    bscTestnet: {
      provider: () => {
        return new HDWalletProvider(
          MNEMONIC,
          "https://data-seed-prebsc-1-s1.binance.org:8545"
        );
      },
      network_id: "97",
      skipDryRun: true,
    },

    bscMainnet: {
      provider: () => {
        return new HDWalletProvider(
          MNEMONIC,
          "https://bsc-dataseed.binance.org"
        );
      },
      network_id: "56",
    },

    mainnet: {
      provider: () => {
        return new HDWalletProvider(
          MNEMONIC,
          "https://mainnet.infura.io/v3/" + token
        );
      },
      network_id: "1",
    },
    ropsten: {
      provider: () => {
        return new HDWalletProvider(
          MNEMONIC,
          "https://ropsten.infura.io/v3/" + token
        );
      },
      network_id: "3",
      skipDryRun: true,
    },
    rinkeby: {
      provider: () => {
        return new HDWalletProvider(
          MNEMONIC,
          "https://rinkeby.infura.io/v3/" + token
        );
      },
      network_id: "4",
      skipDryRun: true,
    },
    kovan: {
      provider: () => {
        return new HDWalletProvider(
          MNEMONIC,
          "https://kovan.infura.io/v3/" + token
        );
      },
      network_id: "42",
      skipDryRun: true,
    },
  },
  plugins: ["truffle-plugin-verify"],
  api_keys: {
    etherscan: etherscanKey,
  },
  compilers: {
    solc: {
      version: "0.8.0",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
      },
    },
  },
  mocha: {
    reporter: "eth-gas-reporter",
  },
};
