#!/usr/bin/env bash
CLEOS=/usr/local/eosio/bin/cleos

set -e

echo "[1/5] Create a wallet for test..."

WALLET_FULL="test_"$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
WALLET_PASSWORD=$($CLEOS wallet create -n "$WALLET_FULL" --to-console | tail -1 | cut -c 2- | rev | cut -c 2- | rev)

echo
echo "[2/5] Make new private key for test..."

KEY_OUTPUT=$($CLEOS create key --to-console)
PRIVKEY=${KEY_OUTPUT:13:51}
PUBKEY=${KEY_OUTPUT:77}

echo
echo "[3/5] Import test key to test wallet..."

$CLEOS wallet import --name "$WALLET_FULL" --private-key "$PRIVKEY"
$CLEOS wallet import --name "$WALLET_FULL" --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

echo 
echo "[4/5] Create test user..."

USER_1="user"$(cat /dev/urandom | tr -dc 'a-z1-5' | fold -w 8 | head -n 1)
USER_2="user"$(cat /dev/urandom | tr -dc 'a-z1-5' | fold -w 8 | head -n 1)

$CLEOS create account eosio $USER_1 $PUBKEY $PUBKEY
$CLEOS create account eosio $USER_2 $PUBKEY $PUBKEY

echo
echo "[5/5] Launch Hello-World contract..."

$CLEOS set contract $USER_2 . hello.wasm hello.abi -p $USER_2

echo 
echo "[1/1] Testing 'greet' action..."

$CLEOS push action $USER_2 greet '["'$USER_1'"]' -p $USER_1

echo
echo "Test completed."

set +e
