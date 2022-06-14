const Nft = artifacts.require("FastFoodApes");

const testBuyNft = async ([owner]) => {
  console.log("Assalamo Alaikum");

  // let nft = await Nft.at("0xaaA47da2A3DF9f9e3D76Ae22D000EA69eB9Df8a8");
  let nft = await Nft.deployed();
  console.log(nft.address);
  console.log(owner === (await nft.owner()));

  await nft.setSaleActiveTime(0, 0);
  // await nft.buyApes(1, {
  //   value: await nft.apePrice(),
  //   from: owner,
  // });
  await nft.buyApesFree(1, {
    value: 0,
    from: owner,
  });
  console.log('totalSupply ' + await nft.totalSupply());
  // test nft viewable on opensea
};

contract("Nft", async (accounts) => {
  it("deploy smart contract", () => testBuyNft(accounts));
});
