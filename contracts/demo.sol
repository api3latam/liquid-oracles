// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "@api3/airnode-protocol/contracts/rrp/requesters/RrpRequesterV0.sol";

contract Demo is RrpRequesterV0 {

    mapping(bytes32 => bool) public incomingFulfillments;
    mapping(bytes32 => int256) public fulfilledData;

    constructor (address airnodeRrpAddress) public RrpRequesterV0(airnodeRrpAddress) {}

    function callTheAirnode(
        address airnode,
        bytes32 endpointId,
        address sponsor,
        address sponsorWallet,
        bytes calldata parameters // Inbound API parameters which may already be ABI encoded
        ) external {

            bytes32 requestId = airnodeRrp.makeFullRequest( // Make the Airnode request
                airnode,                        // airnode
                endpointId,                     // endpointId
                sponsor,                        // sponsor's address
                sponsorWallet,                  // sponsorWallet
                address(this),                  // fulfillAddress
                this.airnodeCallback.selector,  // fulfillFunctionId
                parameters                      // API parameters
            );

            incomingFulfillments[requestId] = true;
    }

  function airnodeCallback (   // The AirnodeRrpV0.sol protocol contract will callback here.
        bytes32 requestId,
        bytes calldata data 
        ) external onlyAirnodeRrp {

            require(incomingFulfillments[requestId], "No such request made");
            delete incomingFulfillments[requestId];
            int256 decodedData = abi.decode(data, (int256));
            fulfilledData[requestId] = decodedData;
    }
}