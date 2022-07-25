# Documentation & Resources

This is a set of files and links that will help you gain in depth understanding about our implementation and work.

## Components

### PyLiquid Oracles Architecture
You can check this simple [diagram](./oraclesArch.png) to get an overview.

- [API Pyliquid](https://github.com/api3latam/PyLiquid2EVM): It's the backend service that enables the interaction with Liquid network. The API is build using FastAPI and our own implementation to make use of the RPC connection with the Elements CLI trough another library. For more details visit the repository.
- dApis Price Feed: Provides information to the smart contracts from assets prices of Liquid network. For more information about the BitFinex API refer to it's [documentation](https://docs.bitfinex.com/docs/rest-public)
- DeFi Protocol: TBD
