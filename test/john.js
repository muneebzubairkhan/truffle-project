const SmartContract = artifacts.require("TheHodlerz");

const smartContractFunction = async ([owner, alice, bob, carol, dora]) => {
  console.log("Assalamo Alaikum");

  let sc = await SmartContract.deployed();
  console.log(sc.address);

  await sc.setSaleActiveTime(0, 0, { from: owner });
  await sc.setFirstFreeMints(5, { from: owner });
  {
    const qty = 3;
    const price = "" + (await sc.getPrice(qty, { from: bob }));
    console.log({ price });
    await sc.buyHodlerz(qty, {
      from: bob,
      value: price,
    });
  }
  {
    const qty = 2;
    const price = "" + (await sc.getPrice(qty, { from: bob }));
    console.log({ price });
    await sc.buyHodlerz(qty, {
      from: bob,
      value: price,
    });
  }
};

contract("Smart Contract", async (accounts) => {
  it("calls functions on smart contract", () =>
    smartContractFunction(accounts));
});
