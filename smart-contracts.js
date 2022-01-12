// Wednesday, January 12, 2022, 4:41 PM
//  
// Development:
// NftStaking  0x59910b0a1DC17536603e781a9e07F2fE7c13E46C
//
//=========================


// if you want to do only get calls then you can use defaultWeb3.

import Web3 from 'web3';

export const defaultWeb3 = new Web3(
  'http://127.0.0.1/'
);
  
  
export const nftStakingAddress = '0x59910b0a1DC17536603e781a9e07F2fE7c13E46C';
export const nftStakingAbi = JSON.parse(
  '[{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"AddedRewardTokensToContract","type":"event","signature":"0x0f122fff8f6fbdfac3723c7c7376574360a75caaa0a4a6a78e52a46572ad20cf"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"user","type":"address"},{"indexed":true,"internalType":"uint256","name":"pid","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Deposit","type":"event","signature":"0x90890809c654f11d6e72a28fa60149770a0d11ec6c92319d6ceb2bb0a4ea1a15"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"endBlock","type":"uint256"}],"name":"EndRewardBlockChanged","type":"event","signature":"0xe7d85683063a512b0ea7c9d84ce4ff33b516bc16b36f3dc5a98dd0b479d9f131"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"user","type":"address"},{"indexed":true,"internalType":"uint256","name":"pid","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Harvest","type":"event","signature":"0x71bab65ced2e5750775a0613be067df48ef06cf92a496ebf7663ae0660924954"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"contract IERC20","name":"token","type":"address"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"OwnerWithdraw","type":"event","signature":"0x13c461eb29f5d65800bbef5a5b05a06ea13b8b2ef4b889ee170f149bc1c8f8bd"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"previousOwner","type":"address"},{"indexed":true,"internalType":"address","name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event","signature":"0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"usersCanHarvestAtTime","type":"uint256"}],"name":"RewardFrozenTimeChanged","type":"event","signature":"0xaef38fc0702b0fad4b1dfce7e29092e26412be5abfadfabb118c6124d8880b6d"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"contract IERC20","name":"rewardToken","type":"address"}],"name":"RewardTokenChanged","type":"event","signature":"0xb74d956cf6ec7842d08ebf0ab19ec03a88c1efd4a50ea4349d30f9c4ce512e98"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"rewardPerBlock","type":"uint256"}],"name":"RewardTokenPerBlockChanged","type":"event","signature":"0x0914eb57aaf7dc30fb65a4997a39040c8c91ebe3bdd5226dde439f7a5fefaf6a"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"startRewardBlock","type":"uint256"}],"name":"StartRewardBlockChanged","type":"event","signature":"0xf0b3b2831f479a7321e755a2b6ef2ae0b5e32985a8959e61ffaec437194f4d3a"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"usersCanUnstakeAtTime","type":"uint256"}],"name":"UnstakeFrozenTimeChanged","type":"event","signature":"0x9e009f63830ca738bff6fbc38990622b83298c321dceb9b8c064b903c066db6d"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"user","type":"address"},{"indexed":true,"internalType":"uint256","name":"pid","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"amount","type":"uint256"}],"name":"Withdraw","type":"event","signature":"0xf279e6a1f5e320cca91135676d9cb6e44ca8a08c0b88342bcdb1144f6511b568"},{"inputs":[],"name":"bonusEndBlock","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x1aed6553"},{"inputs":[],"name":"endBlock","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x083c6323"},{"inputs":[{"internalType":"contract IERC721","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"}],"name":"nftOwnerOf","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x052f289e"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x8da5cb5b"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"poolInfo","outputs":[{"internalType":"contract IERC721","name":"poolToken","type":"address"},{"internalType":"uint256","name":"allocPoint","type":"uint256"},{"internalType":"uint256","name":"lastRewardBlock","type":"uint256"},{"internalType":"uint256","name":"accRewardTokenPerShare","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x1526fe27"},{"inputs":[],"name":"renounceOwnership","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x715018a6"},{"inputs":[],"name":"rewardPerBlock","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x8ae39cac"},{"inputs":[],"name":"rewardToken","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xf7c618c1"},{"inputs":[],"name":"startBlock","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x48cd4cb1"},{"inputs":[],"name":"totalAllocPoint","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x17caf6f1"},{"inputs":[{"internalType":"address","name":"newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xf2fde38b"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"address","name":"","type":"address"}],"name":"userInfo","outputs":[{"internalType":"uint256","name":"amount","type":"uint256"},{"internalType":"uint256","name":"rewardDebt","type":"uint256"},{"internalType":"uint256","name":"reward","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x93f1a40b"},{"inputs":[],"name":"usersCanHarvestAtTime","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x1df3b3c1"},{"inputs":[],"name":"usersCanUnstakeAtTime","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xc2c85351"},{"inputs":[],"name":"poolLength","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x081e3eda"},{"inputs":[{"internalType":"uint256","name":"_allocPoint","type":"uint256"},{"internalType":"contract IERC721","name":"_poolToken","type":"address"},{"internalType":"bool","name":"_withUpdate","type":"bool"}],"name":"add","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x1eaaa045"},{"inputs":[{"internalType":"uint256","name":"_pid","type":"uint256"},{"internalType":"uint256","name":"_allocPoint","type":"uint256"},{"internalType":"bool","name":"_withUpdate","type":"bool"}],"name":"setAllocPoint","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xa0f99203"},{"inputs":[{"internalType":"address","name":"_token","type":"address"}],"name":"getPidOfToken","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x141a8614"},{"inputs":[{"internalType":"uint256","name":"_pid","type":"uint256"},{"internalType":"address","name":"_user","type":"address"}],"name":"pendingRewardToken","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x1653fd33"},{"inputs":[],"name":"massUpdatePools","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x630b5ba1"},{"inputs":[{"internalType":"uint256","name":"_pid","type":"uint256"}],"name":"updatePool","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x51eb05a6"},{"inputs":[{"internalType":"uint256","name":"_pid","type":"uint256"},{"internalType":"uint256","name":"_tokenId","type":"uint256"}],"name":"deposit","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xe2bbb158"},{"inputs":[{"internalType":"uint256[]","name":"_pids","type":"uint256[]"},{"internalType":"uint256[]","name":"_tokenIds","type":"uint256[]"}],"name":"depositMany","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x4d6a535d"},{"inputs":[{"internalType":"uint256","name":"_pid","type":"uint256"},{"internalType":"uint256","name":"_tokenId","type":"uint256"}],"name":"withdraw","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x441a3e70"},{"inputs":[{"internalType":"uint256[]","name":"_pids","type":"uint256[]"},{"internalType":"uint256[]","name":"_tokenIds","type":"uint256[]"}],"name":"withdrawMany","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x9c9f760b"},{"inputs":[{"internalType":"uint256[]","name":"_pidsD","type":"uint256[]"},{"internalType":"uint256[]","name":"_tokenIdsD","type":"uint256[]"},{"internalType":"uint256[]","name":"_pidsW","type":"uint256[]"},{"internalType":"uint256[]","name":"_tokenIdsW","type":"uint256[]"}],"name":"depositWithdrawMany","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x472af9c4"},{"inputs":[{"internalType":"uint256","name":"_pid","type":"uint256"}],"name":"harvest","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xddc63262"},{"inputs":[{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"addRewardTokensToContract","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x580aceee"},{"inputs":[{"internalType":"contract IERC20","name":"_token","type":"address"},{"internalType":"uint256","name":"_amount","type":"uint256"}],"name":"withdrawAnyTokenFromContract","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xbb177529"},{"inputs":[{"internalType":"contract IERC20","name":"_rewardToken","type":"address"}],"name":"setRewardToken","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x8aee8127"},{"inputs":[{"internalType":"uint256","name":"_usersCanUnstakeAtTime","type":"uint256"}],"name":"setUnstakeFrozenTime","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xc9cc2e8e"},{"inputs":[{"internalType":"uint256","name":"_usersCanHarvestAtTime","type":"uint256"}],"name":"setRewardFrozenTime","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x7ffc319b"},{"inputs":[{"internalType":"uint256","name":"_rewardPerBlock","type":"uint256"}],"name":"setRewardTokenPerBlock","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xd7406965"},{"inputs":[{"internalType":"uint256","name":"_startBlock","type":"uint256"}],"name":"setStartRewardBlock","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x62b9e098"},{"inputs":[{"internalType":"uint256","name":"_endBlock","type":"uint256"}],"name":"setEndRewardBlock","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x4e362966"},{"inputs":[{"internalType":"address","name":"","type":"address"},{"internalType":"address","name":"","type":"address"},{"internalType":"uint256","name":"","type":"uint256"},{"internalType":"bytes","name":"","type":"bytes"}],"name":"onERC721Received","outputs":[{"internalType":"bytes4","name":"","type":"bytes4"}],"stateMutability":"nonpayable","type":"function","signature":"0x150b7a02"},{"inputs":[{"internalType":"address","name":"_owner","type":"address"},{"internalType":"address","name":"_nftAddress","type":"address"},{"internalType":"uint256","name":"_tokenIdFrom","type":"uint256"},{"internalType":"uint256","name":"_tokenIdTo","type":"uint256"},{"internalType":"uint256","name":"_maxNfts","type":"uint256"}],"name":"GetNFTsForAddress","outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xd356c72b"}]'
);
export const getContractNftStaking = ({web3= defaultWeb3, address= nftStakingAddress}) => 
  new web3.eth.Contract(
    nftStakingAbi, address
  );
  