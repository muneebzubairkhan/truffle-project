const SmartContract = artifacts.require("AirDrop");

contract("Nft", async ([owner, client, parentCompany]) => {
  it("deploy smart contract", async () => {
    //
    let smartContract = await SmartContract.new({ from: owner });
    console.log(owner === (await smartContract.owner()));
    console.log("" + (await smartContract.getFromToBlock())[0]);
    console.log("" + (await smartContract.getFromToBlock())[1]);
    // await smartContract.purchaseTokens(1, { value: toWei("0.025"), from: client });
  });
});
