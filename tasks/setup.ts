import { task } from "hardhat/config";
import { deriveSponsorWalletAddress } from "@api3/airnode-admin";
import { getEnvVars,
    loadJsonFile } from "../utils";
import type { Demo } from "../types/contracts/demo.sol/Demo";

task("deploy", "Deploy Compile Contracts for Repository")
    .setAction(async (_, hre) => {
            const demoAirnode = loadJsonFile('pyliquid/airnodes/demo/v090/output/receipt.json')
                ['airnodeWallet'];
            const airnodeEndpoints = loadJsonFile('pyliquid/assets/endpointIds.json');
            const demo = loadJsonFile(`addresses/demo${hre.network.name}.json`)['demo'];

            const provider = new hre.ethers.providers.JsonRpcProvider (
                getEnvVars (
                    `${(hre.network.name).toUpperCase()}_RPC`)
                    [0]
                );
            const wallet = new hre.ethers.Wallet(getEnvVars("PRIVATE_KEY")[0], provider);
            const contract = await hre.ethers.getContractAt("Demo", demo, wallet) as Demo;
            
            const sponsor = await deriveSponsorWalletAddress(
                demoAirnode['airnodeXpub'],
                demoAirnode['airnodeAddress'],
                wallet.address
            );

            try {
                console.log('Setting up Demo Contract\n');
                await contract.setRequestParameters(
                    demoAirnode['airnodeAddress'],
                    wallet.address,
                    sponsor
                );

                Object.keys(airnodeEndpoints).forEach(async (index: string) => {
                    if (airnodeEndpoints[index].name === "opsWallet") {
                        await contract._setEndpointReference (
                            airnodeEndpoints[index].address,
                            "walletGet(bytes32,bytes)"
                        );
                    }
                    if (airnodeEndpoints[index].name === "opsWalletLabel") {
                        await contract._setEndpointReference (
                            airnodeEndpoints[index].address,
                            "walletLabelGet(bytes32,bytes)"
                        );
                    }
                    if (airnodeEndpoints[index].name === "opsTxSend") {
                        await contract._setEndpointReference (
                            airnodeEndpoints[index].address,
                            "txSendPost(bytes32,bytes)"
                        )
                    }
                })
            } catch (e) {
                console.error(e);
            }
});