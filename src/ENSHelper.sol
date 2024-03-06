// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract ENSHelper {
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