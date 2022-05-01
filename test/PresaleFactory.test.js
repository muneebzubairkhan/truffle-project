const { toWei, fromWei } = require("web3-utils");
const { MerkleTree } = require("merkletreejs");
const keccak256 = require("keccak256");
const { toChecksumAddress } = require("web3-utils");

const Nft = artifacts.require("AlphaAliensStaking");

contract("Nft", async ([owner, client, parentCompany]) => {
  it("deploy smart contract", async () => {
    //
    let nft = await Nft.new({ from: owner });
    console.log(owner === (await nft.owner()));
    await nft.setSaleActiveTime(0);
    await nft.purchaseTokens(1, { value: toWei("0.025"), from: client });
    console.log(fromWei(await web3.eth.getBalance(owner)));
    await nft.withdraw({ from: owner });
    console.log(fromWei(await web3.eth.getBalance(owner)));

    const whitelist = [
      client,
      "0xc18E78C0F67A09ee43007579018b2Db091116B4C",
      "0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
      "0xBCb03471E33C68BCdD2bA1D846E4737fedb768Fa",
      "0x590AD8E5Fd87f05B064FCaE86703039d1F0e4350",
      "0x989b691745F7B0139a429d2B36364668a01A39Cf",
    ].map((a) => toChecksumAddress(a));

    const tree = new MerkleTree(whitelist, keccak256, {
      hashLeaves: true,
      sortPairs: true,
    });

    await nft.setPresaleActiveTime(0);
    await nft.setPresale(0, tree.getHexRoot(), 2, toWei("0.01"), {
      from: owner,
    });
    await nft.purchaseTokensWhitelist(
      1,
      tree.getHexProof(keccak256(client)),
      0,
      {
        value: toWei("0.01"),
        from: client,
      }
    );
    console.log(fromWei(await web3.eth.getBalance(owner)));
    await nft.withdraw({ from: owner });
    console.log(fromWei(await web3.eth.getBalance(owner)));
  });
});
