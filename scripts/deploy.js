const hre = require("hardhat");

async function main() {
  const sbt = await ethers.getContractFactory("SBT_v2");
  const SBT = await sbt.deploy();
  await SBT.waitForDeployment();
  console.log("Deployed Address: ", SBT.target);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
