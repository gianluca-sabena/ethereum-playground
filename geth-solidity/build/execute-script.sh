#!/bin/bash
if [[ -z "${1}" ]];then
  echo "Usage ${0} script-name.js"
  exit -1
fi
SCRIPT=$( cat $1 )
geth --exec "$SCRIPT"  attach  rpc:http://gethcompose_eth-master_1:8101