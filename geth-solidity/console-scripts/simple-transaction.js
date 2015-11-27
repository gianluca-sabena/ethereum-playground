


if (eth.accounts.length < 2 ) {
  console.log('A transaction requires 2 accounts...');
  console.log('Create an account with password:password');
  personal.newAccount("password")
} else {
  //personal.unlockAccount(primary, "01");
  sender = eth.accounts[0];
  receiver = eth.accounts[1];
  amount = web3.toWei(0.01, "ether")
  senderBalance = web3.fromWei(eth.getBalance(sender), "ether");
  receiverBalance = web3.fromWei(eth.getBalance(receiver), "ether");
  console.log("Sender id: "+sender+" balance: "+senderBalance);
  console.log("Receiver id: "+receiver+" balance: "+receiverBalance);
  tx = eth.sendTransaction({from:sender, to:receiver, value: amount});
  console.log("Create transaction: "+tx);
  console.log("Start mining a block... Check server log...");
  miner.start(1);
  admin.sleepBlocks(1);
  miner.stop();
  senderBalance = web3.fromWei(eth.getBalance(sender), "ether");
  receiverBalance = web3.fromWei(eth.getBalance(receiver), "ether");
  console.log("Sender balance: "+senderBalance);
  console.log("Receiver balance: "+receiverBalance);
}