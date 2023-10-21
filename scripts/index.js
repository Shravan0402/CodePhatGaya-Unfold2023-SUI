// import { getFullnodeUrl, SuiClient } from '@mysten/sui.js/client';
// import { getFaucetHost, requestSuiFromFaucetV0 } from '@mysten/sui.js/faucet';
// import { MIST_PER_SUI } from '@mysten/sui.js/utils';
 
// // replace <YOUR_SUI_ADDRESS> with your actual address, which is in the form 0x123...
// const MY_ADDRESS = '0x5f5f3cb4cdc41f4666ea62f111ff7f3ce7880927fd0660ad4e9be950bfd9cc9d';
 
// // create a new SuiClient object pointing to the network you want to use
// const suiClient = new SuiClient({ url: getFullnodeUrl('devnet') });
 
// // Convert MIST to Sui
// const balance = (balance) => {
// 	return Number.parseInt(balance.totalBalance) / Number(MIST_PER_SUI);
// };
 
// // store the JSON representation for the SUI the address owns before using faucet
// const suiBefore = await suiClient.getBalance({
// 	owner: MY_ADDRESS,
// });
 
// await requestSuiFromFaucetV0({
// 	// use getFaucetHost to make sure you're using correct faucet address
// 	// you can also just use the address (see Sui TypeScript SDK Quick Start for values)
// 	host: getFaucetHost('devnet'),
// 	recipient: MY_ADDRESS,
// });
 
// // store the JSON representation for the SUI the address owns after using faucet
// const suiAfter = await suiClient.getBalance({
// 	owner: MY_ADDRESS,
// });
 
// // Output result to console.
// console.log(
// 	`Balance before faucet: ${balance(suiBefore)} SUI. Balance after: ${balance(
// 		suiAfter,
// 	)} SUI. Hello, SUI!`,
// );






import { getFullnodeUrl, SuiClient } from '@mysten/sui.js/client';
import { TransactionBlock } from '@mysten/sui.js/transactions';
import { bcs } from "@mysten/sui.js/bcs";
import {Ed25519Keypair} from "@mysten/sui.js/keypairs/ed25519";

let keypair = Ed25519Keypair.deriveKeypairFromSeed("gorilla razor region acquire purse rug finger okay symbol system rose hybrid")
console.log(keypair.getPublicKey().toSuiAddress())

// use getFullnodeUrl to define Devnet RPC location
const rpcUrl = getFullnodeUrl('devnet');
 
// create a client connected to devnet
const client = new SuiClient({ url: rpcUrl });
 
const txb = new TransactionBlock();
//txb.transferObjects([coin], '0xaf16442516702c44f8ad0f80410320eb9ca9b20476d485e1d1296402e1cccc8f');
txb.setGasBudget(10000000);
// txb.moveCall({
//     target: "0xc79b4260729796f28bb078454e433f868d89afb9a674f3438a062151cb483daf::betting::createBet",
//     arguments: [txb.pure.u64(65)]
// })
//const [coin] = txb.splitCoins(txb.gas, [100]);
txb.moveCall({
    target: "0xc79b4260729796f28bb078454e433f868d89afb9a674f3438a062151cb483daf::betting::justBet",
    arguments: [txb.splitCoins(txb.gas, [100]), txb.object("0x14544fc45a155a519925c17644872457a340a42baaa52d7e9b097e21de789547")]
})
const result = await client.signAndExecuteTransactionBlock({
	transactionBlock: txb,
	signer: keypair,
	requestType: 'WaitForLocalExecution',
	options: {
		showEffects: true,
	},
});