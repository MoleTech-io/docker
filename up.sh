#! /bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
if [ -z "$1" ] ;then
echo "help command:"
echo "./up.sh network"
echo "./up.sh mongo"
echo "./up.sh redis"
exit
fi

initNetWork(){
    docker swarm init
    sleep 3
    docker network create --driver=overlay --attachable wallet_internal --subnet=10.0.9.0/24
    sleep 1
    docker network create --driver=overlay --attachable wallet_service
    sleep 1
    # check docker network status
    docker network ls 
    echo "init net work status, please check status"
}

startMongo(){
    if [ -e "$DIR/mongo/keyfile.key" ]; then
        echo "$DIR/mongo/keyfile.key exists. no need to generate keyfile"
    else 
        echo "$DIR/mongo/keyfile.key does not exist. Generate keyfile"
        openssl rand -base64 756 > $DIR/mongo/keyfile.key
        chmod 400 $DIR/mongo/keyfile.key
        chown 999 $DIR/mongo/keyfile.key
    fi
    docker-compose -f $DIR/mongo/docker-compose-init.yml up -d 
    echo "start mongo"
}

startStone(){
    if [[ "$(docker images -q stone:latest 2> /dev/null)" == "" ]]; then
        docker build -t stone $(dirname "$DIR")/stone/
    fi
    docker-compose -f $DIR/insight/docker-compose.yml up -d stone
    echo "start stone"
}

startRedis(){
    docker-compose -f $DIR/redis/docker-compose.yml up -d
    echo "start redis"
}

# execute
if [  "$1" = 'network' ]  ; then
    initNetWork
    exit
fi

if [  "$1" = 'mongo' ]  ; then
    startMongo
    exit
fi

if [  "$1" = 'stone' ]  ; then
    startStone
    exit
fi

if [  "$1" = 'redis' ]  ; then
    startRedis
    exit
fi