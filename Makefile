default:
	@echo "Compiling \033[1;37mhello.cpp\033[0m to web assembly files...\c"
	@/usr/bin/env eosio-cpp -abigen hello.cpp -o hello.wasm
	@echo " \033[1;32mFinished.\033[0m"

clean:
	-@rm -rf *.wasm 2> /dev/null || true
	-@rm -rf *.abi 2> /dev/null || true
	@echo "All .wasm, .abi files are removed."

test:
	@echo "Before do test, please make sure that"
	@echo "    (1) you run BIOS contract on testnet before test this contract"
	@echo "    (2) you properly set config.ini of nodeos to print stdout"
	@echo
	@/usr/bin/env bash tester.sh
