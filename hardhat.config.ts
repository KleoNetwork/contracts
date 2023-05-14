import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-web3");

require("solidity-coverage");
require("hardhat-docgen");
require("@openzeppelin/hardhat-upgrades");
require("dotenv").config();


const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY;
const TESTNET_PRIVATE_KEY = process.env.TESTNET_PRIVATE_KEY;
//const MAINNET_PRIVATE_KEY = process.env.MAINNET_PRIVATE_KEY;
const POLYGON_SCAN_API_KEY = process.env.POLYGON_SCAN_API_KEY;
const AURORA_PRIVATE_KEY_TESTNET = process.env.AURORA_PRIVATE_KEY_TESTNET;
const AURORA_PRIVATE_KEY_MAINNET = process.env.AURORA_PRIVATE_KEY_MAINNET;
const AURORA_EXPLORER_API = process.env.AURORA_EXPLORER_API;


const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: {
    polygonMumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: [`${TESTNET_PRIVATE_KEY}`]
    },
    auroraDev: {
      url: `https://testnet.aurora.dev`, 
      accounts: [`${AURORA_PRIVATE_KEY_TESTNET}`],
    },
    auroraMain: {
      url: `https://aurora.dev`,
      accounts: [`${AURORA_PRIVATE_KEY_MAINNET}`]
    },
    neonTestNet: {
      url: `https://testnet.neonevm.org`,
      accounts: [`${TESTNET_PRIVATE_KEY}`]
    },
    neonMainNet: {
      url: `https://neoevm.org`,
      accounts: [`${TESTNET_PRIVATE_KEY}`]
    }
  },
  etherscan: {
    apiKey: {
      polygonMumbai: `${POLYGON_SCAN_API_KEY}`,
      auroraTestnet: `${AURORA_EXPLORER_API}`
    },
  }
};

export default config;
