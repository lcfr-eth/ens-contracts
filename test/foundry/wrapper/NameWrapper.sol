// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {ENSRegistry} from "contracts/registry/ENSRegistry.sol";
import {BaseRegistrarImplementation} from "contracts/ethregistrar/BaseRegistrarImplementation.sol";
import {StaticMetadataService} from "contracts/wrapper/StaticMetadataService.sol";
import {ReverseRegistrar} from "contracts/reverseRegistrar/ReverseRegistrar.sol";
import {PublicResolver} from "contracts/resolvers/PublicResolver.sol";
import {NameWrapper} from "contracts/wrapper/NameWrapper.sol";

import {INameWrapper} from "contracts/wrapper/INameWrapper.sol";
import {IMetadataService} from "contracts/wrapper/IMetadataService.sol";

contract NameWrapperTest is Test {

    BaseRegistrarImplementation baseRegistrar;
    StaticMetadataService metadataService;
    ReverseRegistrar reverseRegistrar;
    PublicResolver publicResolver;
    NameWrapper nameWrapper;
    ENSRegistry ens;

    function setUp() public {
        bytes32 ROOT_NODE;

	    ens = new ENSRegistry();
        baseRegistrar = new BaseRegistrarImplementation(ens, namehash('eth'));
        metadataService = new StaticMetadataService('https://ens.domains');
        reverseRegistrar = new ReverseRegistrar(ens);

        // lcfr: add this contract as a controller of the baseRegistrar to register names without paying etc
        baseRegistrar.addController(address(this));

        // lcfr: check ENS deployment for who owns the ROOT_NODE on mainnet?
        ens.setSubnodeOwner(ROOT_NODE, labelhash('reverse'), address(this));
        ens.setSubnodeOwner(namehash('reverse'), labelhash('addr'), address(reverseRegistrar));

        // lcfr: inconsistent uses of address, interfaces and contracts. annoying.
        nameWrapper = new NameWrapper(ens, baseRegistrar, IMetadataService(address(metadataService)));

        publicResolver = new PublicResolver(ens, INameWrapper(address(nameWrapper)), address(0), address(reverseRegistrar));
        reverseRegistrar.setDefaultResolver(address(publicResolver));

        // setup ETH TLD owned by baseRegistrar
        ens.setSubnodeOwner(ROOT_NODE, labelhash('eth'), address(baseRegistrar));

        // setup XYZ TLD owned by this contract
        ens.setSubnodeOwner(ROOT_NODE, labelhash('xyz'), address(this));
        // check if .eth is setup correctly
        require(ens.owner(namehash('eth')) == address(baseRegistrar), ".eth setup incorrectly");

        // warp to a current-ish timestamp so the block.timestamp checks dont revert in registrations etc
        vm.warp(1709749725);
    }

    function testRegisterAndWrap() public {
        baseRegistrar.register(uint256(labelhash('test1')), address(this), 86400);
        baseRegistrar.setApprovalForAll(address(nameWrapper), true);
        nameWrapper.wrapETH2LD('test1', address(666), 0, address(0));
    }


    // Helpers for namehash and labelhash
    function namehash(string memory _name) public pure returns (bytes32 namehash) {
        namehash = keccak256(
            abi.encodePacked(bytes32(0), keccak256(abi.encodePacked(_name)))
        );
    }

    function namehashEth(string memory _name) public pure returns (bytes32 namehash) {
        namehash = keccak256(
            abi.encodePacked(bytes32(0), keccak256(abi.encodePacked('eth')))
        );
        namehash = keccak256(
            abi.encodePacked(namehash, keccak256(abi.encodePacked(_name)))
        );
    }

    function labelhash(string memory _name) public pure returns (bytes32 labelhash) {
        labelhash = keccak256(abi.encodePacked(_name));
    }

}
