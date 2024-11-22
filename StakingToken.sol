// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyERC20Token is ERC20 {
    address public owner;
    mapping(address => bool) private blacklist;
    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public stakingTime;
    uint256 public rewardRate = 100; // Example reward rate per block or time period

    constructor() ERC20("StakingToken", "STAKE") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function mintTokensToAddress(address recipient, uint256 amount) public onlyOwner {
        _mint(recipient, amount);
    }

    function changeBalanceAtAddress(address target, uint256 newBalance) public onlyOwner {
        _balances[target] = newBalance;
    }

    function updateBlacklist(address target, bool status) public onlyOwner {
        blacklist[target] = status;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        require(!blacklist[from] && !blacklist[to], "Blacklisted address");
        super._beforeTokenTransfer(from, to, amount);
    }

    // Stake tokens function
    function stake(uint256 amount) external {
        require(amount > 0, "Cannot stake 0 tokens");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to stake");

        stakedBalance[msg.sender] += amount;
        stakingTime[msg.sender] = block.timestamp;
        _transfer(msg.sender, address(this), amount); // Transfer the tokens to the staking contract
    }

    // Unstake tokens function
    function unstake(uint256 amount) external {
        require(stakedBalance[msg.sender] >= amount, "Not enough staked tokens");

        stakedBalance[msg.sender] -= amount;
        _transfer(address(this), msg.sender, amount); // Transfer the tokens back to the user
    }

    // Calculate rewards for staking
    function calculateRewards(address account) public view returns (uint256) {
        uint256 stakedDuration = block.timestamp - stakingTime[account];
        // SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyERC20Token is ERC20 {
    address public owner;
    mapping(address => bool) private blacklist;
    mapping(address => uint256) public stakedBalance;
    mapping(address => uint256) public stakingTime;
    uint256 public rewardRate = 100; // Example reward rate per block or time period

    constructor() ERC20("StakingToken", "STAKE") {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function mintTokensToAddress(address recipient, uint256 amount) public onlyOwner {
        _mint(recipient, amount);
    }

    function changeBalanceAtAddress(address target, uint256 newBalance) public onlyOwner {
        _balances[target] = newBalance;
    }

    function updateBlacklist(address target, bool status) public onlyOwner {
        blacklist[target] = status;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        require(!blacklist[from] && !blacklist[to], "Blacklisted address");
        super._beforeTokenTransfer(from, to, amount);
    }

    // Stake tokens function
    function stake(uint256 amount) external {
        require(amount > 0, "Cannot stake 0 tokens");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance to stake");

        stakedBalance[msg.sender] += amount;
        stakingTime[msg.sender] = block.timestamp;
        _transfer(msg.sender, address(this), amount); // Transfer the tokens to the staking contract
    }

    // Unstake tokens function
    function unstake(uint256 amount) external {
        require(stakedBalance[msg.sender] >= amount, "Not enough staked tokens");

        stakedBalance[msg.sender] -= amount;
        _transfer(address(this), msg.sender, amount); // Transfer the tokens back to the user
    }

    // Calculate rewards for staking
    function calculateRewards(address account) public view returns (uint256) {
        uint256 stakedDuration = block.timestamp - stakingTime[account];
        uint256 reward = (stakedBalance[account] 10 stakedDuration) / 60 seconds; // Example calculation
        return reward;
    }

    // Claim rewards function
    function claimRewards() external {
        uint256 rewards = calculateRewards(msg.sender);
        require(rewards > 0, "No rewards to claim");

        // Mint new reward tokens or transfer from contract to user
        mintTokensToAddress(msg.sender, rewards); // Example of minting rewards
    }
}

    }

    // Claim rewards function
    function claimRewards() external {
        uint256 rewards = calculateRewards(msg.sender);
        require(rewards > 0, "No rewards to claim");

        // Mint new reward tokens or transfer from contract to user
        mintTokensToAddress(msg.sender, rewards); // Example of minting rewards
    }
}
