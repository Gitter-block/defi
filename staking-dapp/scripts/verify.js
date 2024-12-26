const hre = require("hardhat");
require("dotenv").config();

async function verifyContract(address, constructorArguments) {
    console.log("Verifying contract...");
    try {
        await hre.run("verify:verify", {
            address: address,
            constructorArguments: constructorArguments,
        });
        console.log("Contract verified successfully");
    } catch (error) {
        if (error.message.toLowerCase().includes("already verified")) {
            console.log("Contract is already verified!");
        } else {
            console.error("Error verifying contract:", error);
        }
    }
}

async function main() {
    // Contract addresses from deployment
    const STAKING_TOKEN_ADDRESS = process.env.STAKING_TOKEN_ADDRESS;
    const REWARD_TOKEN_ADDRESS = process.env.REWARD_TOKEN_ADDRESS;
    const STAKING_POOL_ADDRESS = process.env.STAKING_POOL_ADDRESS;

    // Verify StakingToken
    await verifyContract(STAKING_TOKEN_ADDRESS, []);

    // Verify RewardToken
    await verifyContract(REWARD_TOKEN_ADDRESS, []);

    // Verify StakingPool
    await verifyContract(STAKING_POOL_ADDRESS, [STAKING_TOKEN_ADDRESS]);
}

// Execute verification
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
