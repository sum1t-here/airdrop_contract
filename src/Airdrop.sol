// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {IERC20, SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract Airdrop {
    using SafeERC20 for IERC20; // Prevent sending tokens to recipients who can’t receive

    // some lists of addresses
    // allow someone in the list to claim airdrop

    error Airdrop__InvalidProof();
    error Airdrop__AlreadyClaimed();

    address[] claimers;
    bytes32 private immutable i_merkleRoot;
    IERC20 private immutable i_airdropToken;
    mapping(address claimer => bool claimed) private s_hasClaimed;

    event Claimed(address indexed account, uint256 amount);

    constructor(bytes32 merkleRoot, IERC20 airdropToken) {
        i_merkleRoot = merkleRoot;
        i_airdropToken = airdropToken;
    }

    /**
     * @dev Claim the airdrop
     * @param account The address of the account to claim the airdrop
     * @param amount The amount of the airdrop
     * @param merkleProof The merkle proof of the account
     */
    function claim(address account, uint256 amount, bytes32[] calldata merkleProof) external {
        // check if the account has already claimed
        if (s_hasClaimed[account]) {
            revert Airdrop__AlreadyClaimed();
        }

        // calculate using the account, amount, the hash -> leaf node
        // prevent second preimage attack -> hash(hash(account, amount))
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, amount))));

        // check if the account is in the merkle root
        if (!MerkleProof.verify(merkleProof, i_merkleRoot, leaf)) {
            revert Airdrop__InvalidProof();
        }

        // mint the tokens
        s_hasClaimed[account] = true;
        emit Claimed(account, amount);
        i_airdropToken.transfer(account, amount);
    }

    function getMerkleRoot() external view returns (bytes32) {
        return i_merkleRoot;
    }

    function getAirdropToken() external view returns (IERC20) {
        return i_airdropToken;
    }
}
