const Splitter = artifacts.require("RoyaltySplit");

contract("Nft", async ([owner, client, parentCompany]) => {
  it("deploy smart contract", async () => {
    let splitter = await Splitter.new({ from: owner });

    await web3.eth.sendTransaction({
      from: owner,
      to: splitter.address,
      value: "100",
      gas: 25000,
    });
  });
});
