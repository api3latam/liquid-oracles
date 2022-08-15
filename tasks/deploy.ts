import { providers, Wallet } from "ethers";
import { task } from "hardhat/config";

import { getEnvVars } from "../utils"

task("deploy", "Deploy Compile Contracts for Repository")
    .setAction(async (_, hre) => {
            const provider = new providers.AlchemyProvider("rinkeby", getEnvVars('ALCHEMY_KEY')[0])
            const wallet = new Wallet(getEnvVars("PRIVATE_KEY")[0], provider);
            const factory = await hre.ethers.getContractFactory("Demo", wallet);

            try {
                const contract = await factory.deploy("0xa0AD79D995DdeeB18a14eAef56A549A04e3Aa1Bd");
                console.log (`Contract deployed to: ${contract.address}`);
            } catch (e) {
                console.error(e);
            }
        }
    )