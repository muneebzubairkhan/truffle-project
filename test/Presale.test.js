const RedToken = artifacts.require("RedToken");
const Presale = artifacts.require("Presale");
const USDT = artifacts.require("USDT");

contract(
  "Presale",
  async ([_, tokenOwner, walletOwner, walletDev, , client, usdtOwner]) => {
    // make it like real test case, input: buyTokens(100), expected output: person charged 100*0.3 = $30 and gets 100 tokens
    it("input: buyTokens(100), expected output: person charged 100*0.3 = $30 and gets 100 tokens.", async () => {
      // Variables Init {
      const tokenX = await RedToken.new({ from: tokenOwner });
      const usdt = await USDT.new({ from: usdtOwner });

      // this line will not happen in real life
      await usdt.transfer(client, toWei("1000"), {
        from: usdtOwner,
      }); // give 100$ to client

      const presale = await Presale.new(
        tokenX.address, // People will buy tokenX
        usdt.address, // People will give buyingToken or USDT and get tokenX in return
        toWei("0.3"), // rate
        walletOwner,
        {
          from: tokenOwner,
        }
      );

      const tokensForPresale = toWei("1000");
      await tokenX.transfer(presale.address, tokensForPresale, {
        from: tokenOwner,
      });

      // }
      console.log(
        "BEFORE token client",
        fromWei((await tokenX.balanceOf(client)).toString())
      );
      console.log(
        "usdt client",
        fromWei((await usdt.balanceOf(client)).toString())
      );

      await usdt.approve(presale.address, MAX_INT, { from: client });
      await presale.buyTokens(toWei("100"), { from: client });

      console.log(
        "AFTER token client",
        fromWei((await tokenX.balanceOf(client)).toString())
      );
      console.log(
        "usdt client",
        fromWei((await usdt.balanceOf(client)).toString())
      );

      console.log(
        "usdt walletOwner: ",
        fromWei((await usdt.balanceOf(walletOwner)).toString())
      );

      console.log(
        "await presale.tokensSold(): ",
        fromWei((await presale.tokenXSold()).toString())
      );
    });
  }
);

const toWei = web3.utils.toWei;
const fromWei = web3.utils.fromWei;
const MAX_INT =
  "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";
