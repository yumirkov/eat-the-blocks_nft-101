require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config("./.env");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
    solidity: "0.8.2",
    networks: {
        mumbai: {
            url: process.env.MUMBAI_RPC,
            accounts: [process.env.PRIVATE_KEY],
        },
    },
};
