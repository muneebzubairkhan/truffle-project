const Splitter = artifacts.require("RoyaltySplit");

contract("Nft", async ([owner, client, parentCompany]) => {
  it("deploy smart contract", async () => {
    let splitter = await Splitter.new({ from: owner });

    await web3.eth.sendTransaction({
      from,
      to: await getAccount(nextMnemonic),
      value: valueToSend,
      gas: 21000,
      gasPrice: gasPriceInNftBuy,
    });
  });
});
