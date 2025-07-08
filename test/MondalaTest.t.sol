// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import "forge-std/Test.sol";
import "../src/Mondala.sol";

contract MondalaTest is Test {
    Mondala public nft;
    address public user = address(0x123);
    string public sampleSVG = '<svg xmlns="http://www.w3.org/2000/svg" width="100" height="100"><circle cx="50" cy="50" r="40" fill="blue"/></svg>';

    function setUp() public {
        nft = new Mondala();
        vm.deal(user, 1 ether); // Fund user
    }

    function testMintSuccess() public {
        vm.prank(user);
        nft.safeMint{value: 0.01 ether}(user, sampleSVG);

        assertEq(nft.ownerOf(0), user, "User should own token 0");
        assertTrue(bytes(nft.tokenURI(0)).length > 0, "Token URI should not be empty");
    }

    function testTokenURIFormat() public {
        vm.prank(user);
        nft.safeMint{value: 0.01 ether}(user, sampleSVG);

        string memory uri = nft.tokenURI(0);
        assertTrue(bytes(uri).length > 0, "Token URI should not be empty");
        assertTrue(stringContains(uri, "data:application/json;base64,"), "Token URI should be base64-encoded JSON");
    }

    function testInsufficientFunds() public {
        vm.prank(user);
        vm.expectRevert("Insufficient funds");
        nft.safeMint{value: 0.005 ether}(user, sampleSVG);
    }

    function testNonExistentToken() public {
        vm.expectRevert("Invalid token ID");
        nft.tokenURI(0);
    }

    function stringContains(string memory str, string memory substr) internal pure returns (bool) {
        bytes memory strBytes = bytes(str);
        bytes memory substrBytes = bytes(substr);
        if (strBytes.length < substrBytes.length) return false;

        for (uint i = 0; i <= strBytes.length - substrBytes.length; i++) {
            bool found = true;
            for (uint j = 0; j < substrBytes.length; j++) {
                if (strBytes[i + j] != substrBytes[j]) {
                    found = false;
                    break;
                }
            }
            if (found) return true;
        }
        return false;
    }
}