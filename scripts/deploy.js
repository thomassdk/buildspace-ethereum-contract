const main = async () => {
  const noteContractFactory = await hre.ethers.getContractFactory("NotePortal");
  const noteContract = await noteContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.001"),
  });

  await noteContract.deployed();

  console.log("NotePortal address: ", noteContract.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

runMain();
