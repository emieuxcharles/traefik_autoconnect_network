#!/bin/bash

###################
#### VARIABLES ####
###################
RUNNING=$(docker ps | grep _web | awk {'print $1'})
NETWORKS=$(for i in $RUNNING;do echo $(docker inspect $i --format='{{range $k,$v := .NetworkSettings.Networks}} {{$k}} {{end}}'); done)
TRAEFIK=$(docker ps | grep traefik | awk '{print $1}')
###################
#### FUNCTIONS ####
###################
show_help() {
  echo "
    Options:
      --help : show this message

      --all : reconnect given containers network to traefik

      --container : connect only given containers in args
          ex: traefik_connect_network.sh --container containerA_id containerB_id containerC_id
  "
}

if [ $# == 0 ];then
  show_help
elif [ $1 == "--help" ];then
  show_help
elif [ $1 == "--all" ];then
  for n in $NETWORKS;do 
    docker network connect $n $TRAEFIK
  done
elif [ $1 == "--container" ];then
  for i in ${@:2};do
    SELECTED_NETWORK=$(docker inspect $i --format='{{range $k,$v := .NetworkSettings.Networks}} {{$k}} {{end}}')
    docker connect $SELECTED_NETWORK $TRAEFIK
  done
fi
