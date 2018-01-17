#!/usr/bin/env bash
set -ex

npm link node-rdkafka
npm ls node-rdkafka
npm install

if [ ! -L "./node_modules/node-rdkafka" ]; then
  echo "Failure!"
  exit 1
fi
