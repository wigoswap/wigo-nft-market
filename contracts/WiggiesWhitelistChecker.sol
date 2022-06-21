// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {ICollectionWhitelistChecker} from "./interfaces/ICollectionWhitelistChecker.sol";
import {IWiggies} from "./interfaces/IWiggies.sol";

contract WiggiesWhitelistChecker is Ownable, ICollectionWhitelistChecker {
    IWiggies public wiggies;

    mapping(uint8 => bool) public isWiggyIdRestricted;

    event NewRestriction(uint8[] wiggyIds);
    event RemoveRestriction(uint8[] wiggyIds);

    /**
     * @notice Constructor
     * @param _wiggiesAddress: Wiggies contract
     */
    constructor(address _wiggiesAddress) {
        wiggies = IWiggies(_wiggiesAddress);
    }

    /**
     * @notice Restrict tokens with specific wiggyIds to be sold
     * @param _wiggyIds: wiggyIds to restrict for trading on the market
     */
    function addRestrictionForWiggies(uint8[] calldata _wiggyIds) external onlyOwner {
        for (uint8 i = 0; i < _wiggyIds.length; i++) {
            require(!isWiggyIdRestricted[_wiggyIds[i]], "Operations: Already restricted");
            isWiggyIdRestricted[_wiggyIds[i]] = true;
        }

        emit NewRestriction(_wiggyIds);
    }

    /**
     * @notice Remove restrictions tokens with specific wiggyIds to be sold
     * @param _wiggyIds: wiggyIds to restrict for trading on the market
     */
    function removeRestrictionForWiggies(uint8[] calldata _wiggyIds) external onlyOwner {
        for (uint8 i = 0; i < _wiggyIds.length; i++) {
            require(isWiggyIdRestricted[_wiggyIds[i]], "Operations: Not restricted");
            isWiggyIdRestricted[_wiggyIds[i]] = false;
        }

        emit RemoveRestriction(_wiggyIds);
    }

    /**
     * @notice Check whether token can be listed
     * @param _tokenId: tokenId of the NFT to list
     */
    function canList(uint256 _tokenId) external view override returns (bool) {
        uint8 wiggyId = wiggies.getWiggyId(_tokenId);

        return !isWiggyIdRestricted[wiggyId];
    }
}
