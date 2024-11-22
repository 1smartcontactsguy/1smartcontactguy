// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardToken is ERC20, Ownable {

    uint256 public initialSupply = 1_000_000 * 10**18; // 1 million reward tokens (18 decimals)

    // Constructor to initialize the reward token with a name and symbol
    constructor() ERC20("RewardToken", "REWARD") {
        // Mint the initial supply to the owner (could be a treasury or staking contract)
        _mint(msg.sender, initialSupply);
    }

    modifier onlyOwner() {
        require(msg.sender == owner(), "Not owner");
        _;
    }

    // Function to mint more reward tokens if needed
    function mintRewardTokens(address recipient, uint256 amount) external onlyOwner {
        _mint(recipient, amount);
    }
}

