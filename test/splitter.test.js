const Splitter = artifacts.require("RoyaltySplit");
const WETH9 = artifacts.require("WETH9");

contract("Nft", async ([owner, client, parentCompany]) => {
  it("withdraw ETH", async () => {
    let splitter = await Splitter.new({ from: owner });

    await web3.eth.sendTransaction({
      from: owner,
      to: splitter.address,
      value: "100",
      gas: 25000,
    });

    splitter.withdraw();
  });

  it("withdraw ERC20", async () => {
    let splitter = await Splitter.new({ from: owner });
    let weth9 = await WETH9.new({ from: owner });

    await web3.eth.sendTransaction({
      from: owner,
      to: weth9.address,
      value: "100",
      //   gas: 25000,
    });
    await weth9.transfer(splitter.address, "100");

    console.log(
      "erc20 bal before ",
      "" + (await weth9.balanceOf(splitter.address))
    );
    await splitter.withdrawERC20(weth9.address);
    console.log(
      "erc20 bal after ",
      "" + (await weth9.balanceOf(splitter.address))
    );
  });
});
