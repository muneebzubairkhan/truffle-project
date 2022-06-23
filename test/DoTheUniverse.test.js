const SmartContract = artifacts.require("DoTheUniverse");

const smartContractFunction = async ([owner, alice, bob, carol, dora]) => {
  console.log("Assalamo Alaikum");

  let smartContract = await SmartContract.deployed();
  console.log(smartContract.address);

  await smartContract.setSaleActiveTime(0, 0, { from: owner });
  await smartContract.buyUniverses(1, {
    from: bob,
    value: await smartContract.getPrice(1, { from: bob }),
  });
  await smartContract.buyUniverses(9, {
    from: bob,
    value: await smartContract.getPrice(9, { from: bob }),
  });

  await smartContract.buyUniverses(1, {
    from: carol,
    value: await smartContract.getPrice(1, { from: carol }),
  });
};

contract("Smart Contract", async (accounts) => {
  it("calls functions on smart contract", () =>
    smartContractFunction(accounts));
});

