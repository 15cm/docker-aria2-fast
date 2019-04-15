#!/bin/bash

umask 002

[ -f "${CONFIG_PATH} " ] || touch "${CONFIG_PATH}"

args=(
  --conf-path="${CONFIG_PATH}"
  --rpc-listen-port=6800
  --enable-rpc=true
  --listen-port=6801
  --dht-listen-port=6802
  --dir=/download
  --save-session=/var/log/aria2/aria2.session
  --input-file=/var/log/aria2/aria2.session
  --log=/var/log/aria2/aria2.log
  "${RPC_SECRET:+--rpc-secret=$RPC_SECRET}"
)

/usr/sbin/aria2c ${args[*]}
