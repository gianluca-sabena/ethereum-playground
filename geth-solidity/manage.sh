#! /bin/bash
#
NAME="geth-solidity"
TAG="ethereum-dev/${NAME}:latest"

NODE_ID="01"

OPT=" -p 303${NODE_ID}:303${NODE_ID} -p 81${NODE_ID}:81${NODE_ID} "

# ---
SCRIPT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DKHOST=$( expr "${DOCKER_HOST}" : 'tcp://\([0-9.]*\)' )
DKHOST=${DKHOST:=127.0.0.1}


case "$1" in
  build)
    cd ${SCRIPT_PATH}
    cp -r ../console-scripts ./
    docker -D build -t="${TAG}" .
    rm -rf console-scripts/*
    rmdir console-scripts
  ;;
  run)
    docker run ${OPT} --rm -i -t --name "${NAME}" "${TAG}" /opt/start.sh
  ;;
  bash-run)
    docker run --rm -i -t --name "${NAME}" "${TAG}" /bin/bash
  ;;
  bash-exec)
    docker exec -t -i $2 /bin/bash
  ;;
  stop)
    docker stop ${NAME}
  ;;
  push)
    echo "Push to registry: ${TAG}"
    docker push ${TAG}
  ;;
  eth-console-node-01)
    docker run --rm -i -t "${TAG}"   /opt/go-ethereum/build/bin/geth attach rpc:http://${DKHOST}:8101
  ;;
  eth-console-node-02)
    docker run --rm -i -t "${TAG}"   /opt/go-ethereum/build/bin/geth attach rpc:http://${DKHOST}:8102
  ;;
  eth-console-node-03)
    docker run --rm -i -t "${TAG}"   /opt/go-ethereum/build/bin/geth attach rpc:http://${DKHOST}:8103
  ;;
  rsc)
    CONTAINERS=$(docker ps -a -q)
    if [[ -n "${CONTAINERS}" ]]; then
      echo " * Remove stopped containers: $CONTAINERS"
      docker rm ${CONTAINERS}
    else
      echo " * No stopped containers"
    fi
  ;;
  rui)
    IMAGES=$(docker images | grep "^<none>" | awk '{print $3}')
    if [[ -n "$IMAGES" ]]; then
      echo " * Remove untagged images: ${IMAGES}"
      docker rmi $IMAGES
    else
      echo " * No untagged images"
    fi
  ;;
  *)
    echo " Docker image: ${TAG}"
    echo " use ${0} [ build | run | stop | bash-run | bash-exec | eth-console-node-01 | eth-console-node-02 | eth-console-node-03 | rui | rsc ] "
    exit 0
    ;;
esac