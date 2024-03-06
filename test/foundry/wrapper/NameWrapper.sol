// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {ENSRegistry} from "contracts/registry/ENSRegistry.sol";

contract NameWrapperTest is Test {

    receive() external payable {}

    ENSRegistry registry;

    function setUp() public {
	registry = new ENSRegistry();
    }
}
