#!/bin/bash

rm -rf ~/.yoda

# config chain id
yoda config chain-id odin

# add validator to yoda config
yoda config validator $(odind keys show $1 -a --bech val --keyring-backend test)

# setup execution endpoint
yoda config executor "rest:https://iv3lgtv11a.execute-api.ap-southeast-1.amazonaws.com/live/master?timeout=10s"

# setup broadcast-timeout to yoda config
yoda config broadcast-timeout "5m"

# setup rpc-poll-interval to yoda config
yoda config rpc-poll-interval "1s"

# setup max-try to yoda config
yoda config max-try 5

echo "y" | odind tx oracle activate --from odin1nnfeguq30x6nwxjhaypxymx3nulyspsuja4a2x --chain-id odin --broadcast-mode block --keyring-backend test --node $2

yoda keys add reporter

# send odin tokens to reporters
for rec in $(yoda keys list -a)
do
  echo "y" | odind tx bank send $1 $rec 1000000loki --broadcast-mode block --keyring-backend test --chain-id odin --node $2
done

# add reporter to odinchain
echo "y" | odind tx oracle add-reporters $(yoda keys list -a) --from $1 --broadcast-mode block --keyring-backend test --chain-id odin --node $2

echo "Yoda configured"