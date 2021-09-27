### Deployed to ETH Mainnet
Presale https://etherscan.io/address/0x7b58c75cb67030221720e0b92c8b658164079add#code

Token https://etherscan.io/address/0x31dfd905c9162f172c711cab91f6d580a088ae6f


### Client reuirements

Client on fiverr, May 23, 3:59 PM

Total Supply: 100000000000000
(100 quadtrillion 18 digits)

5% burn on each transfer
1% on each trafer gets shared between token holders

decimals: 18

ticker: SAFEKING

owner 95%
bsc address

approve spender 5%
bsc address

I neeed the contract to be verified on bsc scan

i need it fast within 24 hours can u do it?

### Commands
    yarn
    ganache-cli
    truffle test

### todo
    * test for participants

### Client Requirements

The Vault:
The vault is an smartcontract/ wallet where all the locked tokens for the launched projects are placed.
We a ui user interface for the token's creators who wish to place their token on the launchpad. This is where they can lock tokens in the vault, liquidity tokens and team tokens/developer wallet funds. The vault needs to be multi signed, with one party should be us in the parent network and the second signature is the token creator/developers.
Vault specific details:
•	Implement smart contracts for liquidity lock.
•	Liquidity lock – a locking time mechanism (ex. 1 month, 3 months, 4 months). A dedicated wallet address/LP address for the liquidity pool.
•	Implement a trigger on the backend for "x.token" network to freeze everything instantly in case of malicious activity.


Token creator UI.
Customers/developers who want to deploy smart contracts on the LaunchPad can do it themselves through the token vault UI. Basically, as easy as input the data, then wait for us to verify the information and check that everything is legit. Multi sig the tokens, and then the customer would be ready for launch.
KYB for the token to show different security tiers, 3 tiers total with 1 being least security and 3 being most secure.
After the token has launched, the token creator should be able to control a few things from the token creator ui, for their token. (Make a “Close of Project/Disband project” option from the ui.This would stop the token from showing up or marketing opportunities in any way. Gives out a warning to on the ShieldPad about the closing of the project. The closing time period would need to be at least minimum 3 months).

We need a way to whitelist wallet addresses for the ICOs.
We need a way to whitelist token addresses which hold specific tokens(x.token) of our choosing. People need to hold a specific amount of the "x.token"  to be able to participate in the ICO, in the different tiers. People need to hold x amount and have held it for x amount of time to be whitelisted. Please make this adjustable.

We can do 2 types of whitelisting, a private one and a public one. 
Private is for long time "x.token" holders. And the public one is for regular "x.token" holders. A VIP one, and one regular.
Token creators should have the option to whitelist addresses they want on the list as well. (Needs to be an option in the token launchpad dashboard UI).
The size of the ICO which needs to be reached before the token launch, should maybe be decided by "x.token" network, since we need to have enough tokens for our holders to buy in the ICOs.

Security:
Design contracts to be safe and secure, backend would also need to be safe from attack as well.
