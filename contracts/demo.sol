// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "@api3/airnode-protocol/contracts/rrp/requesters/RrpRequesterV0.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Demo is RrpRequesterV0, ERC20, Ownable {

    mapping(bytes32 => bool) public incomingFulfillments;
    mapping(bytes32 => bytes32) public fulfilledData;

    address public airnode;
    mapping(uint8 => bytes32) public endpointIdsUints256;
    address private sponsorWallet;

    event FulfilledRequest (bytes32 requestId);
    event SetRequestParameters(
        address airnodeAddress,
        address sponsorAddress
    );

    constructor (
        address _airnodeRrpAddress,
        string memory _tokenName,
        string memory _tokenSymbol,
        uint8 _decimals
        )
    RrpRequesterV0 (
        _airnodeRrpAddress
    )
    ERC20 (
        _tokenName,
        _tokenSymbol,
        _decimals
    )
        {}

    function setRequestParameters(
        address _airnode,
        bytes32 _endpointIdUint256,
        address _sponsorWallet
    ) external onlyOwner {
        airnode = _airnode;
        sponsorWallet = _sponsorWallet;
        emit SetRequestParameters(
            airnode, 
            sponsorWallet
        );
    }

    function callTheAirnode (
        address airnode,
        uint8 endpointId,
        address sponsor,
        address sponsorWallet,
        bytes calldata parameters
        ) external {

            bytes32 requestId = airnodeRrp.makeFullRequest (
                airnode,                            // airnode
                endpointIdsUints256[endpointId],    // endpointId
                sponsor,                            // sponsor's address
                sponsorWallet,                      // sponsorWallet
                address(this),                      // fulfillAddress
                this.airnodeCallback.selector,      // fulfillFunctionId
                parameters                          // API parameters
            );

            incomingFulfillments[requestId] = true;
    }

    function airnodeCallback (
        bytes32 requestId,
        bytes calldata data 
        ) external onlyAirnodeRrp {

            require(incomingFulfillments[requestId], "No such request made");
            delete incomingFulfillments[requestId];
            int256 decodedData = abi.decode(data, (int256));
            fulfilledData[requestId] = decodedData;
            emit FulfilledRequest(requestId);
    }
}