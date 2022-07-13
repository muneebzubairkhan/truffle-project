const { toWei, fromWei } = require("web3-utils");

const Nft = artifacts.require("DysfunctionalDogsNft");

contract("Nft", async ([owner, client, parentCompany]) => {
  it("deploy smart contract", async () => {
    //
    let nft = await Nft.new({ from: owner });
    console.log(owner === (await nft.owner()));

    await nft.setSaleActiveTime(0);
    await nft.purchaseTokens(1, { value: toWei("0.075"), from: client });

    console.log("before",fromWei(await web3.eth.getBalance(owner)));
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

    await nft.setWhitelist1ActiveTime(0);
    await nft.setWhitelist1(whitelist1, { from: owner });
    await nft.purchaseTokensWhitelist1(1, {
      value: toWei("0.03"),
      from: client,
    });
  
    console.log("before", fromWei(await web3.eth.getBalance(owner)));
    await nft.withdraw({ from: owner });
    console.log("after", fromWei(await web3.eth.getBalance(owner)));
  });
});
