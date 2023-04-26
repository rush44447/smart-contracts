import { ethers } from "hardhat";
import {expect} from "chai";

async function main() {
  const currentTimestampInSeconds = Math.round(Date.now() / 1000)+60;
  const unlockTime = currentTimestampInSeconds;

  const lockedAmount = ethers.utils.parseEther("0.001");

  const Lock = await ethers.getContractFactory("Rent");
  const lock = await Lock.deploy();

  await lock.deployed();
  await lock.addRenter("0x70997970C51812dc3A010C7d01b50e0d17dc79C8","Rushabh","Modi",true, false, 100000,0,0,0);

  setTimeout(async () => {
    console.log(">>>>>>")
    // console.log(await lock.checkIn("0x70997970C51812dc3A010C7d01b50e0d17dc79C8"))
    console.log(await lock.makePayment("0x70997970C51812dc3A010C7d01b50e0d17dc79C8"))
    console.log(await lock.userBalance("0x70997970C51812dc3A010C7d01b50e0d17dc79C8"))

  }, 15000)

  // let [signerAddress] = await ethers.provider.listAccounts();
  // assert.equal( lock.withdraw, signerAddress)

  console.log(
    `Lock with ${ethers.utils.formatEther(lockedAmount)}ETH and unlock timestamp ${unlockTime} deployed to ${lock.address}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
