// Simple contract
//
// Based on this tutorial - https://github.com/ethereum/go-ethereum/wiki/Contract-Tutorial
//


// --- Solidity contract with inheritance --- --- --- --- --- --- --- ---

// contract mortal {
//     /* Define variable owner of the type address*/
//     address owner;
//     /* this function is executed at initialization and sets the owner of the contract */
//     function mortal() { owner = msg.sender; }
//     /* Function to recover the funds on the contract */
//     function kill() { if (msg.sender == owner) suicide(owner); }
// }
// contract greeter is mortal {
//     /* define variable greeting of the type string */
//     string greeting;
//     /* this runs when the contract is executed */
//     function greeter(string _greeting) public {
//         greeting = _greeting;
//     }
//     /* main function */
//     function greet() constant returns (string) {
//         return greeting;
//     }
// }

// Init solidity compiler
admin.setSolc("/opt/solidity/build/solc/solc")

sender = eth.accounts[0];
senderBalance = web3.fromWei(eth.getBalance(sender), "ether");
console.log("Sender id: "+sender+" balance: "+senderBalance);

// One line contract code
greeterSource = 'contract mortal { address owner; function mortal() { owner = msg.sender; } function kill() { if (msg.sender == owner) suicide(owner); } } contract greeter is mortal { string greeting; function greeter(string _greeting) public { greeting = _greeting; } function greet() constant returns (string) { return greeting; } }'
greeterCompiled = web3.eth.compile.solidity(greeterSource)
greeterContract = web3.eth.contract(greeterCompiled.greeter.info.abiDefinition);

_greeting = "Hello World!"

//https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethcontract
greeter = greeterContract.new(_greeting,{from:web3.eth.accounts[0], data: greeterCompiled.greeter.code, gas: 1000000, gasPrice: 1}, function(e, contract){
  if(!e) {

    if(!contract.address) {
      console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be mined...");
      console.log("Start mining a block... Check server log...");
    } else {
      console.log("Contract mined! Address: " + contract.address);
      console.log("Contract info - Address: " + greeter.address + " - transactionHash: " + greeter.transactionHash)
      console.log("Call your contract")
      console.log(contract.greet())
    }
  } else {
    console.log("Error: " + e)
  }
})
miner.start(1);
admin.sleepBlocks(1);
miner.stop();
senderBalance = web3.fromWei(eth.getBalance(sender), "ether");
console.log("Sender id: "+sender+" balance: "+senderBalance);