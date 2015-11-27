#!/bin/bash

echo "Starting geth..."

if [[ -z "$NODE_ID" ]]; then
  echo "Error - Env NODE_ID is required"
  exit -1
fi

ROOT_DIR=/tmp/ethereum
PORT=303${NODE_ID}
RPCPORT=81${NODE_ID}
GETH=/opt/go-ethereum/build/bin/geth
ETH_OPT="   "

datadir=${ROOT_DIR}/data/${NODE_ID}
mkdir -p $datadir
mkdir -p ${ROOT_DIR}/keystore/${NODE_ID}
$GETH --datadir $datadir --password <(echo -n ${NODE_ID}) account new

# Since --bootnode didn't work, need to delay an rpc call to join node 0

if [[ -n "${GETH_NODE_01_PORT_8101_TCP_ADDR}" && -n "${GETH_NODE_01_PORT_8101_TCP_PORT}" ]]; then
    sleep 10 # whait node0 to boot
    BOOT_NODE=$( curl -sS http://${GETH_NODE_01_PORT_8101_TCP_ADDR}:${GETH_NODE_01_PORT_8101_TCP_PORT}  -X POST --data '{"jsonrpc":"2.0","method":"admin_nodeInfo","params":[]}' | grep -o -E "enode:([^\?]*)" | sed "s/\[\:\:\]/${GETH_NODE_01_PORT_8101_TCP_ADDR}/g" )
    echo " * I am a slave node - Joining master node: ${BOOT_NODE}"
    CURL="curl -sS http://127.0.0.1:${RPCPORT} -X POST --data '{\"jsonrpc\":\"2.0\",\"method\":\"admin_addPeer\",\"params\":[\"${BOOT_NODE}\"]}' "
    echo " * Curl command: $CURL"
    (sleep 15 && /bin/bash -c "$CURL" )&
else
    echo " * I am the first node"
fi

$GETH --datadir $datadir \
  --port $PORT  \
  --unlock 0 \
  --password <(echo -n ${NODE_ID}) \
  --verbosity 4  \
  --networkid 123 \
  --genesis /opt/genesis.json \
  --nodiscover --autodag \
  --rpcapi admin,db,debug,eth,miner,net,personal,shh,txpool,web3  \
  --rpc --rpcport $RPCPORT --rpcaddr 0.0.0.0  --rpccorsdomain '*' ${ETH_OPT}


