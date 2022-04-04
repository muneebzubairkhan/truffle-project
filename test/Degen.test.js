const { fromWei } = require("web3-utils");
const { makeUiCode } = require("../migrations/helper.js");

const Nft2 = artifacts.require("MetaDegenSociety");
const Nft1 = artifacts.require("GoldenTicket");
const log = console.log;

const toWei = (amount, unit) => web3.utils.toWei("" + amount, unit);

contract("Nft", async ([owner1, owner, owner2]) => {
  it("deploy smart contract", async () => {
    //
    assert(100 == fromWei(await web3.eth.getBalance(owner)));
    //

    // ================================ Deployments ================================
    let goldenTicket = await Nft1.new({ from: owner });
    let metaDegenSociety = await Nft2.new({ from: owner });
    await goldenTicket.setMetaDegenSociety(metaDegenSociety.address, {
      from: owner,
    });
    await metaDegenSociety.setGoldenTicket(goldenTicket.address, {
      from: owner,
    });
    await goldenTicket.setPrice(toWei(0.01, "ether"), {
      from: owner,
    });
    await metaDegenSociety.setPrice(toWei(0.02, "ether"), {
      from: owner,
    });

    // ================================ Golden Ticket Sale Started ========================
    assert(0 == (await goldenTicket.totalSupply()));
    assert(0 == (await metaDegenSociety.totalSupply()));

    await goldenTicket.giftNft([owner], 25, { from: owner });

    assert(25 == (await goldenTicket.totalSupply()));
    assert(0 == (await metaDegenSociety.totalSupply()));

    await goldenTicket.setSaleActiveTime(0, { from: owner });
    const goldenTickets = 25;
    const goldenTicketsPrice = goldenTickets * 0.01;
    await goldenTicket.purchaseTokens(goldenTickets, {
      value: toWei(goldenTicketsPrice, "ether"),
      from: owner,
    });

    assert(50 == (await goldenTicket.totalSupply()));
    assert(0 == (await metaDegenSociety.totalSupply()));

    assert(
      100 - goldenTicketsPrice == fromWei(await web3.eth.getBalance(owner))
    );
    await goldenTicket.withdraw({ from: owner });
    assert(100 == fromWei(await web3.eth.getBalance(owner)));

    // ================================ Meta Degen Sale Started ================================
    //
    await metaDegenSociety.giftNft([owner], 45, { from: owner });

    assert(50 == (await goldenTicket.totalSupply()));
    assert(45 == (await metaDegenSociety.totalSupply()));

    await metaDegenSociety.setSaleActiveTime(0, { from: owner });
    const metaDegens = 5; //  50 gt + 5 mds + 45 mds reserved = 100 mds total mint possible // totalSupply after mint () + goldenTicket.totalSupply() + reservedSupply <= maxSupply
    const priceMetaDegens = metaDegens * 0.02;
    await metaDegenSociety.purchaseTokens(metaDegens, {
      value: toWei(priceMetaDegens, "ether"),
      from: owner,
    });

    assert(50 == (await goldenTicket.totalSupply()));
    assert(50 == (await metaDegenSociety.totalSupply()));

    assert(100 - priceMetaDegens == fromWei(await web3.eth.getBalance(owner)));
    await metaDegenSociety.withdraw({ from: owner });
    assert(100 == fromWei(await web3.eth.getBalance(owner)));

    await metaDegenSociety.purchaseTokensWithGoldenTickets(
      [
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
        21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38,
        39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
      ],
      {
        from: owner,
      }
    );

    assert(0 == (await goldenTicket.totalSupply()));
    assert(100 == (await metaDegenSociety.totalSupply()));

    // use expect revert here
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
    // makeUiCode("mumbai", { goldenTicket, metaDegenSociety });
  });
});

// Error:
// Error: truffle-plugin.json not found in the eth-gas-reporter plugin package!
