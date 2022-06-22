const SmartContract = artifacts.require("AirDrop");

contract("Nft", async ([owner, client, parentCompany]) => {
  it("deploy smart contract", async () => {
    //
    let smartContract = await SmartContract.new({ from: owner });
    console.log(owner === (await smartContract.owner()));
    // await smartContract.purchaseTokens(1, { value: toWei("0.025"), from: client });
  });
});
