// Development:
// Busd  0x144584CE4FEF2fcDB5532b8d72636CEC9a77f1c8
// TokenX  0x39eB49265b690c7394Ad88F816bf693E58F219D6
// LpTokenX  0xA9901800eC9c90061E761758427177ac0d452e00
// Presale  0x80Fa6363dEff9193F1E7f7A3A24Edb5c789a44fb
// PresaleFactory  0x2A18A19d641271B3F1dbE69A03f74400Fd03C9b5
// Locker  0xc933308a95568F04218db46968629EAC44fC8779
//
//=========================


  // if you want to do only get calls then you can use defaultWeb3.

  import Web3 from 'web3';
  
  export const defaultWeb3 = new Web3(
    'http://127.0.0.1/'
  );
  
  
  export const busdAddress = '0x144584CE4FEF2fcDB5532b8d72636CEC9a77f1c8';
  export const busdAbi = JSON.parse(
    '[{"inputs":[{"internalType":"address","name":"_owner","type":"address"},{"internalType":"string","name":"_name","type":"string"},{"internalType":"string","name":"_symbol","type":"string"},{"internalType":"uint256","name":"_supply","type":"uint256"}],"stateMutability":"nonpayable","type":"constructor","signature":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event","signature":"0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event","signature":"0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event","signature":"0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xdd62ed3e"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0x095ea7b3"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x70a08231"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x313ce567"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0xa457c2d7"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0x39509351"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x06fdde03"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x8da5cb5b"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x715018a6"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x95d89b41"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x18160ddd"},{"inputs":[{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0xa9059cbb"},{"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0x23b872dd"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xf2fde38b"},{"inputs":[],"name":"get_1000_Coins","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x8d67e612"},{"inputs":[{"internalType":"address","name":"_account","type":"address"}],"name":"get_1000_coins_at_address","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xdb74a38e"}]'
  );
  export const getContractBusd = (address = busdAddress, web3 = defaultWeb3) => 
    new web3.eth.Contract(
      busdAbi, address
    );
  


  export const tokenXAddress = '0x39eB49265b690c7394Ad88F816bf693E58F219D6';
  export const tokenXAbi = JSON.parse(
    '[{"inputs":[{"internalType":"address","name":"_owner","type":"address"},{"internalType":"string","name":"_name","type":"string"},{"internalType":"string","name":"_symbol","type":"string"},{"internalType":"uint256","name":"_supply","type":"uint256"}],"stateMutability":"nonpayable","type":"constructor","signature":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event","signature":"0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event","signature":"0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event","signature":"0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xdd62ed3e"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0x095ea7b3"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x70a08231"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x313ce567"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0xa457c2d7"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0x39509351"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x06fdde03"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x8da5cb5b"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x715018a6"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x95d89b41"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x18160ddd"},{"inputs":[{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0xa9059cbb"},{"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0x23b872dd"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xf2fde38b"},{"inputs":[],"name":"get_1000_Coins","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x8d67e612"},{"inputs":[{"internalType":"address","name":"_account","type":"address"}],"name":"get_1000_coins_at_address","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xdb74a38e"}]'
  );
  export const getContractTokenX = (address = tokenXAddress, web3 = defaultWeb3) => 
    new web3.eth.Contract(
      tokenXAbi, address
    );
  


  export const lpTokenXAddress = '0xA9901800eC9c90061E761758427177ac0d452e00';
  export const lpTokenXAbi = JSON.parse(
    '[{"inputs":[{"internalType":"address","name":"_owner","type":"address"},{"internalType":"string","name":"_name","type":"string"},{"internalType":"string","name":"_symbol","type":"string"},{"internalType":"uint256","name":"_supply","type":"uint256"}],"stateMutability":"nonpayable","type":"constructor","signature":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"spender","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Approval","type":"event","signature":"0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event","signature":"0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":false,"internalType":"uint256","name":"value","type":"uint256"}],"name":"Transfer","type":"event","signature":"0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"spender","type":"address"}],"name":"allowance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xdd62ed3e"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"approve","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0x095ea7b3"},{"inputs":[{"internalType":"address","name":"account","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x70a08231"},{"inputs":[],"name":"decimals","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x313ce567"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"subtractedValue","type":"uint256"}],"name":"decreaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0xa457c2d7"},{"inputs":[{"internalType":"address","name":"spender","type":"address"},{"internalType":"uint256","name":"addedValue","type":"uint256"}],"name":"increaseAllowance","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0x39509351"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x06fdde03"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x8da5cb5b"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x715018a6"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x95d89b41"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x18160ddd"},{"inputs":[{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transfer","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0xa9059cbb"},{"inputs":[{"internalType":"address","name":"sender","type":"address"},{"internalType":"address","name":"recipient","type":"address"},{"internalType":"uint256","name":"amount","type":"uint256"}],"name":"transferFrom","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"nonpayable","type":"function","signature":"0x23b872dd"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xf2fde38b"},{"inputs":[],"name":"get_1000_Coins","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x8d67e612"},{"inputs":[{"internalType":"address","name":"_account","type":"address"}],"name":"get_1000_coins_at_address","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xdb74a38e"}]'
  );
  export const getContractLpTokenX = (address = lpTokenXAddress, web3 = defaultWeb3) => 
    new web3.eth.Contract(
      lpTokenXAbi, address
    );
  


  export const presaleAddress = '0x80Fa6363dEff9193F1E7f7A3A24Edb5c789a44fb';
  export const presaleAbi = JSON.parse(
    '[{"inputs":[{"internalType":"contract IERC20","name":"_tokenX","type":"address"},{"internalType":"contract IERC20","name":"_lpTokenX","type":"address"},{"internalType":"contract IERC20","name":"_tokenToHold","type":"address"},{"internalType":"contract IERC20","name":"_busd","type":"address"},{"internalType":"uint256","name":"_rate","type":"uint256"},{"internalType":"address","name":"_presaleEarningWallet","type":"address"},{"internalType":"bool","name":"_onlyWhitelistedAllowed","type":"bool"},{"internalType":"uint256","name":"_amountTokenToHold","type":"uint256"},{"internalType":"address[]","name":"_whitelistAddresses","type":"address[]"},{"internalType":"string","name":"_presaleMediaLinks","type":"string"}],"stateMutability":"nonpayable","type":"constructor","signature":"constructor"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"_amountTokenToHold","type":"uint256"}],"name":"AmountTokenToHoldChanged","type":"event","signature":"0x86f7792013b8eb083d3440448a77cc2c1c1d260ba0eef3c1375239d1b6885914"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event","signature":"0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"_presaleWillCloseAt","type":"uint256"}],"name":"PresaleAppliedToClosed","type":"event","signature":"0xd605e730f917a7bb30144f9bfb90a078f94e54d14001a54047d9f1f17dbb6132"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"_presaleMediaLinks","type":"string"}],"name":"PresaleMediaLinksChanged","type":"event","signature":"0x294e829ade98dc933fbcee8b1f61b26e62855b785b2071d01e0194eacfbf04e2"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"_newRate","type":"uint256"}],"name":"RateChanged","type":"event","signature":"0x595a30f13a69b616c4d568e2a2b7875fdfe86e4300a049953c76ee278f8f3f10"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"_tokens","type":"uint256"}],"name":"UnlockedUnsoldTokens","type":"event","signature":"0x6b7ef30321e5ce0d7e2eda643ef6fb72d62f52e813d923427c4960780cb68a8d"},{"inputs":[],"name":"amountTokenToHold","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x07eba71d"},{"inputs":[],"name":"busd","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x3ca5b234"},{"inputs":[],"name":"factory","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xc45a0155"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"isWhitelisted","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x3af32abf"},{"inputs":[],"name":"lpTokenX","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xebebb2d1"},{"inputs":[],"name":"lpTokenXLocker","outputs":[{"internalType":"contract Locker","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xd30f5d44"},{"inputs":[],"name":"onlyWhitelistedAllowed","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x079bb6b0"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x8da5cb5b"},{"inputs":[],"name":"participantsCount","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xdd60c898"},{"inputs":[],"name":"presaleAppliedForClosing","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xa06df8dd"},{"inputs":[],"name":"presaleClosedAt","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x96bfd251"},{"inputs":[],"name":"presaleEarningWallet","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x69f80786"},{"inputs":[],"name":"presaleIsApproved","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x7e9dfd8f"},{"inputs":[],"name":"presaleIsBlacklisted","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x6271c61e"},{"inputs":[],"name":"presaleMediaLinks","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x41003ce0"},{"inputs":[],"name":"rate","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x2c4e722e"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x715018a6"},{"inputs":[],"name":"tier","outputs":[{"internalType":"uint8","name":"","type":"uint8"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x16f4d022"},{"inputs":[],"name":"tokenToHold","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xb1a30bc6"},{"inputs":[],"name":"tokenX","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x16dc165b"},{"inputs":[],"name":"tokenXLocker","outputs":[{"internalType":"contract Locker","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xdbe929d4"},{"inputs":[],"name":"tokenXSold","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xd44d4d1f"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xf2fde38b"},{"inputs":[{"internalType":"uint256","name":"_tokens","type":"uint256"}],"name":"buyTokens","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x3610724e"},{"inputs":[{"internalType":"string","name":"_presaleMediaLinks","type":"string"}],"name":"ownerFunction_editOnlyWhitelistedAllowed","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x04e2b747"},{"inputs":[{"internalType":"bool","name":"_onlyWhitelistedAllowed","type":"bool"}],"name":"ownerFunction_editOnlyWhitelistedAllowed","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xb1eab4c0"},{"inputs":[{"internalType":"address[]","name":"_addresses","type":"address[]"},{"internalType":"bool","name":"_approve","type":"bool"}],"name":"ownerFunction_editWhitelist","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x19f004d6"},{"inputs":[{"internalType":"uint256","name":"_amountTokenToHold","type":"uint256"}],"name":"onlyOwnerFunction_setAmountTokenToHold","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x22554848"},{"inputs":[],"name":"onlyOwnerFunction_UnlockUnsoldTokens","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x8f23d123"},{"inputs":[{"internalType":"uint8","name":"_months","type":"uint8"}],"name":"onlyOwnerFunction_closePresale","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x38742706"},{"inputs":[{"internalType":"bool","name":"_presaleIsApproved","type":"bool"}],"name":"onlyParentCompanyFunction_editPresaleIsApproved","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xc6cae69d"},{"inputs":[{"internalType":"bool","name":"_presaleIsBlacklisted","type":"bool"}],"name":"onlyParentCompanyFunction_editPresaleIsBlacklisted","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x8c18d9b8"},{"inputs":[{"internalType":"uint8","name":"_tier","type":"uint8"}],"name":"onlyParentCompanyFunction_editTier","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xf9df691d"},{"inputs":[],"name":"getPresaleDetails","outputs":[{"internalType":"address[]","name":"","type":"address[]"},{"internalType":"uint256[]","name":"","type":"uint256[]"},{"internalType":"bool[]","name":"","type":"bool[]"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x4729376b"},{"inputs":[{"internalType":"contract Locker","name":"_tokenXLocker","type":"address"}],"name":"setTokenXLocker","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x920d735a"},{"inputs":[{"internalType":"contract Locker","name":"_lpTokenXLocker","type":"address"}],"name":"setLpTokenXLocker","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xce16005b"},{"inputs":[],"name":"parentCompany","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x669e7582"}]'
  );
  export const getContractPresale = (address = presaleAddress, web3 = defaultWeb3) => 
    new web3.eth.Contract(
      presaleAbi, address
    );
  


  export const presaleFactoryAddress = '0x2A18A19d641271B3F1dbE69A03f74400Fd03C9b5';
  export const presaleFactoryAbi = JSON.parse(
    '[{"inputs":[{"internalType":"address","name":"_parentCompany","type":"address"},{"internalType":"contract IERC20","name":"_busd","type":"address"}],"stateMutability":"nonpayable","type":"constructor","signature":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event","signature":"0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"belongsToThisFactory","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x3dddf102"},{"inputs":[],"name":"busd","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x3ca5b234"},{"inputs":[],"name":"lastPresaleIndex","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x5f92cd3c"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x8da5cb5b"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"presales","outputs":[{"internalType":"contract Presale","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x7dbfb36d"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x715018a6"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xf2fde38b"},{"inputs":[{"internalType":"contract IERC20[]","name":"_tokens","type":"address[]"},{"internalType":"uint256","name":"_rate","type":"uint256"},{"internalType":"uint256","name":"_tokenXToLock","type":"uint256"},{"internalType":"uint256","name":"_lpTokenXToLock","type":"uint256"},{"internalType":"uint256","name":"_tokenXToSell","type":"uint256"},{"internalType":"uint256","name":"_unlockAtTime","type":"uint256"},{"internalType":"uint256","name":"_amountTokenXToBuyTokenX","type":"uint256"},{"internalType":"address","name":"_presaleEarningWallet","type":"address"},{"internalType":"bool","name":"_onlyWhitelistedAllowed","type":"bool"},{"internalType":"address[]","name":"_whitelistAddresses","type":"address[]"},{"internalType":"string","name":"_presaleMediaLinks","type":"string"}],"name":"createERC20Presale","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x0f1ec2e1"},{"inputs":[{"internalType":"uint256","name":"_index","type":"uint256"},{"internalType":"uint256","name":"_amountToFetch","type":"uint256"}],"name":"getPresales","outputs":[{"internalType":"contract Presale[]","name":"","type":"address[]"},{"internalType":"contract IERC20[]","name":"","type":"address[]"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xd651a1a3"},{"inputs":[{"internalType":"address","name":"_presale","type":"address"}],"name":"getPresaleDetails","outputs":[{"internalType":"address[]","name":"","type":"address[]"},{"internalType":"uint256[]","name":"","type":"uint256[]"},{"internalType":"bool[]","name":"","type":"bool[]"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x211b5616"},{"inputs":[{"internalType":"address","name":"_token","type":"address"}],"name":"getTokenName","outputs":[{"internalType":"string","name":"name","type":"string"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x6f0fccab"},{"inputs":[{"internalType":"address","name":"_token","type":"address"}],"name":"getTokenSymbol","outputs":[{"internalType":"string","name":"symbol","type":"string"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x81a73ad5"},{"inputs":[{"internalType":"contract Presale","name":"_presale","type":"address"}],"name":"getPresaleMediaLinks","outputs":[{"internalType":"string","name":"symbol","type":"string"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xe793baad"},{"inputs":[],"name":"developers","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"pure","type":"function","constant":true,"signature":"0x2bc31ca4"}]'
  );
  export const getContractPresaleFactory = (address = presaleFactoryAddress, web3 = defaultWeb3) => 
    new web3.eth.Contract(
      presaleFactoryAbi, address
    );
  


  export const lockerAddress = '0xc933308a95568F04218db46968629EAC44fC8779';
  export const lockerAbi = JSON.parse(
    '[{"inputs":[{"internalType":"contract IERC20","name":"_tokenX","type":"address"},{"internalType":"address","name":"_walletOwner","type":"address"},{"internalType":"uint256","name":"_unlockTokensAtTime","type":"uint256"}],"stateMutability":"nonpayable","type":"constructor","signature":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event","signature":"0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"contract IERC20","name":"_token","type":"address"},{"indexed":false,"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"UnlockTokensRequestMade","type":"event","signature":"0x45596054dc29aa86ea477fb9261bf0274468813f2caabb3cf6687eb80bf95c66"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"contract IERC20","name":"_token","type":"address"},{"indexed":false,"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"UnlockedTokens","type":"event","signature":"0xaf08a4db36432bb5cbbfdfcf5af1040246483dc0dae8a9616cc79816c432fee9"},{"inputs":[],"name":"factory","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xc45a0155"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x8da5cb5b"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x715018a6"},{"inputs":[],"name":"tokenX","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x16dc165b"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xf2fde38b"},{"inputs":[],"name":"unlockTokensAtTime","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x8bfea7e0"},{"inputs":[],"name":"unlockTokensRequestAccepted","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xf1ed6b15"},{"inputs":[],"name":"unlockTokensRequestMade","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x73ef73a3"},{"inputs":[],"name":"walletOwner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x1ae879e8"},{"inputs":[{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"lockTokens","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x6e27d889"},{"inputs":[],"name":"makeUnlockTokensRequest","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x65eb73c6"},{"inputs":[],"name":"approveUnlockTokensRequest","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x8de1e933"},{"inputs":[],"name":"balance","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xb69ef8a8"}]'
  );
  export const getContractLocker = (address = lockerAddress, web3 = defaultWeb3) => 
    new web3.eth.Contract(
      lockerAbi, address
    );
  