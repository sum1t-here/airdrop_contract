// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Airdrop} from "../src/Airdrop.sol";
import {AirdropToken} from "../src/AirdropToken.sol";

contract AirdropTest is Test {
    Airdrop public airdrop;
    AirdropToken public token;

    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4; // from scrupt/target/output.json
    uint256 public AMOUNT_TO_CLAIM = 25 * 1e18;
    uint256 public AMOUNT_TO_SEND = AMOUNT_TO_CLAIM * 4;
    bytes32 proofOne = 0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a;
    bytes32 proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] public PROOF = [proofOne, proofTwo];
    address public gasPayer;
    address user;
    uint256 userPrivKey;

    function setUp() public {
        token = new AirdropToken();
        airdrop = new Airdrop(ROOT, token);
        token.mint(token.owner(), AMOUNT_TO_SEND);
        token.transfer(address(airdrop), AMOUNT_TO_SEND);
        (user, userPrivKey) = makeAddrAndKey("user");
        gasPayer = makeAddr("gasPAyer");
    }

    // function testUserCanClaim() public {
    //     // console.log("user address :", user); // make sure the output matches with script/target/input.json -> whiteList[0]

    //     uint256 userStartingBal = token.balanceOf(user);
    //     console.log("Starting Balance :", userStartingBal);
    //     vm.prank(user);
    //     airdrop.claim(user, AMOUNT_TO_CLAIM, PROOF);

    //     uint256 userEndingBal = token.balanceOf(user);
    //     console.log("Ending Balance :", userEndingBal);

    //     assertEq(userEndingBal - userStartingBal, AMOUNT_TO_CLAIM);
    // }

    function testUserCanClaim() public {
        uint256 userStartingBal = token.balanceOf(user);
        bytes32 digest = airdrop.getMessage(user, AMOUNT_TO_CLAIM);

        // sign a message
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(userPrivKey, digest);

        // gaspayer calls claim using the sign message
        vm.prank(gasPayer);
        airdrop.claim(user, AMOUNT_TO_CLAIM, PROOF, v, r, s);

        uint256 userEndingBal = token.balanceOf(user);
        console.log("Ending Balance :", userEndingBal);

        assertEq(userEndingBal - userStartingBal, AMOUNT_TO_CLAIM);
    }
}
