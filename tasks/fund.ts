import { AirnodeRrpAddresses, 
    AirnodeRrpV0Factory, 
    AirnodeRrpV0 } from '@api3/airnode-protocol';
import { deriveSponsorWalletAddress,
    sponsorRequester } from "@api3/airnode-admin";
import { task } from "hardhat/config";

import { getEnvVars,
    loadJsonFile } from "../utils";

task("deploy", "Deploy Compile Contracts for Repository")
    .setAction(async (_, hre) => {
            const demoAirnode = loadJsonFile('pyliquid/airnodes/demo/v090/output/receipt.json')
                ['airnodeWallet'];
            const demo = loadJsonFile(`addresses/demo${hre.network.name}.json`)['demo'];

            const provider = new hre.ethers.providers.JsonRpcProvider (
                getEnvVars (
                    `${(hre.network.name).toUpperCase()}_RPC`)
                    [0]
                );
            const wallet = new hre.ethers.Wallet(getEnvVars("PRIVATE_KEY")[0], provider);

            try {
                const rrpAddress = AirnodeRrpAddresses[hre.network.config.chainId as number]; 
                const sponsor = await deriveSponsorWalletAddress(
                    demoAirnode['airnodeXpub'],
                    demoAirnode['airnodeAddress'],
                    wallet.address
                );

                const value = hre.ethers.utils.parseEther("0.1");
                const unit = "ETH";

                console.log(
                    `Funding Demo sponsor wallet at ${sponsor} with: \
                        ${value} ${unit}\n`
                    );
                await wallet.sendTransaction({
                    to: sponsor,
                    value: hre.ethers.utils.parseEther(value.toString()),
                    });

                console.log(`Sponsor wallet funded\
                    \nApproving requester for contract: ${demo}`);

                const airnodeContract = AirnodeRrpV0Factory.getContract(
                    rrpAddress,
                    AirnodeRrpV0Factory.abi
                ) as AirnodeRrpV0;
        
                const airnode = airnodeContract.connect(wallet);

                await sponsorRequester(airnode, demo);
                console.log("Done setting sponsor-requester for contract!");

            } catch (e) {
                console.error(e);
            }
        }
    );