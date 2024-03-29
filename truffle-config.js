var HDWalletProvider = require("@truffle/hdwallet-provider");
const { toWei } = require("web3-utils");
require("dotenv").config();
const MNEMONIC = process.env.MNEMONIC;
const token = process.env.INFURA_TOKEN;

const AVAX_SCAN_KEY = process.env.AVAX_SCAN_KEY;
const ETHERSCAN_KEY = process.env.ETHERSCAN_KEY;
const BSCSCAN_KEY = process.env.BSCSCAN_KEY;
const POLYGON_KEY = process.env.POLYGON_KEY;

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
      gas: 3000000,
      gasPrice: toWei("0", "gwei"),
      explorerUrl: " ",
      web3Provider: "http://127.0.0.1/",
    },

    develop: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*",
      explorerUrl: " ",
      web3Provider: "http://127.0.0.1/",
    },

    fuji: {
      provider: () =>
        new HDWalletProvider(
          MNEMONIC,
          `https://api.avax-test.network/ext/bc/C/rpc`
        ),
      network_id: 1,
      // timeoutBlocks: 200,
      // confirmations: 5,
      skipDryRun: true,
      explorerUrl: "https://testnet.snowtrace.io/address/",
      web3Provider: "https://api.avax-test.network/ext/bc/C/rpc",
    },
    avaxMainnet: {
      provider: () =>
        new HDWalletProvider(MNEMONIC, "https://api.avax.network/ext/bc/C/rpc"),
      network_id: 1,
      timeoutBlocks: 200,
      // confirmations: 5,
      gas: 3000000,
      gasPrice: toWei("25", "gwei"),
      skipDryRun: true,
      explorerUrl: "https://snowtrace.io/address/",
      web3Provider: "https://api.avax-test.network/ext/bc/C/rpc",
    },

    bscTestnet: {
      provider: () =>
        new HDWalletProvider(
          MNEMONIC,
          "https://data-seed-prebsc-2-s2.binance.org:8545"
        ),
      network_id: "97",
      explorerUrl: "https://testnet.bscscan.com/address/",
      web3Provider: "https://data-seed-prebsc-2-s2.binance.org:8545",
    },
    rinkeby: {
      provider: () =>
        new HDWalletProvider(MNEMONIC, "https://rinkeby.infura.io/v3/" + token),
      network_id: "4",
      // gas: "3000000",
      // gasPrice: toWei("1.5", "gwei"),
      skipDryRun: true,
      explorerUrl: "https://rinkeby.etherscan.io/address/",
      web3Provider: "https://rinkeby.infura.io/v3/" + token,
    },
    mumbai: {
      provider: () =>
        new HDWalletProvider(
          MNEMONIC,
          "https://matic-mumbai.chainstacklabs.com"
        ),
      network_id: "80001",
      gas: "20000000",
      gasPrice: toWei("0.000000050", "ether"),
      // maxFeePerGas: toWei("0.000000100", "ether"),
      // maxPriorityFeePerGas: toWei("0.000000003", "ether"),
      explorerUrl: "https://mumbai.polygonscan.com/address/",
    },
    polygon: {
      provider: () => new HDWalletProvider(MNEMONIC, "https://polygon-rpc.com"),
      network_id: "137",
      gas: "6000000",
      gasPrice: toWei("0.000000060", "ether"),
      // maxFeePerGas: toWei("0.000000100", "ether"),
      // maxPriorityFeePerGas: toWei("0.000000003", "ether"),
      explorerUrl: "https://mumbai.polygonscan.com/address/",
    },
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
  plugins: ["truffle-plugin-verify"],
  api_keys: {
    etherscan: ETHERSCAN_KEY,
    snowtrace: AVAX_SCAN_KEY,
    bscscan: BSCSCAN_KEY,
    polygonscan: POLYGON_KEY,

    ftmscan: "MY_API_KEY",
    hecoinfo: "MY_API_KEY",
    moonscan: "MY_API_KEY",
  },
  compilers: {
    solc: {
      version: "0.8.13",
      settings: {
        optimizer: {
          enabled: true,
          runs: 200,
        },
      },
    },
  },
};



// sudo truffle migrate --reset --network rinkeby
// sudo truffle run verify NftStaking --network rinkeby

// truffle-flattener <solidity-files>