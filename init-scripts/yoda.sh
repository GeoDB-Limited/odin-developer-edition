#!/bin/bash

rm -rf ~/.yoda

# config chain id
yoda config chain-id odin

# add validator to yoda config
yoda config validator $(bandcli keys show $1 -a --bech val --keyring-backend test)

# setup execution endpoint
yoda config executor "rest:https://iv3lgtv11a.execute-api.ap-southeast-1.amazonaws.com/live/master?timeout=10s"

# setup broadcast-timeout to yoda config
yoda config broadcast-timeout "5m"

# setup rpc-poll-interval to yoda config
yoda config rpc-poll-interval "1s"

# setup max-try to yoda config
yoda config max-try 5

echo "y" | bandcli tx oracle activate --from odin1nnfeguq30x6nwxjhaypxymx3nulyspsuja4a2x --chain-id odin --broadcast-mode block --keyring-backend test

for i in $(eval echo {1..$2})
do
  # add reporter key
  yoda keys add reporter$i
done

# send band tokens to reporters
echo "y" | bandcli tx multi-send 1000000loki $(yoda keys list -a) --from $1 --broadcast-mode block --keyring-backend test

# add reporter to bandchain
echo "y" | bandcli tx oracle add-reporters $(yoda keys list -a) --from $1 --broadcast-mode block --keyring-backend test

echo "Yoda configured"