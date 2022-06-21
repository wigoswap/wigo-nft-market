// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IWiggies {
    function getWiggyId(uint256 _tokenId) external view returns (uint8);
}
