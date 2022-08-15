function validateEnvValues ( inputValue: string, isStrict: boolean ): string {
    let toOutput = inputValue !== undefined ? inputValue : "";
    if (toOutput === "" && isStrict === true) {
        throw TypeError("The requested value is not available as an environment variable.");
    } else {
        return toOutput;
    }
}

export function getEnvVars( inputKey: string | string[], path?: string, strict?: boolean ): string[] {
    const rootPath = require("app-root-path");
    const newPath = path !== undefined ? `${rootPath}/${path}` : `${rootPath}.env`;
    require("dotenv").config(newPath);

    let output: string[] = new Array();
    const strictness: boolean = Boolean(strict);

    try {
        if (typeof inputKey === "string") {
            const tempValue = process.env[inputKey] as string;
            const toAppend = validateEnvValues(tempValue, strictness);
            output.push(toAppend);
        }
        else {
            for (let k of inputKey) {
                const tempValue = process.env[k] as string;
                const toAppend = validateEnvValues(tempValue, strictness);
                output.push(toAppend);
            }
        }
    } catch (e) {
        console.error(e);
    }
    
    return output;
}