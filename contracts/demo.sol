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
        address senderAddress;
        address recieverAdress;
        uint256 amount;
        bytes payload;
    }

    struct TokenEscrow {
        bool liquidMint;
        bool evmConfirmation;
        uint256 escrowIndex;
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

    event SuccessfulRequest (
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
    );
    event FulfilledEscrow (
        address indexed recieverAddress,
        bytes32 indexed requestId
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
                0,
                parameters);
            emit WalletOperation(_senderAddress, parameters);
    }

    function operationsTx (
        uint8 endpointIndex,
        address _senderAddress,
        address _recieverAddress,
        uint256 _amount,
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
            _recieverAddress,
            _amount,
            parameters);
        emit TxOperation(_senderAddress, _recieverAddress, parameters);
    }

    function walletGet (
        bytes32 requestId,
        bytes calldata data
    ) external onlyAirnodeRrp {
        require(incomingFulfillments[requestId], "No such request made");

        string memory decodedData = abi.decode(data, (string));
        delete incomingFulfillments[requestId];

        emit SuccessfulRequest(requestId, decodedData);

    }

    function walletLabelGet (
        bytes32 requestId,
        bytes calldata data
    ) external onlyAirnodeRrp {
        require(incomingFulfillments[requestId], "No such request made");

        string memory decodedData = abi.decode(data, (string));
        delete incomingFulfillments[requestId];

        emit SuccessfulRequest(requestId, decodedData);
    }

    function txSendPost (
        bytes32 requestId,
        bytes calldata data 
        ) external onlyAirnodeRrp {

            require(incomingFulfillments[requestId], "No such request made");
            
            string memory decodedData = abi.decode(data, (string));
            fulfilledData[requestId] = decodedData;

            Operation memory currentOperation = requestToOperation[requestId];
            TokenEscrow memory currentToken = TokenEscrow (
                true,
                false,
                currentTransactions[currentOperation.recieverAdress].length,
                currentOperation.senderAddress,
                currentOperation.recieverAdress,
                currentOperation.amount
            );

            _mint(address(this), currentOperation.amount);

            delete incomingFulfillments[requestId];
            transactionHistory[transactionHistory.length] = currentToken;
            currentTransactions[currentOperation.recieverAddress] = currentToken;

            emit SuccessfulRequest(requestId);
    }

    function fulfillTransfer (
        bytes32 requestId,
        address poolAddress
    ) external {
        TokenEscrow memory rawToken = transactionHistory[requestId];
        require(rawToken.sender == msg.sender, 
            "You're not the owner of this Escrow");
        require(rawToken.evmConfirmation == false,
            "This Escrow has already been finished");

        uint256 mapIndex = recieverToken.escrowIndex;
        TokenEscrow memory addressToken = currentTransactions[msg.sender][mapIndex];

        require (rawToken == addressToken, 
            "The Escrow does not match with the given `requestId`");
        require (balanceOf(address(this)) >= addressToken.amount, 
            "There are not enough funds available");

        _transfer(address(this), msg.sender, amount);

        transactionHistory[request].evmConfirmation = true;
        delete currentTransactions[msg.sender][mapIndex];

        emit FulfilledEscrow(msg.sender, requestId);
    }
}