# Intro
Docker image of [aria2-fast](https://aur.archlinux.org/packages/aria2-fast).

# Usage
## Volumes
- `/config`: Aria2c reads config file from `/config/aria2.conf`
- `/downloads`: Aria2c downloads to `/downloads/default` by default. `aria2.session` is saved at `/downloads/aria2.session`.

## ENV Vars
- `TZ`: timezone
- `PUID`: User id Aria2c will be run as
- `PGID`: Group id Aria2c will be run as
- `RPC_SECRET`: Overwrite the rpc secret specified in the config file

## Ports
- 6800: for jsonrpc
- 6801: for BT
- 6802: for BT DHT
