EOSIOCPP=/usr/local/eosio/bin/eosiocpp

default:
	@echo "[1/2 Start] Compiling cpp files to web assembly (.wast) files..."

	$(EOSIOCPP) -o hello.wast hello.cpp
	
	@echo "[1/2 End] All files compiled successfully."
	@echo "[2/2 Start] Generating ABI files..."
	
	$(EOSIOCPP) -g hello.abi hello.cpp

	@echo "[2/2 End] All ABI files are generated."

clean:
	-@rm -rf *.was* 2> /dev/null || true
	-@rm -rf *.abi 2> /dev/null || true
	@echo "All .wast, .wasm, .abi files are removed."

test:
	@echo "Please make ensure that you run BIOS contract on testnet before test this contract."
	@echo
	@/usr/bin/env bash tester.sh
