const ERC20Token = artifacts.require('ERC20Token');
const Presale = artifacts.require('Presale');
const PresaleFactory = artifacts.require('PresaleFactory');

contract(
  'Presale Generator',
  async ([
    _,
    tokenXOwner,
    tokenBUSDOwner,
    tokenLpOwner,
    walletOwner,
    walletDev,
    client,
    parentCompany,
    presaleOwner
  ]) => {
    // make it like real test case, input: buyTokens(100), expected output: person charged 100*0.3 = $30 and gets 100 tokens
    it('Create Presale Factory, Make Presale, call buyTokens(100) and see ', async () => {
      // Variables Init
      // token X
      const tokenX = await ERC20Token.new(
        tokenXOwner,
        'tokenX',
        'tokenX',
        toWei('10000'),
        { from: tokenXOwner }
      );

      // LP TOKEN
      const lpToken = await ERC20Token.new(
        tokenLpOwner,
        'tokenlp',
        'tokenlp',
        toWei('1000'),
        { from: tokenLpOwner }
      );

      const busd = await ERC20Token.new(
        tokenBUSDOwner,
        'BUSD',
        'BUSD',
        toWei('1000'),
        { from: tokenBUSDOwner }
      );

      const presaleFactory = await PresaleFactory.new(
        parentCompany,
        busd.address
      );

      // this line will not happen in real life
      await busd.transfer(client, toWei('100'), {
        from: tokenBUSDOwner
      }); // give 100$ to client

      await presaleFactory.createERC20Presale(
        tokenX.address, // People will buy tokenX
        lpToken.address, // People will give buyingToken or USDT and get tokenX in return
        toWei('0.2'), // rate 0.2 busd = 1 tokenX
        '0', // _tokenXToLock
        '0', // _lpTokenXToLock
        '0', // _tokenXToSell
        '0', // _unlockAtTime
        '0', // _amountTokenXToBuyTokenX
        walletOwner, // presale owner
        false, //_onlyWhitelistedAllowed
        {
          from: presaleOwner
        }
      );

      const presale = await Presale.at(
        await presaleFactory.presaleOf(tokenX.address)
      );

      console.log(
        'BEFORE tokenX client',
        fromWei((await tokenX.balanceOf(client)).toString())
      );
      console.log(
        'busd client',
        fromWei((await busd.balanceOf(client)).toString())
      );
      ///todo lp

      // console.log(
      //   "ERC20token client",
      //   fromWei((await ERC20Token.balanceOf(client)).toString())
      // );

      await busd.approve(presale.address, MAX_INT, { from: client });
      await presale.onlyParentCompanyFunction_editPresaleIsApproved(true, {
        from: parentCompany
      });

      // compare balances, assert

      // await presale.buyTokens(toWei('100'), { from: client });
      // assert.equal();
      console.log(
        'AFTER token client',
        fromWei((await tokenX.balanceOf(client)).toString())
      );
      console.log(
        'busd client',
        fromWei((await busd.balanceOf(client)).toString())
      );

      console.log(
        'busd walletOwner: ',
        fromWei((await busd.balanceOf(walletOwner)).toString())
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
