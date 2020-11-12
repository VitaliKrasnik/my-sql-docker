#!/bin/bash

db_cont_name="mysql_db"


function getContainerId(){
   container_name=$1
   local string=$(docker ps | grep $container_name)
   value="$(cut -d' ' -f1 <<<"$string")"
   echo ${value##*|}
}

function copyFolderInDataBase() {
   local db_docker_id=$1
   docker cp ./db-data/. $db_docker_id:/var/lib/mysql/
}

function copyFolderFromDumpToDataBase() {
   local db_docker_id=$1
   docker cp ./backup/db-data/. $db_docker_id:/var/lib/mysql/
}

function copyFolderFromDataBase() {
   local db_docker_id=$1
   docker cp $db_docker_id:/var/lib/mysql/. ./backup/db-data/
}

echo "Starting container "
docker-compose up -d
echo "Waiting container is loaded..."
sleep 10s
echo "I hope it was.."
db_docker_id=$(getContainerId $db_cont_name)
echo "The db_docker_id is: $db_docker_id"
echo "Installation started ... "
echo "The script is stoping the container"
docker-compose stop
echo "The script is coping the files  'backup/db-data' -> 'db container'"
copyFolderFromDumpToDataBase "$db_docker_id"
echo "The script is launching the container"
docker-compose start