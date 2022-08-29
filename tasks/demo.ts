import { task } from "hardhat/config";
import { providers, Wallet } from "ethers";
import { encode } from "@api3/airnode-abi";
import "@nomiclabs/hardhat-ethers";

import { Demo } from "../types/"
import { getEnvVars } from "../utils";

task("demo", "Simple airnode call to Liquid")
    .setAction(async ( _, hre ) => {
        const airnodeAddress = "0x20f9A231505789ec630E2d314ed2C5aCFd6756C3"
        const provider = new providers.AlchemyProvider("rinkeby", getEnvVars('ALCHEMY_KEY')[0]);
        const wallet = new Wallet(getEnvVars("PRIVATE_KEY")[0], provider);
        const parameters = encode([]);

        const contract = await hre.ethers.getContractAt(
            "Demo", 
            "0xE5a6b406AAa0dfd0f72665Ff073163D495ecCaae",
            wallet) as Demo;

        const tx = await contract.callTheAirnode(
            airnodeAddress,
            "0x6dd8c26c9668c8ff1491514c0dda4f1f856b7365d1a2a1dc7443d7a6ee3ec603",
            "0x769AD74466FdA34Dff42C4fd9299DE062e7360d5",
            "0x80d0bcfb103bD2B03cba953D394c6cb308F13335",
            parameters
        );

        const receipt = await tx.wait();
        console.log(receipt.events?.filter((x) => {return x.event == "FulfilledRequest"}));

        // const dataOutput = await contract.fulfilledData(requestedId);
        // console.log(`The output from the request is: ${decode(`${dataOutput}`)}`);
    }
);
