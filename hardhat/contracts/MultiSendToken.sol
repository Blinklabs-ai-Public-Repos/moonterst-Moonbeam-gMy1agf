// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol";
import "@openzeppelin/contracts/utils/Multicall.sol";

/**
 * @title MultiSendToken
 * @dev ERC20 token with multisend, pausable, and multicall capabilities
 */
contract MultiSendToken is ERC20Pausable, Multicall {
    uint256 private immutable _maxSupply;

    /**
     * @dev Constructor to initialize the token
     * @param name_ The name of the token
     * @param symbol_ The symbol of the token
     * @param maxSupply_ The maximum supply of the token
     */
    constructor(string memory name_, string memory symbol_, uint256 maxSupply_) ERC20(name_, symbol_) {
        _maxSupply = maxSupply_;
    }

    /**
     * @dev Returns the maximum supply of the token
     * @return The maximum supply
     */
    function maxSupply() public view returns (uint256) {
        return _maxSupply;
    }

    /**
     * @dev Mints new tokens
     * @param to The address to mint tokens to
     * @param amount The amount of tokens to mint
     */
    function mint(address to, uint256 amount) public {
        require(totalSupply() + amount <= _maxSupply, "Exceeds max supply");
        _mint(to, amount);
    }

    /**
     * @dev Sends tokens to multiple recipients in a single transaction
     * @param recipients An array of recipient addresses
     * @param amounts An array of amounts to send to each recipient
     */
    function multiSend(address[] memory recipients, uint256[] memory amounts) public {
        require(recipients.length == amounts.length, "Arrays must have the same length");
        
        for (uint256 i = 0; i < recipients.length; i++) {
            transfer(recipients[i], amounts[i]);
        }
    }

    /**
     * @dev Pauses all token transfers
     */
    function pause() public {
        _pause();
    }

    /**
     * @dev Unpauses all token transfers
     */
    function unpause() public {
        _unpause();
    }
}