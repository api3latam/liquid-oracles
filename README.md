# Liquid Oracles
Airnode and Beacon Implementations for Pyliquid and Liquid Tooling.

### Modules
- [Docker](./docker): Includes set of images with necessary infrastructure to spin off the Service including the API(s) and Liquid infrastructure
- [pyliquid](./pyliquid): All the configurations and support utilities to set up the actual Airnode.
    - [src](./pyliquid/src): Set of scripts to automated administrative tasks. Making use of @api3/airnode-adming library
    - [bin](./pyliquid/bin): Any shell script to be used either by typescript or docker.
    - [assets](./pyliquid/assets): Suite of outputs from src scripts. Like addresses, mnemonics, etc.
    - [dev](./pyliquid/dev): Set of configuration for 'dev' stage Airnodes. Follows the suggested structure from Airnode [documentation](https://docs.api3.org/airnode/v0.7/grp-providers/guides/build-an-airnode/#project-folder)
- [utils](./utils): Set of scripts that might be of use across the whole repository. Including stuff like reading or writting JSON files.
- [templates](./templates): Set of example files that are used in the repository, like the secrets for Airnode deployment.

### WIP
Current goal: We want to build a basic environment to test out simple tasks being called from an EVM solidty smart contract that are reflected in Liquid.
Current state: We are midway to finish up the API on our brother [repository](https://github.com/api3latam/PyLiquid2EVM). We'll keep updating the docker images and configuration files based on the progress, keep track of both on their respective repositories.

### Roadmap
*Features*:
    - DeFi Protocol for assets collaterization
    - Production ready Airnode for PyLiquid API
    - Terraform files for quick infrastructure provisioning
    - dApis for Prices Feeds from BitFinex

### Tech Stack Notes
- Package Manager: `pnpm`
- Docker OS: `Ubuntu`
