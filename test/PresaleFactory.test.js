const Nft = artifacts.require("WWW");

const testBuyNft = async ([owner]) => {
  console.log("Assalamo Alaikum");

  let nft = await Nft.at("0x106722D96c72B8d2899d6c20A38C181B2Ffa6A46");
  console.log(owner === (await nft.owner()));
  
  await nft.setSaleActiveTime(0);
  await nft.purchaseTokens(1, {
    value: await nft.itemPrice(),
    from: owner,
  });
  
  // test nft viewable on opensea
};

contract("Nft", async (accounts) => {
  it("deploy smart contract", () => testBuyNft(accounts));
});
