// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Airdrop, IERC20} from "../src/Airdrop.sol";
import {AirdropToken} from "../src/AirdropToken.sol";
import {Script, console} from "forge-std/Script.sol";

contract DeployAirdrop is Script {
    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4;
    // 4 users, 25 Bagel tokens each
    uint256 public AMOUNT_TO_TRANSFER = 4 * (25 * 1e18);

    // Deploy the airdrop contract and bagel token contract
    function deployMerkleAirdrop() public returns (Airdrop, AirdropToken) {
        vm.startBroadcast();
        AirdropToken airdropToken = new AirdropToken();
        Airdrop airdrop = new Airdrop(ROOT, IERC20(airdropToken));
        // Send Bagel tokens -> Merkle Air Drop contract
       airdropToken.mint(airdropToken.owner(), AMOUNT_TO_TRANSFER);
        IERC20(airdropToken).transfer(address(airdrop), AMOUNT_TO_TRANSFER);
        vm.stopBroadcast();
        return (airdrop, airdropToken);
    }

    function run() external returns (Airdrop, AirdropToken) {
        return deployMerkleAirdrop();
    }
}