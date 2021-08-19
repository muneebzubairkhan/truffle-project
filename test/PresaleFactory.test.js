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
    parentCompany // the company who provides the services of launchpad
  ]) => {
    // make it like real test case, input: buyTokens(100), expected output: person charged 100*0.3 = $30 and gets 100 tokens
    it('Create Presale Factory, Make Presale, call buyTokens(100) and see ', async () => {
      // Variables Init
      // token X
      const tokenX = await ERC20Token.new(
        tokenXOwner,
        'tokenX',
        'tokenX',
        toWei('1000'),
        { from: tokenXOwner }
      );

      // LP TOKEN
      const lpToken = await ERC20Token.new(
        tokenXOwner,
        'tokenlp',
        'tokenlp',
        toWei('1000'),
        { from: tokenXOwner }
      );

      const busd = await ERC20Token.new(
        busdOwner,
        'BUSD',
        'BUSD',
        toWei('1000'),
        { from: busdOwner }
      );

      const presaleFactory = await PresaleFactory.new(
        parentCompany,
        busd.address
      );

      // give 100$ to client to buy token X
      await busd.transfer(client, toWei('100'), {
        from: busdOwner
      });

      // 100LP for locking
      await lpToken.transfer(tokenXOwner, toWei('100'), {
        from: tokenXOwner
      });

      // 100 tokenX for selling
      // 100 tokenX for locking
      await tokenX.transfer(tokenXOwner, toWei('200'), {
        from: tokenXOwner
      });

      // tokenXOwner approves presale address to spend his lpToken for locking
      await lpToken.approve(presaleFactory.address, MAX_INT, {
        from: tokenXOwner
      });

      // tokenXOwner approves presale address to spend his tokenX for locking, selling
      await tokenX.approve(presaleFactory.address, MAX_INT, {
        from: tokenXOwner
      });

      await presaleFactory.createERC20Presale(
        tokenX.address, // People will buy tokenX
        lpToken.address, // People will give buyingToken or USDT and get tokenX in return
        toWei('0.2'), // rate 0.2 busd = 1 tokenX, 20 BUSD= 100 Token X
        toWei('100'), // _tokenXToLock
        toWei('100'), // _lpTokenXToLock
        toWei('100'), // _tokenXToSell
        '0', // _unlockAtTime
        '0', // _amountTokenXToBuyTokenX
        presaleEarningWallet, // presale owner
        false, //_onlyWhitelistedAllowed
        [presaleEarningWallet, tokenXOwner], // whitelist
        {
          from: tokenXOwner
        }
      );

      const presaleAddress = await presaleFactory.presaleOf(tokenX.address);
      const presale = await Presale.at(presaleAddress);

      // client of tokenX approves presale address to spend his BUSD
      await busd.approve(presale.address, MAX_INT, { from: client });

      const beforeTokenXOfClient = await balanceOf(tokenX, client);
      const beforeBusdOfClient = await balanceOf(busd, client);

      // parent company approves the presale is Genuine and not fake
      await presale.onlyParentCompanyFunction_editPresaleIsApproved(true, {
        from: parentCompany
      });

      // now client of token X will spend his BUSD to buy tokenX
      const tokenXToBuy = '100';
      await presale.buyTokens(toWei(tokenXToBuy), { from: client });

      const afterTokenXOfClient = await balanceOf(tokenX, client);
      const afterBusdOfClient = await balanceOf(busd, client);

      // now assert, compare previos and current balances of tokenX, BUSD of the client
      assert.equal(beforeTokenXOfClient, '0');
      assert.equal(afterTokenXOfClient, tokenXToBuy); // client has token which he bought

      assert.equal(beforeBusdOfClient, '100');
      assert.equal(afterBusdOfClient, '80');

      const res = await presaleFactory.getSomePresales(0, 3);
      console.log('res: ', res);

      {
        const res = await presaleFactory.getSomePresales('0', '3');
        console.log('res: ', res);
      }
    });
  }
);

const balanceOf = async (token, account) =>
  fromWei((await token.balanceOf(account)).toString());

const toWei = web3.utils.toWei;
const fromWei = web3.utils.fromWei;
const MAX_INT =
  '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
