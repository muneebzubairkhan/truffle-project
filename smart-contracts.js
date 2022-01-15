// Saturday, January 15, 2022, 3:30 PM
//  
// Rinkeby:
// NftStaking https://rinkeby.etherscan.io/address/0x19036147f1AEB634459D6e0e254531f85f956DfC
//
//=========================


// if you want to do only get calls then you can use defaultWeb3.

import Web3 from 'web3';

export const defaultWeb3 = new Web3(
  'https://rinkeby.infura.io/v3/3da1c863472e43d989856450d4e6889d'
);
  
  
export const nftStakingAddress = '0x19036147f1AEB634459D6e0e254531f85f956DfC';
export const nftStakingAbi = JSON.parse(
  '[{"inputs":[],"stateMutability":"nonpayable","type":"constructor","signature":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event","signature":"0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"Paused","type":"event","signature":"0x62e78cea01bee320cd4e420270b5ea74000d11b0c9f74754ebdbfc544b05a258"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"address","name":"account","type":"address"}],"name":"Unpaused","type":"event","signature":"0x5db9ee0a495bf2e6ff9c91a7834c1ba4fdd244a5e8aa4e537bd38aeae4b073aa"},{"inputs":[],"name":"erc20","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x785e9e86"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x8da5cb5b"},{"inputs":[],"name":"paused","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x5c975abb"},{"inputs":[],"name":"pidsLen","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x95b8fbcc"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x715018a6"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xf2fde38b"},{"inputs":[{"internalType":"contract IERC721","name":"_depositToken","type":"address"}],"name":"addPoolToken","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xc0681c3d"},{"inputs":[{"internalType":"contract IERC721","name":"token","type":"address"}],"name":"getPidOfToken","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x141a8614"},{"inputs":[{"internalType":"uint256","name":"pid","type":"uint256"},{"internalType":"uint256","name":"_rarity","type":"uint256"},{"internalType":"uint256","name":"_rate","type":"uint256"}],"name":"setRate","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x3989c666"},{"inputs":[{"internalType":"uint256","name":"pid","type":"uint256"},{"internalType":"uint256","name":"_tokenId","type":"uint256"},{"internalType":"uint256","name":"_rarity","type":"uint256"}],"name":"setRarity","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xff842a70"},{"inputs":[{"internalType":"uint256","name":"pid","type":"uint256"},{"internalType":"uint256[]","name":"_tokenIds","type":"uint256[]"},{"internalType":"uint256","name":"_rarity","type":"uint256"}],"name":"setBatchRarity","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x98932472"},{"inputs":[{"internalType":"uint256","name":"pid","type":"uint256"},{"internalType":"uint256","name":"_expiration","type":"uint256"}],"name":"setExpiration","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x07031305"},{"inputs":[{"internalType":"contract IERC20","name":"_erc20","type":"address"}],"name":"setRewardTokenAddress","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x9a6acf20"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"address","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"bytes","name":"","type":"bytes"}],"name":"onERC721Received","outputs":[{"internalType":"bytes4","name":"","type":"bytes4"}],"stateMutability":"pure","type":"function","constant":true,"signature":"0x150b7a02"},{"inputs":[{"internalType":"uint256","name":"pid","type":"uint256"},{"internalType":"address","name":"account","type":"address"}],"name":"depositsOf","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x6c617ee8"},{"inputs":[{"internalType":"address","name":"_owner","type":"address"},{"internalType":"address","name":"_nftAddress","type":"address"},{"internalType":"uint256[]","name":"_tokenIds","type":"uint256[]"},{"internalType":"uint256","name":"_maxNfts","type":"uint256"}],"name":"GetNFTsForAddress","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xd1e0fc45"},{"inputs":[{"internalType":"address","name":"_owner","type":"address"},{"internalType":"address","name":"_nftAddress","type":"address"},{"internalType":"uint256","name":"_tokenIdFrom","type":"uint256"},{"internalType":"uint256","name":"_tokenIdTo","type":"uint256"},{"internalType":"uint256","name":"_maxNfts","type":"uint256"}],"name":"GetNFTsForAddress","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xd356c72b"},{"inputs":[{"internalType":"uint256","name":"pid","type":"uint256"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"findRate","outputs":[{"internalType":"uint256","name":"rate","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xd98701bb"},{"inputs":[{"internalType":"uint256","name":"pid","type":"uint256"},{"internalType":"address","name":"account","type":"address"},{"internalType":"uint256[]","name":"tokenIds","type":"uint256[]"}],"name":"pendingRewardToken","outputs":[{"internalType":"uint256[]","name":"rewards","type":"uint256[]"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x8fd7f231"},{"inputs":[{"internalType":"uint256","name":"pid","type":"uint256"},{"internalType":"uint256[]","name":"tokenIds","type":"uint256[]"}],"name":"claimRewards","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xb0ee5e28"},{"inputs":[{"internalType":"uint256","name":"pid","type":"uint256"},{"internalType":"uint256[]","name":"tokenIds","type":"uint256[]"}],"name":"depositMany","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xc05b37f4"},{"inputs":[{"internalType":"uint256","name":"pid","type":"uint256"},{"internalType":"uint256[]","name":"tokenIds","type":"uint256[]"}],"name":"admin_deposit","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x3b82233b"},{"inputs":[{"internalType":"uint256","name":"pid","type":"uint256"},{"internalType":"uint256[]","name":"tokenIds","type":"uint256[]"}],"name":"withdrawMany","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x095d9cea"}]'
);
export const getContractNftStaking = ({web3= defaultWeb3, address= nftStakingAddress}) => 
  new web3.eth.Contract(
    nftStakingAbi, address
  );
  