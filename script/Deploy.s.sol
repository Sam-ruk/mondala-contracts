// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
import "forge-std/Script.sol";
import "../src/Mondala.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        new Mondala();
        vm.stopBroadcast();
    }
}