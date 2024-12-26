const StakingPool = artifacts.require("StakingPool");
const StakingToken = artifacts.require("StakingToken");

module.exports = async function (deployer) {
    const stakingToken = await StakingToken.deployed();
    await deployer.deploy(StakingPool, stakingToken.address);
};
