const SmartContract = artifacts.require("DoTheUniverse");

const smartContractFunction = async ([owner, alice, bob, carol, dora]) => {
  console.log("Assalamo Alaikum");

  let smartContract = await SmartContract.deployed();
  console.log(smartContract.address);

  await smartContract.setSaleActiveTime(0, 0, { from: owner });
};

contract("Smart Contract", async (accounts) => {
  it("calls functions on smart contract", () =>
    smartContractFunction(accounts));
});
