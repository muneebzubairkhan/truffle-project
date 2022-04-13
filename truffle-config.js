var HDWalletProvider = require("@truffle/hdwallet-provider");
const { toWei } = require("web3-utils");
require("dotenv").config();
const MNEMONIC = process.env.MNEMONIC;
const token = process.env.INFURA_TOKEN;

const AVAX_SCAN_KEY = process.env.AVAX_SCAN_KEY;
const ETHERSCAN_KEY = process.env.ETHERSCAN_KEY;
const BSCSCAN_KEY = process.env.BSCSCAN_KEY;
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
      gas: 6721975,
      gasPrice: toWei("100", "gwei"),
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
          `https://api.avax-test.network/ext/bc/C/rpc`,
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
          "https://data-seed-prebsc-2-s2.binance.org:8545",
        ),
      network_id: "97",
      explorerUrl: "https://testnet.bscscan.com/address/",
      web3Provider: "https://data-seed-prebsc-2-s2.binance.org:8545",
    },
    rinkeby: {
      provider: () =>
        new HDWalletProvider(MNEMONIC, "https://rinkeby.infura.io/v3/" + token),
      network_id: "4",
      skipDryRun: true,
      explorerUrl: "https://rinkeby.etherscan.io/address/",
      web3Provider: "https://rinkeby.infura.io/v3/" + token,
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
  plugins: ["truffle-plugin-verify", "eth-gas-reporter"],
  api_keys: {
    etherscan: ETHERSCAN_KEY,
    snowtrace: AVAX_SCAN_KEY,
    bscscan: BSCSCAN_KEY,
    polygonscan: "MY_API_KEY",
    ftmscan: "MY_API_KEY",
    hecoinfo: "MY_API_KEY",
    moonscan: "MY_API_KEY",
  },
  compilers: {
    solc: {
      version: "0.8.12",
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
    gasReporter: { noColors: true, outputFile: "./okok.txt" },
  },
};



// sudo truffle migrate --reset --network rinkeby
// sudo truffle run verify NftStaking --network rinkeby

// truffle-flattener <solidity-files>