// SPDX-License-Identifier: MIT

pragma solidity 0.7.6;
pragma abicoder v2;

import "./Types.sol";
import "./IAORegistry.sol";
import "./IAOVerifier.sol";

/// @title The global AO registry.
contract AORegistry is IAORegistry {
    string public constant VERSION = "0.3";

    // The global mapping between AO records and their IDs.
    mapping(bytes32 => AORecord) private _registry;

    // The global counter for the total number of attestations.
    uint256 private _aoCount;

    /// @dev Submits and reserve a new AO.
    ///
    /// @param schema The AO data schema.
    /// @param verifier An optional AO schema verifier.
    //
    /// @return The UUID of the new AO.
    function register(bytes calldata schema, IAOVerifier verifier) external override returns (bytes32) {
        uint256 index = ++_aoCount;

        AORecord memory ao = AORecord({uuid: EMPTY_UUID, index: index, schema: schema, verifier: verifier});

        bytes32 uuid = _getUUID(ao);
        require(_registry[uuid].uuid == EMPTY_UUID, "ERR_ALREADY_EXISTS");

        ao.uuid = uuid;
        _registry[uuid] = ao;

        emit Registered(uuid, index, schema, verifier, msg.sender);

        return uuid;
    }

    /// @dev Returns an existing AO by UUID.
    ///
    /// @param uuid The UUID of the AO to retrieve.
    ///
    /// @return The AO data members.
    function getAO(bytes32 uuid) external view override returns (AORecord memory) {
        return _registry[uuid];
    }

    /// @dev Returns the global counter for the total number of attestations.
    ///
    /// @return The global counter for the total number of attestations.
    function getAOCount() external view override returns (uint256) {
        return _aoCount;
    }

    /// @dev Calculates a UUID for a given AO.
    ///
    /// @param ao The input AO.
    ///
    /// @return AO UUID.
    function _getUUID(AORecord memory ao) private pure returns (bytes32) {
        return keccak256(abi.encodePacked(ao.schema, ao.verifier));
    }
}
