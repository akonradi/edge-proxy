#!/bin/sh

OUTPUT_DIR=.

if [ $# -eq 0 ]; then
  echo "No arguments provided..."
  echo "Using current directory as output location."
else
  OUTPUT_DIR=$1
fi

mkdir -p "${OUTPUT_DIR}/data/artifact/artifacts/gloo-system"
mkdir -p "${OUTPUT_DIR}/data/config/{gateways,proxies,upstreams,upstreamgroups,routetables,authconfigs,virtualservices,ratelimitconfigs}/gloo-system"
mkdir -p "${OUTPUT_DIR}/data/secret/secrets/{default,gloo-system}"
