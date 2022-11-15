import { Wallet, providers, Contract } from "ethers";
import { loadJsonFile, getEnvVars } from "../../../utils";
import type { Demo } from "../../../types/contracts/demo.sol/Demo";

const main = async () => {
    const artifact = loadJsonFile('artifacts/contracts/demo.sol/Demo.json')['abi'];
    const demo = loadJsonFile(`addresses/demogoerli.json`)['demo'];

    const provider = new providers.WebSocketProvider(
        getEnvVars('GOERLI_WS')[0]);
    const wallet = new Wallet(getEnvVars('PRIVATE_KEY')[0], provider);

    const contract = new Contract(demo, artifact, wallet) as Demo;

    const endpointData = await contract.endpointsIds(0);
    console.log(`Calling endpoint ${endpointData}\n`);
    await contract.operationsWallet(0, wallet.address, []);
    
    contract.on("SuccessfulRequest", async (requestId: string, result: string) => {
        console.log(`Event Wallet Operation with requestId ${requestId}\n`);
        console.log(`Resulted in: ${result}`);
        process.exit(0);
    });
}

main();
