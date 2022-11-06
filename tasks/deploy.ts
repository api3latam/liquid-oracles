import { providers, Wallet } from "ethers";
import { AirnodeRrpAddresses } from '@api3/airnode-protocol';
import { task } from "hardhat/config";

import { getEnvVars, writeJsonFile } from "../utils"

task("deploy", "Deploy Compile Contracts for Repository")
    .setAction(async (_, hre) => {
            const file = `addresses/demo${hre.network.name}.json`;
            const provider = new providers.JsonRpcProvider (
                getEnvVars (
                    `${(hre.network.name).toUpperCase()}_RPC`)
                    [0]
                );
            const wallet = new Wallet(getEnvVars("PRIVATE_KEY")[0], provider);

            const factory = await hre.ethers.getContractFactory("Demo", wallet);

            try {
                const rrpAddress = AirnodeRrpAddresses[hre.network.config.chainId as number]; 
                const contract = await factory.deploy(
                    rrpAddress,
                    "API3 wLIQUID",
                    "APILQ",
                    8
                );
                console.log (`Contract deployed to: ${contract.address}`);

                console.log('Saving addresses to file...\n')
                writeJsonFile({
                    path: `/${file}`,
                    data: { demo : contract.address }
                });
            } catch (e) {
                console.error(e);
            }
        }
    );