#! /bin/bash
#
# Manage docker-compose
#

SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DKHOST=$( expr "${DOCKER_HOST}" : 'tcp://\([0-9.]*\)' )
DKHOST=${DKHOST:=127.0.0.1}

case "$1" in
  ps)
    docker-compose ps
  ;;
  build)
    docker-compose build
  ;;
  rm)
    docker-compose rm
  ;;
  up)
    docker-compose up
  ;;
  stop)
    docker-compose stop
  ;;
  logs)
    docker-compose logs $2
  ;;
  bash)
    docker exec -t -i $2 /bin/bash
  ;;
  geth-console-node-01)
    docker run --rm -i -t "${TAG}"   /opt/go-ethereum/build/bin/geth attach rpc:http://${DKHOST}:8101
    docker exec -t -i  gethcompose_geth-node-01_1  /opt/go-ethereum/build/bin/geth --solc /opt/solidity/build/solc/solc attach rpc:http://127.0.0.1:8101
  ;;
  geth-console-node-02)
    docker exec -t -i  gethcompose_geth-node-02_1  /opt/go-ethereum/build/bin/geth --solc /opt/solidity/build/solc/solc attach rpc:http://127.0.0.1:8102
  ;;
  rsc)
    # remove stopped containers
    CONTAINERS=$(docker ps -a -q)
    if [[ -n "${CONTAINERS}" ]]; then
      echo " * Remove stopped containers: $CONTAINERS"
      docker rm ${CONTAINERS}
    else
      echo " * No stopped containers"
    fi
  ;;
  rui)
    # remove untagged image
    IMAGES=$(docker images | grep "^<none>" | awk '{print $3}')
    if [[ -n "$IMAGES" ]]; then
      echo " * Remove untagged images: ${IMAGES}"
      docker rmi $IMAGES
    else
      echo " * No untagged images"
    fi
  ;;
  *)
    echo " use ${0} [ build | ps | up | stop | logs 'docker-id' | bash 'docker-id' | rsc | rui | geth-console-node-01 ]"
    exit 0
    ;;
esac