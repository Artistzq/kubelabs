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
cd ~/Documents/k8s-proj/cni-test
kind create cluster --name $name --config kind-config.yaml
kubectl cluster-info --context kind-$name
kind load docker-image go-hello-world-image:v0.0.1 --name $name

