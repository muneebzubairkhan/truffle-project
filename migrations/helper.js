const fs = require('fs');
const networksConfig = require('../truffle-config');

// later add default values in params
const makeHelperCodeForUIDev = (network, contracts) => {
  let res = `// ${new Date().toLocaleString('en-US', {
    hour: 'numeric',
    minute: 'numeric',
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  })}
//  
// ${up(network)}:\n`;

  if (networksConfig.networks[network] === '') {
    throw new Error(
      'Hi Bro How are you? Please add 2 fields (explorerUrl, web3Provider) in your truffle config file.',
    );
  }

  let { explorerUrl, web3Provider } = networksConfig.networks[network];
  if (explorerUrl === undefined) {
    explorerUrl = ' ';
    console.log('Please provide explorerUrl in truffle config file');
  }
  if (web3Provider === undefined) {
    web3Provider = ' ';
    console.log('Please provide web3Provider in truffle config file');
  }

  res += makeExplorerLink(explorerUrl, contracts);
  res += '//\n//=========================\n\n';
  res += makeContractObjects(web3Provider, contracts);

  fs.writeFile('smart-contracts.js', res, (e) => e && console.log(e.message));
};

// capitalizeFirstLetter
const up = s => s.charAt(0).toUpperCase() + s.slice(1);

// send variable in input as {someVariable}
// obj is variables object (it contains variables)
const makeContractObjects = (web3Provider, obj) => {
  const boiledWeb3 = `
// if you want to do only get calls then you can use defaultWeb3.

import Web3 from 'web3';

export const defaultWeb3 = new Web3(
  '${web3Provider}'
);
  
  `;

  return (
    boiledWeb3 +
    Object.keys(obj)
      .map(varName =>
        boil(varName, stringify(obj[varName].abi), obj[varName].address),
      )
      .join('\n\n')
  );
};

const boil = (varName, abi, address) =>
  `
export const ${varName}Address = '${address}';
export const ${varName}Abi = JSON.parse(
  '${abi}'
);
export const getContract${up(
    varName,
  )} = ({web3= defaultWeb3, address= ${varName}Address}) => 
  new web3.eth.Contract(
    ${varName}Abi, address
  );
  `;

const makeExplorerLink = (explorerUrl = ' ', obj) => {
  const vars = Object.keys(obj);

  let data = '';
  vars.map(contractName => {
    data += `// ${up(contractName)} ${explorerUrl}${
      obj[contractName].address
    }\n`;
  });

  return data;
};

const stringify = JSON.stringify;

module.exports = { makeHelperCodeForUIDev };
