// NOTE: "eosio.hpp" includes <eosiolib/print.hpp>
#include <eosiolib/eosio.hpp>

using eosio::contract;
using eosio::print;
using eosio::name;

class hello : public contract {

    public:
        using contract::contract;

        void greet (account_name user) {
            print("Hello world, hello ", name{user}, "!");
        };

};

EOSIO_ABI(hello, (greet));
