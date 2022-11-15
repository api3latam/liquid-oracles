import { Wallet, providers, Contract } from "ethers";
import { encode } from "@api3/airnode-abi";
import { loadJsonFile, getEnvVars } from "../../../utils";
import type { Demo } from "../../../types/contracts/demo.sol/Demo";

const main = async () => {
    const artifact = loadJsonFile('artifacts/contracts/demo.sol/Demo.json')['abi'];
    const demo = loadJsonFile(`addresses/demogoerli.json`)['demo'];

    const provider = new providers.JsonRpcProvider(
        getEnvVars('GOERLI_RPC')[0]);
    const wallet = new Wallet(getEnvVars('PRIVATE_KEY')[0], provider);

    const contract = new Contract(demo, artifact, wallet) as Demo;
    const endpointData = await contract.endpointsIds(2);
    console.log(`Calling endpoint ${endpointData}\n`);
    
    const decimals = await contract.decimals();
    const targetAddress = 'tlq1qqdxchdcrvkzpgj62wwvreq8udajynqflk2w53f3tlahlmg7xwj280q2xxcj0k6h3xyklavpml7eyet5yxmq62c72jpngpwj3q'
    const totalAmount = '0.0005'
    const request = [
        { type: "string", name: "target_address", value: targetAddress },
        { type: "string", name: "total_amount", value: totalAmount }
    ];

    console.log(`Calling Operation Tx Endpoint with body: \
    ${request}...\n`);
    try {
        const tx = await contract.operationsTx (
            2,
            wallet.address,
            "0xd29BC939ACF8269938557A27949b228EEf478479",
            (Number(totalAmount) * (10 ** decimals)),
            encode(request)
        );

        const receipt = await tx.wait();
        console.log(receipt);
    } catch (err) {
        console.error(err);
    }
    
    console.log('\nDone!');
};

main();
