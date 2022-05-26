const main = async () => {
  const noteContractFactory = await hre.ethers.getContractFactory("NotePortal");
  const noteContract = await noteContractFactory.deploy({
    value: hre.ethers.utils.parseEther("0.1"),
  });
  await noteContract.deployed();
  console.log("Contract addy:", noteContract.address);

  let contractBalance = await hre.ethers.provider.getBalance(
    noteContract.address
  );
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  /*
   * Let's try two notes now
   */
  const noteTxn = await noteContract.playNote("This is note #1");
  await noteTxn.wait();

  const noteTxn2 = await noteContract.playNote("This is note #2");
  await noteTxn2.wait();

  contractBalance = await hre.ethers.provider.getBalance(noteContract.address);
  console.log(
    "Contract balance:",
    hre.ethers.utils.formatEther(contractBalance)
  );

  let allNotes = await noteContract.getAllNotes();
  console.log(allNotes);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
