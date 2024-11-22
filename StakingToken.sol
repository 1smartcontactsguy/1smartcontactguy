// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StakingToken is ERC20, Ownable {

    // Mapping for staked balances and staking time
    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public stakingTime;
    
    // Reward token contract link
    IERC20 public rewardToken; // The reward token (ERC20) contract instance

    // Initial supply of StakingTokens
    uint256 public initialSupply = 10_000_000 * 10**18; // Example: 10 million tokens (with 18 decimals)

    constructor(address _rewardToken) ERC20("StakingToken", "STAKE") {
        rewardToken = IERC20(_rewardToken);

        // Mint the initial supply of StakingTokens to the contract owner
        _mint(msg.sender, initialSupply); // Minting to contract owner address
    }

    modifier onlyOwner() {
        require(msg.sender == owner(), "Not owner");
        _;
    }

    // Function to stake tokens
    function stake(uint256 amount) external {
        require(amount > 0, "Cannot stake 0 tokens");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to stake");

        stakedBalance[msg.sender] += amount;
        stakingTime[msg.sender] = block.timestamp;

        _transfer(msg.sender, address(this), amount); // Transfer the tokens to the staking contract
    }

    // Function to unstake tokens
    function unstake(uint256 amount) external {
        require(stakedBalance[msg.sender] >= amount, "Not enough staked tokens");

        stakedBalance[msg.sender] -= amount;

        _transfer(address(this), msg.sender, amount); // Transfer the tokens back to the user
    }

    // Function to calculate rewards
    function calculateRewards(address account) public view returns (uint256) {
        uint256 stakedDuration = block.timestamp - stakingTime[account];
        uint256 reward = (stakedBalance[account] * rewardRate * stakedDuration) / 60 seconds; // reward calculation logic
        return reward;
    }

    // Function to claim rewards
    function claimRewards() external {
        uint256 rewards = calculateRewards(msg.sender);
        require(rewards > 0, "No rewards to claim");

        // Mint or transfer reward tokens
        rewardToken.transfer(msg.sender, rewards);
    }
}
