
Ask questions or comments in this smart contract,
Whatsapp +923014440289
Telegram @thinkmuneeb
discord: timon#1213
email: muneeb.softblock@gmail.com

I'm Muneeb Zubair Khan



Test Case:
["0x5c6B0f7Bf3E7ce046039Bd8FABdfD3f9F5021678","0x17F6AD8Ef982297579C203069C1DbfFE4348c372"]
[1,2]


code StoreRoom:

const Migrations = artifacts.require("Migrations");
 const _Contract_1_ = artifacts.require("_Contract_1_");
   only run migrations on development network for seeing gas fee on mainnet
   telegram @thinkmuneeb

   if (network !== "development") return;

   await deployer.deploy(Migrations);

   try {
      await deployer.deploy(_Contract_1_);

      const _2 = artifacts.require("_2");
      const __2 = await deployer.deploy(_2);

      const _3 = artifacts.require("_3");
      const __3 = await deployer.deploy(_3);
   } catch (e) {
     e && console.log(e.message);
   }


 console.log(JSON.stringify({ contracts }, null, 4));