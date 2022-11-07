import { task } from "hardhat/config";
import { deriveSponsorWalletAddress } from "@api3/airnode-admin";
import { getEnvVars,
    loadJsonFile } from "../utils";
import type { Demo } from "../types/contracts/demo.sol/Demo";

task("setup", "Setup any parameter or functionalities for deployed contracts")
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
                console.log("Setup Request Parameters\n");
                await contract.setRequestParameters(
                    demoAirnode['airnodeAddress'],
                    wallet.address,
                    sponsor
                );
                
                console.log("Setting-up callback endpoints\n");
                Object.keys(airnodeEndpoints).forEach(async (index: string) => {
                    console.log(`Endpoint: ${airnodeEndpoints[index].name}\
                        Address: ${airnodeEndpoints[index].address}\n`);
                    if (airnodeEndpoints[index].name === "opsWallet") {
                        const selector = 
                            await contract._getSelector("walletGet(bytes32,bytes)");
                        await contract._setEndpointReference (
                            airnodeEndpoints[index].address,
                            selector
                        );
                    }
                    if (airnodeEndpoints[index].name === "opsWalletLabel") {
                        const selector = 
                            await contract._getSelector("walletLabelGet(bytes32,bytes)");
                        await contract._setEndpointReference (
                            airnodeEndpoints[index].address,
                            selector
                        );
                    };
                    if (airnodeEndpoints[index].name === "opsTxSend") {
                        const selector = 
                            await contract._getSelector("txSendPost(bytes32,bytes)");
                        await contract._setEndpointReference (
                            airnodeEndpoints[index].address,
                            selector
                        );
                    };
                });
                console.log("Done with setup\n")
            } catch (e) {
                console.error(e);
            }
});