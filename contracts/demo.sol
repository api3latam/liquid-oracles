// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "@api3/airnode-protocol/contracts/rrp/requesters/RrpRequesterV0.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Demo is RrpRequesterV0, ERC20, Ownable {

    uint8 private tokenDecimals;
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
        address sender;
        address reciever;
        uint256 amount;
    }

    Endpoint[] public endpointsIds;

    mapping(bytes32 => bool) public incomingFulfillments;
    mapping(bytes32 => Operation) private requestToOperation;
    mapping(bytes32 => TokenEscrow) public transactionHistory;
    mapping(address => TokenEscrow[]) public currentTransactions;

    event SuccessfulRequest (
        bytes32 indexed requestId, 
        string apiResult
    );
    event SetRequestParameters (
        address airnodeAddress,
        address sponsorAdress,
        address sponsorWallet
    );
    event SetEndpoint (
        uint256 _index,
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
        uint8 _tokenDecimals
        )
    RrpRequesterV0 (
        _airnodeRrpAddress
    )
    ERC20 (
        _tokenName,
        _tokenSymbol
    )
        {
            tokenDecimals = _tokenDecimals;
        }

    function _setEndpointReference (
        bytes32 _endpointId
    ) external onlyOwner {
        Endpoint memory newEndpoint;

        newEndpoint.endpointId = _endpointId;
        if (_endpointId == 0x4195740ad5fa687ffeaecb3cc59ac7dc7c65bb04d2f3a894bc359c02d568f895) {
            newEndpoint.functionSelector = this.walletGet.selector;
        }

        if (_endpointId == 0x98a01d0deb01d27031447ffb57038a63d54535683955c319e461641027963aa7) {
            newEndpoint.functionSelector = this.walletLabelGet.selector;
        }

        if (_endpointId == 0xa4b094fe12fad8cce7bf0c77f28b212b26bd0d68f01b290e96ab91b542ff79a2) {
            newEndpoint.functionSelector = this.txSendPost.selector;
        }

        require(newEndpoint.functionSelector != "",
            "Not a valid endpointId");

        endpointsIds.push(newEndpoint);

        emit SetEndpoint(
            endpointsIds.length, 
            newEndpoint.endpointId, 
            newEndpoint.functionSelector);
    }

    function decimals () public view virtual override returns (uint8) {
        return tokenDecimals;
    }

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
            transactionHistory[requestId] = currentToken;
            currentTransactions[currentOperation.recieverAdress].push(currentToken);

            emit SuccessfulRequest(requestId, decodedData);
    }

    function fulfillTransfer (
        bytes32 requestId
    ) external {
        TokenEscrow memory rawToken = transactionHistory[requestId];
        require(rawToken.sender == msg.sender, 
            "You're not the owner of this Escrow");
        require(rawToken.evmConfirmation == false,
            "This Escrow has already been finished");

        uint256 mapIndex = rawToken.escrowIndex;
        TokenEscrow memory addressToken = currentTransactions[msg.sender][mapIndex];

        require (checkEscrowEquality(rawToken, addressToken),
            "The Escrow does not match with the given `requestId`");
        require (balanceOf(address(this)) >= addressToken.amount, 
            "There are not enough funds available");

        _transfer(address(this), msg.sender, addressToken.amount);

        transactionHistory[requestId].evmConfirmation = true;
        delete currentTransactions[msg.sender][mapIndex];

        emit FulfilledEscrow(msg.sender, requestId);
    }

    function checkEscrowEquality (
        TokenEscrow memory _history,
        TokenEscrow memory _sender
    ) private pure returns (bool) {
        bool result = true;

        if (_history.liquidMint != _sender.liquidMint
            || _history.evmConfirmation != _sender.evmConfirmation
            || _history.escrowIndex != _sender.escrowIndex
            || _history.sender != _sender.sender
            || _history.reciever != _sender.reciever
            || _history.amount != _sender.amount) {
                result = false;
        }

        return result;
    }
}