const ARI = artifacts.require("ARI");
const Presale = artifacts.require("Presale");
const USDT = artifacts.require("USDT");

contract("Presale", async ([tokenOwner, wallet, client, usdtOwner]) => {
  // make it like real test case, input: buyTokens(100), expected output: person charged 100*0.3 = $30 and gets 100 tokens
  it("input: buyTokens(100), expected output: person charged 100*0.3 = $30 and gets 100 tokens.", async () => {
    // Variables Init {
    const token = await ARI.new({ from: tokenOwner });
    const usdt = await USDT.new({ from: usdtOwner });

    // this line will not happen in real life
    await usdt.transfer(client, web3.utils.toWei("100"), { from: usdtOwner }); // give 100$ to client

    const presale = await Presale.new(token.address, usdt.address, wallet, {
      from: tokenOwner,
    });

    const tokensForPresale = web3.utils.toWei("250000000");
    await token.transfer(presale.address, tokensForPresale, {
      from: tokenOwner,
    });

    // }
    console.log(
      "BEFORE (await token.balanceOf(client)).toNumber()",
      web3.utils.fromWei((await token.balanceOf(client)).toString())
    );
    console.log(
      "(await usdt.balanceOf(client)).toNumber()",
      web3.utils.fromWei((await usdt.balanceOf(client)).toString())
    );

    await usdt.approve(presale.address, MAX_INT, { from: client });
    await presale.buyTokens(web3.utils.toWei("100"), { from: client });

    console.log(
      "AFTER (await token.balanceOf(client)).toNumber()",
      web3.utils.fromWei((await token.balanceOf(client)).toString())
    );
    console.log(
      "(await usdt.balanceOf(client)).toNumber()",
      web3.utils.fromWei((await usdt.balanceOf(client)).toString())
    );
  });
});

const MAX_INT =
  "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
