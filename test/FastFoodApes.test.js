const Nft = artifacts.require("FastFoodApes");

const testBuyNft = async ([owner, alice, bob, carol, dora]) => {
  console.log("Assalamo Alaikum");

  // let nft = await Nft.at("0xaaA47da2A3DF9f9e3D76Ae22D000EA69eB9Df8a8");
  let nft = await Nft.deployed();
  console.log(nft.address);
  console.log(owner === (await nft.owner()));

  await nft.setSaleActiveTime(0, 0, { from: owner });
  await nft.buyApesFree(2, {
    value: 0,
    from: alice,
  });
  await nft.buyApesFree(2, {
    value: 0,
    from: bob,
  });
  await nft.buyApesFree(2, {
    value: 0,
    from: carol,
  });
  await nft.buyApes(3, {
    value: 3 * (await nft.apePrice()),
    from: dora,
  });
  console.log("totalSupply " + (await nft.totalSupply()));
  // test nft viewable on opensea
};

contract("Nft", async (accounts) => {
  it("deploy smart contract", () => testBuyNft(accounts));
});
