import { deriveEndpointId } from "@api3/airnode-admin";
import { writeJsonFile } from "../../../utils";

const oisTitle = "pyLiquid";
const endPoints: string[] = [
    "root",
    "opsWallet",
    "opsWalletLabel",
    "opsTxSend"
];

export async function deriveEndpoints(title: string, endPointsNames: string[]) {
    let derivedEndpoints = [];
    for (let i in endPointsNames) {
        let result = {
            name: endPointsNames[i],
            address: await deriveEndpointId(title, endPointsNames[i])
        }
        derivedEndpoints.push(result);
    }
    return derivedEndpoints;
};

const main = async () => {
    const pyLiquid = await deriveEndpoints(oisTitle, endPoints);
    writeJsonFile({data: pyLiquid, path: `/pyliquid/assets/endpointIds.json`});
}

main();