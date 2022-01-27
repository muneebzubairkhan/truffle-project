const Contract1 = artifacts.require("Contract1");
const fs = require("fs");
const { makeHelperCodeForUIDev: makeUiCode } = require("../migrations/helper");

contract("Presale Generator", async ([_, owner, client, parentCompany]) => {
  // make it like real test case, input: buyTokens(100), expected output: person charged 100*0.3 = $30 and gets 100 tokens
  beforeEach(
    "Create Presale Factory, Make Presale, buyTokens(100) and see ",
    async () => {},
  );

  it("deploy smart contract", async () => {
    let contract1 = await Contract1.new({ from: owner });
    makeUiCode("development", { contract1 });
    // fs.writeFile("ab.txt", "aoa", (e) => e && console.log(e));
    // console.log({ contract1: contract1.address });
  });

  // it("in case of", async () => {});
});

// made this function in many hours. learnt that first go with simple stuff then slowly complicate.
const assertExceptionOccurs = async (func) => {
  let assertValue = true;
  try {
    await func();
    assertValue = false;
    assert(assertValue);
  } catch (e) {
    assert(assertValue);
    // console.log('e.message: ', e.message);
  }
};

const balanceOf = async (token, account) =>
  Number(
    fromWei((await token.balanceOf(account.address || account)).toString()),
  );

const seeBalanceOf = async (tag, token, account) =>
  console.log(tag, await balanceOf(token, account));

const MAX_INT =
  "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff";

const days = 86400;
const delimitter = "@$@L";

// {
//   const res = await presaleFactory.getPresales(0, 30);
//   console.log('res all sales: ', res);
// }
// {
//   const res = await presaleFactory.getPresaleDetails(presale.address);
//   console.log('res: ', res);
// }
// {
//   const res = await presaleFactory.getPresaleMediaLinks(presale.address);
//   console.log('res: ', res.split(delimitter));
// }

// await seeBalanceOf('... ', tokenX, presaleTokenX);
