#!/bin/bash

[ -f "${CONFIG_PATH}" ] || touch "${CONFIG_PATH}"

args=(
  --conf-path="${CONFIG_PATH}"
  --rpc-listen-port=6800
  --enable-rpc=true
  --listen-port=6801
  --dht-listen-port=6802
  --dir=${DOWNLOAD_PATH}
  --save-session=${LOG_DIR}/aria2.session
  --input-file=${LOG_DIR}/aria2.session
  --log=${LOG_DIR}/aria2.log
  "${RPC_SECRET:+--rpc-secret=$RPC_SECRET}"
)

umask 0002

/usr/sbin/aria2c ${args[*]}
