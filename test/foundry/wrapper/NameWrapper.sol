// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {ENSRegistry} from "contracts/registry/ENSRegistry.sol";
import {BaseRegistrarImplementation} from "contracts/ethregistrar/BaseRegistrarImplementation.sol";

contract NameWrapperTest is Test {

    receive() external payable {}

    ENSRegistry ens;
    BaseRegistrarImplementation baseRegistrar;

    function setUp() public {
	ens = new ENSRegistry();
    baseRegistrar = new BaseRegistrarImplementation(ens, 0x93cdeb708b7545dc668eb9280176169d1c33cfd8ed6f04690a0bcc88a93fc4ae);
    }

    function testFunction() public {}

}
