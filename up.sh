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
    docker network create --driver=overlay --attachable wallet_service --subnet=10.0.10.0/24
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

initRedisReplica(){
    docker exec -it redis1 redis-cli --cluster create 10.0.9.8:7000 10.0.9.9:7000 10.0.9.10:7000 10.0.9.11:7000 10.0.9.12:7000 10.0.9.13:7000 --cluster-replicas 1 --cluster-yes
    docker exec -it redis1 redis-cli -p 7000 cluster nodes
    echo "redis cluster is created"
}

statusMongoReplica(){
    if grep -q "mongodb1" /etc/hosts; then
        echo "mongodb1 exists in /etc/hosts ok!"
    else
        echo "127.0.0.1 mongodb1" >> /etc/hosts;
    fi
    
    if grep -q "mongodb2" /etc/hosts; then
        echo "mongodb2 exists in /etc/hosts ok!"
    else
        echo "127.0.0.1 mongodb2" >> /etc/hosts;
    fi

    if grep -q "mongodb3" /etc/hosts; then
        echo "mongodb3 exists in /etc/hosts ok!"
    else
        echo "127.0.0.1 mongodb3" >> /etc/hosts;
    fi
    mongo mongodb://mongodb1:25015 $DIR/mongo/replica-status.js
    mongo mongodb://mongodb2:25016 $DIR/mongo/replica-status.js
}

# execute
if [  "$1" = 'network' ] && [  "$2" = 'list' ]  ; then
    docker network inspect wallet_internal list
    docker network inspect wallet_service list
    exit
fi

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

if [  "$1" = 'all' ]  ; then
    initNetWork
    startMongo
    startRedis
    sleep 2
    initRedisReplica
    sleep 8
    statusMongoReplica
    # startStone
    exit
fi