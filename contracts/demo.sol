// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "@api3/airnode-protocol/contracts/rrp/requesters/RrpRequesterV0.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Demo is RrpRequesterV0, ERC20, Ownable {

    address public airnode;
    address private sponsorAddress;
    address private sponsorWallet;

    struct Endpoint {
        bytes32 endpointId;
        bytes4 functionSelector;
    }

    struct Operation {
        address senderAddress,
        address recieverAdress,
        bytes payload
    }

    struct TokenEscrow {
        bool liquidMint;
        bool evmConfirmation;
        bytes32 requestId;
        address sender;
        address reciever;
        uint256 amount;
    }

    mapping(uint8 => Endpoint) public endpointsIds;
    mapping(bytes32 => bool) public incomingFulfillments;
    mapping(bytes32 => Operation) private requestToOperation;
    mapping(uint256 => TokenEscrow) public transactionHistory;
    mapping(address => TokenEscrow[]) public currentTransactions;

    event SuccessfulGet (
        bytes32 indexed requestId, 
        bytes apiResult
    );
    event SetRequestParameters (
        address airnodeAddress,
        address sponsorAdress,
        address sponsorWallet
    );
    event SetEndpoint (
        uint8 _index,
        bytes32 _newEndpointId,
        bytes4 _newEndpointSelector
    );
    event WalletOperation (
        address indexed senderAddress,
        bytes payload
    );
    event TxOperation (
        address indexed senderAddress,
        address indexed recieverAddress,
        bytes payload
    )

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
        address _sponsorAddress,
        address _sponsorWallet
    ) external onlyOwner {
        airnode = _airnode;
        sponsorAddress = _sponsorAddress;
        sponsorWallet = _sponsorWallet;
        emit SetRequestParameters(
            _airnode,
            _sponsorAddress,
            _sponsorWallet
        );
    }

    function _setEndpointReference (
        bytes32 _endpointId,
        bytes4 _functionSelector
    ) private {
        Endpoint memory newEndpoint;

        newEndpoint.endpointId = _endpointId;
        newEndpoint.functionSelector = _functionSelector;

        endpointsIds.push(newEndpoint);

        emit SetEndpoint(
            endpointsId.length, 
            _endpointId, 
            _functionSelector);
    }

    function operationsWallet (
        uint8 endpointIndex,
        address _senderAddress,
        bytes calldata parameters
        ) external onlyOwner {
            Endpoint memory functionData = endpointsIds[endpointIndex];

            bytes32 requestId = airnodeRrp.makeFullRequest (
                airnode,                            // airnode
                functionData.endpointId,            // endpointId
                sponsorAddress,                     // sponsor's address
                sponsorWallet,                      // sponsorWallet
                address(this),                      // fulfillAddress
                functionData.functionSelector,      // fulfillFunctionId
                parameters                          // API parameters
            );

            incomingFulfillments[requestId] = true;
            requestToOperation[requestId] = Operation (
                _senderAddress, 
                address(0),
                parameters);
            emit WalletOperation(_senderAddress, parameters);
    }

    function operationsTx (
        uint8 endpointIndex,
        address senderAddress,
        address recieverAddress,
        bytes calldata parameters
    ) external onlyOwner {
        Endpoint memory functionData = endpointsIds[endpointIndex];

        bytes32 requestId = airnodeRrp.makeFullRequest (
            airnode,                            // airnode
            functionData.endpointId,            // endpointId
            sponsorAddress,                     // sponsor's address
            sponsorWallet,                      // sponsorWallet
            address(this),                      // fulfillAddress
            functionData.functionSelector,      // fulfillFunctionId
            parameters                          // API parameters
        );

        incomingFulfillments[requestId] = true;
        requestToOperation[requestId] = Operation (
            senderAddress, 
            address(0),
            parameters);
        emit TxOperation()
    }

    function walletGet (
        bytes32 requestId,
        bytes calldata data
    ) external onlyAirnodeRrp {
        require(incomingFulfillments[requestId], "No such request made");

        string memory decodedData = abi.decode(data, (string));
        delete incomingFulfillments[requestId];

        emit SuccessfulGet(requestId, decodedData);

    }

    function walletLabelGet (
        bytes32 requestId,
        bytes calldata data
    ) external onlyAirnodeRrp {
        require(incomingFulfillments[requestId], "No such request made");

        string memory decodedData = abi.decode(data, (string));
        delete incomingFulfillments[requestId];

        emit SuccessfulGet(requestId, decodedData);
    }

    function txSend (
        bytes32 requestId,
        bytes calldata data 
        ) external onlyAirnodeRrp {

            require(incomingFulfillments[requestId], "No such request made");
            
            string memory decodedData = abi.decode(data, (string));
            fulfilledData[requestId] = decodedData;
            TokenEscrow memory currentToken = TokenEscrow(

            ); 

            delete incomingFulfillments[requestId];
            emit FulfilledRequest(requestId);
    }
}