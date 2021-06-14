const path = require("path");
const HDWalletProvider = require('@truffle/hdwallet-provider');
const privateKeys = process.env.PRIVATE_KEYS || ""

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "client/src/contracts"),
  networks: {
    develop: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*"
    },
    kovan: {
      provider: function() {
        return new HDWalletProvider(
          privateKeys.split(','), // Array of account private keys
          `https://kovan.infura.io/v3/${process.env.INFURA_API_KEY}`// Url to an Ethereum Node
        )
      },
      gas: 5000000,
      gasPrice: 5000000000, // 5 gwei
      network_id: 42
    },
    main: {
      provider: function() {
        return new HDWalletProvider(
          privateKeys.split(','), // Array of account private keys
          `https://main.infura.io/v3/${process.env.INFURA_API_KEY}`// Url to an Ethereum Node
        )
      },
      gas: 5000000,
      gasPrice: 5000000000, // 5 gwei
      network_id: 1
    },
    rinkeby: {
      provider: function() {
        return new HDWalletProvider(
          privateKeys.split(','), // Array of account private keys
          `https://rinkeby.infura.io/v3/${process.env.INFURA_API_KEY}`// Url to an Ethereum Node
        )
      },
      gas: 5000000,
      gasPrice: 5000000000, // 5 gwei
      network_id: 4
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(
          privateKeys.split(','), // Array of account private keys
          `https://ropsten.infura.io/v3/${process.env.INFURA_API_KEY}`// Url to an Ethereum Node
        )
      },
      gas: 5000000,
      gasPrice: 5000000000, // 5 gwei
      network_id: 3
    }
  },
  contracts_directory: './src/contracts/',
  compilers: {
    solc: {
      version: ">=0.4.21 <0.7.0 ",
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
  
};
