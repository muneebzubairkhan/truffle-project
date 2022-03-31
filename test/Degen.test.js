const { toWei, fromWei } = require("web3-utils");
const { makeUiCode } = require("../migrations/helper.js");

const Nft2 = artifacts.require("MetaDegenSociety");
const Nft1 = artifacts.require("GoldenTicket");
const log = console.log;

contract("Nft", async ([owner1, owner, owner2]) => {
  it("deploy smart contract", async () => {
    assert("100" === fromWei(await web3.eth.getBalance(owner)));
    //
    let goldenTicket = await Nft1.new({ from: owner });
    let metaDegenSociety = await Nft2.new({ from: owner });
    await goldenTicket.setMetaDegenSociety(metaDegenSociety.address, {
      from: owner,
    });
    await metaDegenSociety.setGoldenTicket(goldenTicket.address, {
      from: owner,
    });

    await goldenTicket.setSaleActiveTime(0, { from: owner });
    await goldenTicket.purchaseTokens(4, {
      value: toWei("0.00180", "ether"),
      from: owner,
    });
    assert("99.9982" === fromWei(await web3.eth.getBalance(owner)));
    await goldenTicket.withdraw({ from: owner });
    assert("100" === fromWei(await web3.eth.getBalance(owner)));

    //

    await metaDegenSociety.setSaleActiveTime(0, { from: owner });
    await metaDegenSociety.purchaseTokens(2, {
      value: toWei("0.00180", "ether"),
      from: owner,
    });
    assert("99.9982" === fromWei(await web3.eth.getBalance(owner)));
    await metaDegenSociety.withdraw({ from: owner });
    assert("100" === fromWei(await web3.eth.getBalance(owner)));

    assert("2" === "" + (await metaDegenSociety.balanceOf(owner)));
    await metaDegenSociety.purchaseTokensWithGoldenTickets([2, 3], {
      from: owner,
    });
    assert("4" === "" + (await metaDegenSociety.balanceOf(owner)));
    
    let require;
    try {
      await goldenTicket.safeTransferFrom(owner, owner1, 3, { from: owner });
      require = false;
    } catch (e) {
      require = true;
    }

    assert(require);

    const nftsOfOwner = await goldenTicket.nftsOf(owner);
    nftsOfOwner.map((nft) => log("token id " + nft));

    //
    makeUiCode("mumbai", { goldenTicket, metaDegenSociety });
  });
});

// Error:
// Error: truffle-plugin.json not found in the eth-gas-reporter plugin package!
