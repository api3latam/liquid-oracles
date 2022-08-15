import axios from "axios";

// import { getEnvVars } from "../../../utils"


const API_URL = "https://jscm2sqbsb.execute-api.us-east-1.amazonaws.com/v1";
const API_KEY = "8d890a46-799d-48b3-a337-8531e23dfe8e";

export const getRootPath = async () => {
    return axios.post(
        API_URL, {
            headers: {
                "x-api-key": API_KEY
            },
            params: {}
        }   
    )
}

const main = async () => {
    const result = await getRootPath();
    console.log(result);
}

main();