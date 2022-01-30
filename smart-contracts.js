// Sunday, January 30, 2022, 11:45 PM
//  
// Development:
// Nft  0xd67fE14d878FC844fb0f53bfbf168b234C0e4093
//
//=========================


export const nftAddress = '0xd67fE14d878FC844fb0f53bfbf168b234C0e4093';
export const nftAbi = JSON.parse(
  '[{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"approved","type":"address"},{"indexed":true,"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"Approval","type":"event","signature":"0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"owner","type":"address"},{"indexed":true,"internalType":"address","name":"operator","type":"address"},{"indexed":false,"internalType":"bool","name":"approved","type":"bool"}],"name":"ApprovalForAll","type":"event","signature":"0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31"},{"anonymous":false,"inputs":[{"indexed":true,"internalType":"address","name":"from","type":"address"},{"indexed":true,"internalType":"address","name":"to","type":"address"},{"indexed":true,"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"Transfer","type":"event","signature":"0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"allowlistClaimedBy","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x812326c8"},{"inputs":[],"name":"allowlistMaxMint","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xf0649ce8"},{"inputs":[{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"approve","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x095ea7b3"},{"inputs":[{"internalType":"address","name":"owner","type":"address"}],"name":"balanceOf","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x70a08231"},{"inputs":[],"name":"baseURI","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x6c0360eb"},{"inputs":[],"name":"dev","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x91cca3db"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"getApproved","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x081812fc"},{"inputs":[],"name":"isAllowlistActive","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xd2d515cc"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"address","name":"operator","type":"address"}],"name":"isApprovedForAll","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xe985e9c5"},{"inputs":[],"name":"isSaleActive","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x564566a8"},{"inputs":[],"name":"itemPrice","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xdac6db1c"},{"inputs":[],"name":"itemPricePresale","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xb4cdf927"},{"inputs":[],"name":"maxSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xd5abeb01"},{"inputs":[],"name":"name","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x06fdde03"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"onAllowlist","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x74097a9d"},{"inputs":[],"name":"owner","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x8da5cb5b"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"ownerOf","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x6352211e"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"safeTransferFrom","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x42842e0e"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"},{"internalType":"bytes","name":"_data","type":"bytes"}],"name":"safeTransferFrom","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xb88d4fde"},{"inputs":[{"internalType":"address","name":"operator","type":"address"},{"internalType":"bool","name":"approved","type":"bool"}],"name":"setApprovalForAll","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xa22cb465"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"staked","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x5e1bef32"},{"inputs":[{"internalType":"bytes4","name":"interfaceId","type":"bytes4"}],"name":"supportsInterface","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x01ffc9a7"},{"inputs":[],"name":"symbol","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x95d89b41"},{"inputs":[{"internalType":"uint256","name":"index","type":"uint256"}],"name":"tokenByIndex","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x4f6ccce7"},{"inputs":[{"internalType":"address","name":"owner","type":"address"},{"internalType":"uint256","name":"index","type":"uint256"}],"name":"tokenOfOwnerByIndex","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x2f745c59"},{"inputs":[{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"tokenURI","outputs":[{"internalType":"string","name":"","type":"string"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xc87b56dd"},{"inputs":[],"name":"totalSupply","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0x18160ddd"},{"inputs":[{"internalType":"address","name":"from","type":"address"},{"internalType":"address","name":"to","type":"address"},{"internalType":"uint256","name":"tokenId","type":"uint256"}],"name":"transferFrom","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x23b872dd"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"whitelisted","outputs":[{"internalType":"bool","name":"","type":"bool"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xd936547e"},{"inputs":[{"internalType":"address[]","name":"addresses","type":"address[]"},{"internalType":"bool","name":"_add","type":"bool"}],"name":"addToAllowlist","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x63100b45"},{"inputs":[{"internalType":"uint256","name":"_howMany","type":"uint256"}],"name":"purchasePresaleTokens","outputs":[],"stateMutability":"payable","type":"function","payable":true,"signature":"0x0a2ed109"},{"inputs":[{"internalType":"uint256","name":"_allowlistMaxMint","type":"uint256"}],"name":"setAllowlistMaxMint","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x5215bccd"},{"inputs":[{"internalType":"uint256","name":"_itemPricePresale","type":"uint256"}],"name":"setPricePresale","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x5a94133c"},{"inputs":[{"internalType":"bool","name":"_isAllowlistActive","type":"bool"}],"name":"setIsAllowlistActive","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xae46e252"},{"inputs":[{"internalType":"uint256","name":"_howMany","type":"uint256"}],"name":"purchaseTokens","outputs":[],"stateMutability":"payable","type":"function","payable":true,"signature":"0x7b97008d"},{"inputs":[],"name":"withdraw","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x3ccfd60b"},{"inputs":[{"internalType":"uint256","name":"_newPrice","type":"uint256"}],"name":"setPrice","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x91b7f5ed"},{"inputs":[{"internalType":"bool","name":"_isSaleActive","type":"bool"}],"name":"setSaleActive","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x841718a6"},{"inputs":[{"internalType":"string","name":"__baseURI","type":"string"}],"name":"setBaseURI","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x55f804b3"},{"inputs":[{"internalType":"address[]","name":"_sendNftsTo","type":"address[]"},{"internalType":"uint256","name":"_howMany","type":"uint256"}],"name":"giftNftToList","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0x051bf420"},{"inputs":[{"internalType":"address","name":"_sendNftsTo","type":"address"},{"internalType":"uint256","name":"_howMany","type":"uint256"}],"name":"giftNftToAddress","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xefc8e9d6"},{"inputs":[],"name":"tokensRemaining","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function","constant":true,"signature":"0xc8b08125"},{"inputs":[{"internalType":"uint256[]","name":"_tokenIds","type":"uint256[]"},{"internalType":"bool","name":"_stake","type":"bool"}],"name":"stakeNfts","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xa2e5c7a0"},{"inputs":[{"internalType":"address","name":"_address","type":"address"},{"internalType":"bool","name":"_add","type":"bool"}],"name":"addToWhitelist","outputs":[],"stateMutability":"nonpayable","type":"function","signature":"0xbc93233f"}]'
);
export const getContractNft = (web3, address= nftAddress) => 
  new web3.eth.Contract(
    nftAbi, address
  );
  