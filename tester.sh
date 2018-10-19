#!/usr/bin/env bash
CLEOS="/usr/bin/env cleos"

if [ ! -f hello.abi ]; then
    echo -e "Contract file not found. Enter 'make' to build the contract."
    exit 1    
fi

set -e

echo -e "\033[1;36m[1/5] Create a wallet for test...\033[0m"

WALLET_FULL="test_"$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
WALLET_PASSWORD=$($CLEOS wallet create -n "$WALLET_FULL" --to-console | tail -1 | cut -c 2- | rev | cut -c 2- | rev)

echo
echo -e "\033[1;36m[2/5] Make new private key for test...\033[0m"

KEY_OUTPUT=$($CLEOS create key --to-console)
PRIVKEY=${KEY_OUTPUT:13:51}
PUBKEY=${KEY_OUTPUT:77}

echo
echo -e "\033[1;36m[3/5] Import test key to test wallet...\033[0m"

$CLEOS wallet import --name "$WALLET_FULL" --private-key "$PRIVKEY"
$CLEOS wallet import --name "$WALLET_FULL" --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

echo 
echo -e "\033[1;36m[4/5] Create test user...\033[0m"

USER_1="user"$(cat /dev/urandom | tr -dc 'a-z1-5' | fold -w 8 | head -n 1)
USER_2="user"$(cat /dev/urandom | tr -dc 'a-z1-5' | fold -w 8 | head -n 1)

$CLEOS create account eosio $USER_1 $PUBKEY $PUBKEY
$CLEOS create account eosio $USER_2 $PUBKEY $PUBKEY

echo
echo -e "\033[1;36m[5/5] Launch Hello-World contract...\033[0m"

$CLEOS set contract $USER_2 . hello.wasm hello.abi -p $USER_2

echo 
echo -e "\033[1;36m[1/1] Testing 'greet' action...\033[0m"

$CLEOS push action $USER_2 greet '["'$USER_1'"]' -p $USER_1

echo
echo -e "\033[1;32mTest completed! Check nodeos.\033[0m"

set +e
