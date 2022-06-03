// @format
import { resolve, dirname } from "path";
import { writeFile } from "fs/promises";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));

const template = (number, fileType) => ({
  name: `${number}`,
  description:
    "A radical new model turns the NFT into a tool for decolonization.",
  image: `https://www.humanactivities.org/nfts/balot/${number}.${fileType}`,
});
const directory = "./files";

const imageType = "gif";
const start = 1;
const end = 306;

async function run() {
  for (let i = start; i <= end; i++) {
    const metadata = JSON.stringify(template(i, imageType));
    const filePath = resolve(__dirname, directory, `${i}.json`);
    await writeFile(filePath, metadata);
  }
}

run().catch(console.error).then();
