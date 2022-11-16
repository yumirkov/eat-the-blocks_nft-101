const { ethers } = require("hardhat");

async function main() {
    const contractFactory = await ethers.getContractFactory("SuperMarioWorld");
    const contract = await contractFactory.deploy("SuperMarioWorld", "SPRM");
    await contract.deployed();

    console.log(`Success! Contract was deployed to: ${contract.address}`);

    await contract.mint("https://ipfs.io/ipfs/QmeX9DWdk4nt46CHR5AsezRywjg6AX8km8aic5aqNikA5e");

    console.log("NFT successfully minted");
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
