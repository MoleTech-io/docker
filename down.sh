#! /bin/bash
if [ -z "$1" ] ;then
echo "help command:"
echo "./down.sh redis"
echo "./down.sh mongo"
echo "./down.sh stone"
exit
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
removeRedis() {
    docker rm -f redis1
    docker rm -f redis2
    docker rm -f redis3
    docker rm -f redis4
    docker rm -f redis5
    docker rm -f redis6
    echo "removed redis"
}

removeMongo() {
    docker rm -f mongodb1
    docker rm -f mongodb2
    docker rm -f mongodb3
    echo "removed mongo"
}

removeStone(){
    docker rm -f stone
    echo "remove stone"
}

removeBo(){
    docker rm -f bo
    echo "remove bo"
}

removeNetwork(){
    docker swarm leave --force
    docker network remove wallet_internal
    docker network remove wallet_service
    docker network ls
    echo "remove docker network"
}

removeData() {
    rm -rf $DIR/mongo/dat/
    echo " remove datas from $DIR/mongo/dat/"
    rm -rf $DIR/zookeeper/zoo1/
    echo " remove datas from $DIR/zookeeper/zoo1/"
    rm -rf $DIR/zookeeper/zoo2/
    echo " remove datas from $DIR/zookeeper/zoo1/"
    rm -rf $DIR/zookeeper/zoo3/
    echo " remove datas from $DIR/zookeeper/zoo3/"

    rm -rf $DIR/redis/dat/redis1/ 
    echo " remove data from $DIR/redis/dat/redis1/"
    rm -rf $DIR/redis/dat/redis2/ 
    echo " remove data from $DIR/redis/dat/redis2/"
    rm -rf $DIR/redis/dat/redis3/ 
    echo " remove data from $DIR/redis/dat/redis3/"
    rm -rf $DIR/redis/dat/redis4/ 
    echo " remove data from $DIR/redis/dat/redis4/"
    rm -rf $DIR/redis/dat/redis5/ 
    echo " remove data from $DIR/redis/dat/redis5/"
    rm -rf $DIR/redis/dat/redis6/ 
    echo " remove data from $DIR/redis/dat/redis6/"
}

if [  "$1" = 'network' ]  ; then
    removeNetwork
    exit
fi

if [  "$1" = 'redis' ]  ; then
    removeRedis
    exit
fi

if [  "$1" = 'mongo' ]  ; then
    removeMongo
    exit
fi

if [  "$1" = 'stone' ]  ; then
    removeStone
    exit
fi

if [  "$1" = 'bo' ]  ; then
    removeBo
    exit
fi

if [  "$1" = 'data' ]  ; then
    removeData
    exit
fi

if [  "$1" = 'all' ]  ; then
    removeRedis
    removeMongo
    removeStone
    removeNetwork
    removeData
    removeBo
    exit
fi