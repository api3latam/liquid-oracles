import { task } from "hardhat/config";
import { providers, Wallet } from "ethers";
import "@nomiclabs/hardhat-ethers";
import {  } from "../types/"
import { getEnvVars } from "../utils";

task("demo", "Simple airnode call to Liquid")
    .setAction(async(_, hre) => {
        const provider = new providers.AlchemyProvider("rinkeby", getEnvVars('ALCHEMY_KEY')[0]);
        const wallet = new Wallet(getEnvVars("PRIVATE_KEY")[0], provider);

        const contract = hre.ethers.getContractAt("Demo", "0x20f9A231505789ec630E2d314ed2C5aCFd6756C3", wallet);
        contract.
    })