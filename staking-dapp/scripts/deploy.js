const hre = require("hardhat");

async function main() {
    const [deployer] = await hre.ethers.getSigners();
    console.log("Deploying contracts with account:", deployer.address);

    const StakingToken = await hre.ethers.getContractFactory("StakingToken");
    const stakingToken = await StakingToken.deploy();
    await stakingToken.deployed();

    const StakingPool = await hre.ethers.getContractFactory("StakingPool");
    const stakingPool = await StakingPool.deploy(stakingToken.address);
    await stakingPool.deployed();

    console.log("StakingToken deployed to:", stakingToken.address);
    console.log("StakingPool deployed to:", stakingPool.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
