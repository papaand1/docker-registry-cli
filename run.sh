#!/bin/bash

if [ $# -lt 1 ]; then
  echo "Usage $0 commands"
fi

drCLIImage="docker-registory-cli"
drCLIVersion="1.0"

res=`docker images | grep $drCLIImage`
if [ ! -n "$res" ]; then
  docker build -t $drCLIImage:$drCLIVersion .
fi

docker run --name drcli --rm -it $drCLIImage:$drCLIVersion ruby docker-registry-cli.rb $@ 
