#!/usr/bin/env bash

echo Enter Your Mainnet RPC URL:
echo Example: "https://eth-mainnet.alchemyapi.io/v2/XXXXXXXXXX"
read -s rpc

curl -s -X POST --data '{"jsonrpc":"2.0","method":"net_version","params":[],"id":67}' $rpc | \
grep -q '\"result\":\"1\"' && echo "Confirming Mainnet RPC Endpoint via chainId" || exit 1;

# Read the contract name
echo Which contract do you want to deploy \(eg Greeter\)?
read contract

# Read the constructor arguments
# echo Enter constructor arguments separated by spaces \(eg 1 2 3\):
# read -ra args

forge create ./src/${contract}.sol:${contract} -i --rpc-url $rpc # --constructor-args ${args}
