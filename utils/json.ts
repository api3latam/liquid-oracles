import fs from "fs";

/**
 * Loads a JSON File from a given path.
 * 
 * @param file - The location of the file to be read. 
 * @returns The loaded data or an empty object if no file was found.
 */
export function loadJsonFile(file: string) {
    const appRoot = require("app-root-path");
    try {
        const data = fs.readFileSync(`${appRoot}${file[0] === "/" ? file : "/" + file}`);
        return JSON.parse(data as any);
    } catch (err) {
        return {};
    }   
};

/**
 * Writes or Appends to a JSON File the given data.
 * 
 * @param args - { data - The data to be used for the file, 
 *                 path - The location to write or append the data,
 *                 mode (optional) - If "a" appends the data, else overwrites. }
 * 
 * @remarks
 * The parent root of the file should already exists. 
 * If we use the following path: "./exampleDir/exampleFile.json" then "./exampleDir/" should exists,
 * else you'll get an error.
 */

export function writeJsonFile(args: {data: any, path: string, mode?: string}) {
    const appRoot = require("app-root-path");
    let prevData: any;
    if (args.mode === "a") {
        prevData = loadJsonFile(args.path);
    } else {
        prevData = {}
    }
    const parsedData = JSON.stringify(
        { ...prevData, ...args.data },
        null,
        2
    );
    fs.writeFileSync(appRoot + args.path, parsedData);
    console.log(`Filed written to: ${appRoot}${args.path}`);
};