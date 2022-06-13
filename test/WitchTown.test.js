const Nft = artifacts.require("WitchTown");

const testBuyNft = async ([owner]) => {
  console.log("Assalamo Alaikum");

  let nft = await Nft.at("0xaaA47da2A3DF9f9e3D76Ae22D000EA69eB9Df8a8");
  console.log(nft.address);
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
  console.log(await nft.totalSupply());
  // test nft viewable on opensea
};

contract("Nft", async (accounts) => {
  it("deploy smart contract", () => testBuyNft(accounts));
});
