const ERC20Token = artifacts.require('ERC20Token');
const Presale = artifacts.require('Presale');
const PresaleFactory = artifacts.require('PresaleFactory');

contract(
  'Presale Generator',
  async ([
    _,
    tokenXOwner, // any token owner who wants to launch presale for their token
    busdOwner,
    presaleEarningWallet,
    client, // this person will buy token X
    parentCompany, // the company who provides the services of launchpad
  ]) => {
    // make it like real test case, input: buyTokens(100), expected output: person charged 100*0.3 = $30 and gets 100 tokens
    it('Create Presale Factory, Make Presale, call buyTokens(100) and see ', async () => {
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

      const presaleFactory = await PresaleFactory.new(
        parentCompany,
        busd.address,
      );

      {
        const res = await presaleFactory.getPresalesApproved('0', '3', true);
        console.log('res: ', res);
      }

      // give 100$ to client to buy token X
      await busd.transfer(client, toWei('1200'), {
        from: busdOwner,
      });

      // 100LP for locking
      await lpToken.transfer(tokenXOwner, toWei('1200'), {
        from: tokenXOwner,
      });

      // 100 tokenX for selling
      // 100 tokenX for locking
      await tokenX.transfer(tokenXOwner, toWei('1400'), {
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
      const rate = 0.2;
      await presaleFactory.createERC20Presale(
        tokenX.address, // People will buy tokenX
        lpToken.address, // People will give buyingToken or USDT and get tokenX in return
        toWei(rate), // rate 0.2 busd = 1 tokenX, 20 BUSD= 100 Token X
        toWei(100), // _tokenXToLock
        toWei(100), // _lpTokenXToLock
        toWei(100), // _tokenXToSell
        0, // _unlockAtTime
        toWei(0), // _amountTokenXToBuyTokenX
        presaleEarningWallet, // presale owner
        false, //_onlyWhitelistedAllowed
        [presaleEarningWallet, tokenXOwner], // whitelist
        socialMedia + socialMedia,
        {
          from: tokenXOwner,
        },
      );

      const presaleAddress = await presaleFactory.presales(0);
      const presale = await Presale.at(presaleAddress);

      // client of tokenX approves presale address to spend his BUSD
      await busd.approve(presale.address, MAX_INT, { from: client });

      const beforeTokenXOfClient = await balanceOf(tokenX, client);
      const beforeBusdOfClient = await balanceOf(busd, client);

      // parent company approves the presale is Genuine and not fake
      await presale.onlyParentCompanyFunction_editPresaleIsApproved(true, {
        from: parentCompany,
      });

      // now client of token X will spend his BUSD to buy tokenX
      const tokenXToBuy = 100;
      await presale.buyTokens(toWei(tokenXToBuy), { from: client });

      const afterTokenXOfClient = await balanceOf(tokenX, client);
      const afterBusdOfClient = await balanceOf(busd, client);

      // now assert, compare previos and current balances of tokenX, BUSD of the client
      assert.equal(beforeTokenXOfClient, 0);
      assert.equal(afterTokenXOfClient, tokenXToBuy); // client has token which he bought

      const price = rate * tokenXToBuy;
      assert.equal(afterBusdOfClient, beforeBusdOfClient - price);

      {
        const res = await presaleFactory.getPresalesAll(0, 30);
        console.log('res all sales: ', res);
      }
      {
        const res = await presaleFactory.getPresalesApproved(0, 30, true);
        console.log('res approved sales: ', res);
      }
      {
        const res = await presaleFactory.getPresalesApproved(0, 30, false);
        console.log('res not approved sales: ', res);
      }
      // {
      //   const res = await presaleFactory.getPresaleDetails(presale.address);
      //   console.log('res: ', res);
      // }
      // {
      //   const res = await presaleFactory.getPresaleMediaLinks(presale.address);
      //   console.log('res: ', res.split(delimitter));
      // }
    });
  },
);

const balanceOf = async (token, account) =>
  Number(fromWei((await token.balanceOf(account)).toString()));

const toWei = n => web3.utils.toWei('' + n);
const fromWei = n => web3.utils.fromWei('' + n);

const MAX_INT =
  '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';

const delimitter = '@$@L';
const socialMedia = `https://www.facebook.com/muneeb.qureshi.50951${delimitter}https://twitter.com/muneeb_butt9?lang=en${delimitter}https://www.instagram.com/muneeb_butt/?hl=en${delimitter}https://docs.google.com/document/d/1_buydr48_P5PSzLc7d1i5DqXA7jpn5dZVNEP_42Birs/edit`;
