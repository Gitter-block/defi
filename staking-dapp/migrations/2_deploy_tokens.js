const StakingToken = artifacts.require("StakingToken");
const RewardToken = artifacts.require("RewardToken");

module.exports = function (deployer) {
    deployer.deploy(StakingToken)
        .then(() => deployer.deploy(RewardToken));
};
