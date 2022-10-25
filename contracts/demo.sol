// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "@api3/airnode-protocol/contracts/rrp/requesters/RrpRequesterV0.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Demo is RrpRequesterV0, ERC20, Ownable {

    mapping(bytes32 => bool) public incomingFulfillments;
    mapping(bytes32 => bytes32) public fulfilledData;

    struct Endpoint {
        bytes32 endpointId;
        bytes4 functionSelector;
    }

    address public airnode;
    mapping(uint8 => Endpoint) public endpointsIds;
    address private sponsorWallet;

    event FulfilledRequest (bytes32 indexed requestId);
    event SetRequestParameters(
        address airnodeAddress,
        address sponsorAddress
    );
    event SetEndpoint(
        uint8 _index,
        bytes32 _newEndpointId,
        bytes4 _newEndpointSelector
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

    function setRequestParameters (
        address _airnode,
        address _sponsorWallet
    ) external onlyOwner {
        airnode = _airnode;
        sponsorWallet = _sponsorWallet;
        emit SetRequestParameters(
            airnode, 
            sponsorWallet
        );
    }

    /**
     * @dev Pending to add `Update Endpoint Logic`
     */
    function setEndpointLogic (
        bytes32 _endpointId,
        bytes4 _functionSelector
    ) external onlyOwner {
        Endpoint memory newEndpoint;

        newEndpoint.endpointId = _endpointId;
        newEndpoint.functionSelector = _functionSelector;

        endpointsIds.push(newEndpoint);

        emit SetEndpoint(
            endpointsId.length, 
            _endpointId, 
            _functionSelector);
    }

    function callTheAirnode (
        address airnode,
        uint8 endpointId,
        address sponsor,
        address sponsorWallet,
        bytes calldata parameters
        ) external onlyOwner {
            Endpoint memory functionData = endpointsIds[endpointId];

            bytes32 requestId = airnodeRrp.makeFullRequest (
                airnode,                            // airnode
                functionData.endpointId,            // endpointId
                sponsor,                            // sponsor's address
                sponsorWallet,                      // sponsorWallet
                address(this),                      // fulfillAddress
                functionData.functionSelector,      // fulfillFunctionId
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