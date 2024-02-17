#!/bin/bash

while getopts ":n:a:" opt; do
  case $opt in
    n) name="$OPTARG";;
    \?) echo "Invalid option -$OPTARG" >&2 ;;
  esac
done

echo "cluster-name: $name"

shift $((OPTIND-1))

# 处理可能存在的非选项参数

# set -e
# create
# export KIND_LOG_LEVEL=debug
cd ~/Documents/k8s-proj/hello
kind create cluster --name $name --config kind-config.yaml
# kubectl cluster-info --context kind-$name
# switch to created cluster
# kubectl config use-context kind-$name
kind load docker-image go-hello-world-image:v0.0.1 --name $name

# validate
# kubectl apply -f hello-deploy.yaml
# kubectl apply -f hello-service.yaml

# show info
# echo "Info"
# kubectl get nodes -owide
# kubectl get serivces -owide
# kubectl get pods -owide
