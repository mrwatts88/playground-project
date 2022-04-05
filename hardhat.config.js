require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

const fs = require('fs');
const path = require("path");
const key = fs.readFileSync(path.resolve(__dirname, "./.key.txt"));
const etherscanKey = fs.readFileSync(path.resolve(__dirname, "./.etherscan-key.txt"));

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  settings: {
    optimizer: {enabled: process.env.DEBUG ? false : true},
  },
  networks: {
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/9a349c5cab5c4b6dba9590d704578388`,
      accounts: [key.toString()]
    }
  },
  etherscan: {
    apiKey: etherscanKey.toString(),
  }
};
