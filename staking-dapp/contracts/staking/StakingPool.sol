// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakingPool is ReentrancyGuard, Pausable, Ownable {
    IERC20 public stakingToken;
    
    // Staking details
    struct Stake {
        uint256 amount;
        uint256 timestamp;
        uint256 rewards;
    }
    
    mapping(address => Stake) public stakes;
    uint256 public rewardRate = 100; // 1% = 100
    uint256 public lockPeriod = 7 days;
    
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardsClaimed(address indexed user, uint256 amount);
    
    constructor(address _stakingToken) {
        stakingToken = IERC20(_stakingToken);
    }
    
    function stake(uint256 _amount) external nonReentrant whenNotPaused {
        require(_amount > 0, "Cannot stake 0");
        require(stakingToken.transferFrom(msg.sender, address(this), _amount), "Transfer failed");
        
        stakes[msg.sender].amount += _amount;
        stakes[msg.sender].timestamp = block.timestamp;
        
        emit Staked(msg.sender, _amount);
    }
    
    function calculateRewards(address _user) public view returns (uint256) {
        Stake memory userStake = stakes[_user];
        if (userStake.amount == 0) return 0;
        
        uint256 timeStaked = block.timestamp - userStake.timestamp;
        return (userStake.amount * rewardRate * timeStaked) / (365 days * 10000);
    }
    
    function withdraw() external nonReentrant {
        require(block.timestamp >= stakes[msg.sender].timestamp + lockPeriod, "Lock period not ended");
        uint256 amount = stakes[msg.sender].amount;
        uint256 rewards = calculateRewards(msg.sender);
        
        require(amount > 0, "No stakes found");
        
        stakes[msg.sender].amount = 0;
        stakes[msg.sender].timestamp = 0;
        stakes[msg.sender].rewards = 0;
        
        require(stakingToken.transfer(msg.sender, amount + rewards), "Transfer failed");
        
        emit Withdrawn(msg.sender, amount);
        emit RewardsClaimed(msg.sender, rewards);
    }
    
    function pause() external onlyOwner {
        _pause();
    }
    
    function unpause() external onlyOwner {
        _unpause();
    }
}

