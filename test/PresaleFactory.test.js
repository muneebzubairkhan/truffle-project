const ERC20Token = artifacts.require('ERC20Token');
const Presale = artifacts.require('Presale');
const PresaleFactory = artifacts.require('PresaleFactory');

contract(
  'Presale Generator',
  async ([
    _,
    tokenXOwner, // any token owner who wants to launch presale for their token
    busdOwner,
    presaleOwner,
    client, // this person will buy token X
    parentCompany, // the company who provides the services of launchpad
  ]) => {
    // make it like real test case, input: buyTokens(100), expected output: person charged 100*0.3 = $30 and gets 100 tokens
    it('Create Presale Factory, Make Presale, buyTokens(100) and see ', async () => {
      // Variables Init
      // token X
      const tokenX = await ERC20Token.new(
        tokenXOwner,
        'tokenX',
        'tokenX',
        toWei('1000000'),
        { from: tokenXOwner },
      );

      // LP TOKEN
      const lpToken = await ERC20Token.new(
        tokenXOwner,
        'tokenlp',
        'tokenlp',
        toWei('1000000'),
        { from: tokenXOwner },
      );

      const busd = await ERC20Token.new(
        busdOwner,
        'BUSD',
        'BUSD',
        toWei('1000000'),
        { from: busdOwner },
      );

      // make factory
      const presaleFactory = await PresaleFactory.new(
        parentCompany,
        busd.address,
        (tokenToHold_ = busd.address),
        (amountTokenToHold_ = 0),
      );

      // Setup environment before buying from presale:

      // give 100$ to client to buy token X
      await busd.transfer(client, toWei(2000), {
        from: busdOwner,
      });

      // 100LP for locking
      await lpToken.transfer(tokenXOwner, toWei(2000), {
        from: tokenXOwner,
      });

      // 100 tokenX for selling
      // 100 tokenX for locking
      await tokenX.transfer(tokenXOwner, toWei(2000), {
        from: tokenXOwner,
      });

      // tokenXOwner approves presale address to spend his lpToken for locking
      await lpToken.approve(presaleFactory.address, MAX_INT, {
        from: tokenXOwner,
      });

      // tokenXOwner approves presale address to spend his tokenX for locking, selling
      await tokenX.approve(presaleFactory.address, MAX_INT, {
        from: tokenXOwner,
      });

      // create a presale
      const rate = 1;
      await presaleFactory.createERC20Presale(
        [
          tokenX.address,
          lpToken.address,
          //
          toWei(rate),
          toWei(100), // hardcap
          toWei(100), // softcap
          0, // presale open at
          MAX_INT, // presale close at
          0, // unlockTokensAt
          //
          toWei(0), // tokenXToLock
          toWei(0), // lpTokenXToLock
          //
          false,
          [presaleOwner, tokenXOwner],
          'a',
        ],
        {
          from: tokenXOwner,
        },
      );

      // get the newly created presale
      const presaleAddress = await presaleFactory.presales(0);
      const presaleTokenX = await Presale.at(presaleAddress);

      // client of tokenX approves this presale to spend his BUSD
      await busd.approve(presaleTokenX.address, MAX_INT, { from: client });

      const beforeTokenXOfClient = await balanceOf(tokenX, client);
      const beforeBusdOfClient = await balanceOf(busd, client);

      // parent company approves the presale is Genuine and not fake
      await presaleTokenX.onlyParent_editPresaleIsApproved(
        true,
        (_score_ = 3),
        {
          from: parentCompany,
        },
      );

      // now client of token X will spend his BUSD to buy tokenX
      const tokenXToBuy = 10;
      await presaleTokenX.buyTokens(toWei(tokenXToBuy), { from: client });

      const afterTokenXOfClient = await balanceOf(tokenX, client);
      const afterBusdOfClient = await balanceOf(busd, client);

      // now assert, compare previos and current balances of tokenX, BUSD of the client
      assert.equal(beforeTokenXOfClient, 0);
      assert.equal(afterTokenXOfClient, tokenXToBuy); // client has token which he bought

      const price = rate * tokenXToBuy;
      assert.equal(afterBusdOfClient, beforeBusdOfClient - price);

      // Now client has successfully bought tokens

      // Now try withdraw for owner and the client

      // in case of PRESALE IS NOT ENDED. owner can not withdraw tokens. client can not withdraw tokens.
      // {
      //   // owner withdraw
      //   await assertExceptionOccurs(
      //     async () =>
      //       await presaleTokenX.onlyOwner_withdrawBUSD({ from: tokenXOwner }),
      //   );
      //   // client withdraw
      //   await assertExceptionOccurs(
      //     async () =>
      //       await presaleTokenX.sellTokens(toWei(5), { from: client }),
      //   );
      // }

      // await seeBalanceOf('... ', tokenX, presaleTokenX);

      // in case of CANCELLED PRESALE. owner can not withdraw tokens. client can withdraw tokens.
      {
        // cancel presale
        await presaleTokenX.onlyOwner_cancelPresale({ from: tokenXOwner });
        // owner withdraw
        await assertExceptionOccurs(() =>
          presaleTokenX.onlyOwner_withdrawBUSD({ from: tokenXOwner }),
        );
        // client withdraw, dependency: client needs to approve presale contract to spend client's tokenX
        // dependency
        await tokenX.approve(presaleTokenX.address, MAX_INT, { from: client });

        // mainwork
        await presaleTokenX.sellTokens(toWei(10), { from: client });
      }

      // in case of PRESALE IS ENDED. SOFTCAP MET. owner can withdraw tokens. client can not withdraw tokens.

      // in case of PRESALE IS ENDED. SOFTCAP NOT MET. owner can not withdraw tokens. client can withdraw tokens.
    });
  },
);

// made this function in many hours. learnt that first go with simple stuff then slowly complicate.
const assertExceptionOccurs = async func => {
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

const toWei = n => web3.utils.toWei('' + n);
const fromWei = n => web3.utils.fromWei('' + n);

const MAX_INT =
  '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';

const delimitter = '@$@L';
const socialMedia = `https://www.facebook.com/muneeb.qureshi.50951${delimitter}https://twitter.com/muneeb_butt9?lang=en${delimitter}https://www.instagram.com/muneeb_butt/?hl=en${delimitter}https://docs.google.com/document/d/1_buydr48_P5PSzLc7d1i5DqXA7jpn5dZVNEP_42Birs/edit`;

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
