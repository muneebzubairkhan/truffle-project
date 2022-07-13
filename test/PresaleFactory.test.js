const { toWei, fromWei } = require("web3-utils");

const Nft = artifacts.require("DysfunctionalDogsNft");

contract("Nft", async ([owner, client, parentCompany]) => {
  it("deploy smart contract", async () => {
    //
    let nft = await Nft.new({ from: owner });
    console.log(owner === (await nft.owner()));

    await nft.revealFlip();

    await nft.setSale1ActiveTime(0);
    await nft.sale1PurchaseTokens(1, { value: toWei("0.02"), from: client });

    await nft.setSale4ActiveTime(0);
    await nft.sale4PurchaseTokens(2, { value: toWei("0.04"), from: client });

    console.log("token 1 from sale 1", await nft.tokenURI(1));
    console.log("token 2 from sale 4", await nft.tokenURI(2));
    console.log("token 3 from sale 4", await nft.tokenURI(3));

    console.log("before", fromWei(await web3.eth.getBalance(owner)));
    await nft.withdraw({ from: owner });
    console.log("after", fromWei(await web3.eth.getBalance(owner)));

    const whitelist1 = [
      client,
      "0xc18E78C0F67A09ee43007579018b2Db091116B4C",
      "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
      "0xBCb03471E33C68BCdD2bA1D846E4737fedb768Fa",
      "0x590AD8E5Fd87f05B064FCaE86703039d1F0e4350",
      "0x989b691745F7B0139a429d2B36364668a01A39Cf",
    ];

    await nft.setWhitelist2ActiveTime(0);
    await nft.setWhitelist2(whitelist1, { from: owner });
    await nft.purchaseTokensWhitelist2(1, {
      value: toWei("0.01"),
      from: client,
    });

    await nft.setWhitelist3ActiveTime(0);
    await nft.setWhitelist3(whitelist1, { from: owner });
    await nft.purchaseTokensWhitelist3(1, {
      value: toWei("0.01"),
      from: client,
    });

     console.log("token 4 from sale 2", await nft.tokenURI(4));
     console.log("token 5 from sale 3", await nft.tokenURI(5));

    console.log("before", fromWei(await web3.eth.getBalance(owner)));
    await nft.withdraw({ from: owner });
    console.log("after", fromWei(await web3.eth.getBalance(owner)));
  });
});
