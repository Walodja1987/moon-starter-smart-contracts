require("@nomiclabs/hardhat-waffle");
require("dotenv").config(); // npm install dotenv
require("hardhat-gas-reporter"); // npm install hardhat-gas-reporter

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

const PRIVATE_KEY = process.env.PRIVATE_KEY
const MNEMONIC = process.env.MNEMONIC

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 module.exports = {
  solidity: "0.8.4",
  networks: {
      hardhat: {
          forking: {
              url: process.env.ALCHEMY_URL,
          },
          gas: "auto"
      },
  },
  gasReporter:{
      currency: "USD",
      gasPrice: 20,
      enabled: true,
  }
};
