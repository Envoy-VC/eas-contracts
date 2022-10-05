// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import { SchemaResolver } from "../../SchemaResolver.sol";

/**
 * @title A sample schema resolver that checks whether the attestation is to a specific recipient.
 */
contract TestRecipientResolver is SchemaResolver {
    address private immutable _targetRecipient;

    constructor(address targetRecipient) {
        _targetRecipient = targetRecipient;
    }

    function resolve(
        address recipient,
        bytes calldata, /* schema */
        bytes calldata, /* data */
        uint32, /* expirationTime */
        address /* msgSender */
    ) external payable virtual override returns (bool) {
        return recipient == _targetRecipient;
    }
}