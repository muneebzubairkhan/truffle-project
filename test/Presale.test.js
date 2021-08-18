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
    clientOfTokenX, // this person will buy token X
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

      // this line will not happen in real life
      await busd.transfer(clientOfTokenX, toWei('100'), {
        from: busdOwner
      }); // give 100$ to client to buy token X

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
        {
          from: tokenXOwner
        }
      );

      const presale = await Presale.at(
        await presaleFactory.presaleOf(tokenX.address)
      );

      // client of tokenX approves presale address to spend his BUSD
      await busd.approve(presale.address, MAX_INT, { from: clientOfTokenX });

      console.log(
        'BEFORE tokenX client',
        fromWei((await tokenX.balanceOf(clientOfTokenX)).toString())
      );
      console.log(
        'busd client',
        fromWei((await busd.balanceOf(clientOfTokenX)).toString())
      );

      ///todo lp
      // console.log(
      //   "ERC20token client",
      //   fromWei((await ERC20Token.balanceOf(client)).toString())
      // );

      // parent company approves the presale is Genuine and not fake
      await presale.onlyParentCompanyFunction_editPresaleIsApproved(true, {
        from: parentCompany
      });

      // compare balances, assert

      // now client of token X will spend his BUSD to buy tokenX
      await presale.buyTokens(toWei('100'), { from: clientOfTokenX });

      // now assert, compare previos and current balances of tokenX, BUSD of the client

      // assert.equal();
      console.log(
        'AFTER token client',
        fromWei((await tokenX.balanceOf(clientOfTokenX)).toString())
      );
      console.log(
        'busd client',
        fromWei((await busd.balanceOf(clientOfTokenX)).toString())
      );

      console.log(
        'busd walletOwner: ',
        fromWei((await busd.balanceOf(presaleEarningWallet)).toString())
      );

      console.log(
        'await presale.tokensSold(): ',
        fromWei((await presale.tokenXSold()).toString())
      );
    });
  }
);

const toWei = web3.utils.toWei;
const fromWei = web3.utils.fromWei;
const MAX_INT =
  '0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff';
