const Nft = artifacts.require("WitchTown");

const testBuyNft = async ([owner]) => {
  console.log("Assalamo Alaikum");

  let nft = await Nft.deployed();
  console.log(owner === (await nft.owner()));

  await nft.setSaleActiveTime(0, 0);
  await nft.buyWitches(1, {
    value: await nft.itemPrice(),
    from: owner,
  });
  await nft.buyWitchesFree(1, {
    value: 0,
    from: owner,
  });
  // test nft viewable on opensea
};

contract("Nft", async (accounts) => {
  it("deploy smart contract", () => testBuyNft(accounts));
});
