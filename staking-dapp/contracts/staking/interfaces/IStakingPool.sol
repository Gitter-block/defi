// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IStakingPool {
    struct Stake {
        uint256 amount;
        uint256 timestamp;
        uint256 rewards;
    }
    
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);
    
    function stake(uint256 amount) external;
    function withdraw() external;
    function calculateRewards(address user) external view returns (uint256);
}
