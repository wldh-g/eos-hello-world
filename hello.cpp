#include <eosiolib/eosio.hpp>

using eosio::contract;
using eosio::print;
using eosio::name;

CONTRACT hello : public contract {

    public:
        using contract::contract;

        ACTION greet (name user) {
            print("Hello world, hello ", name{user}, "!");
        };

};

EOSIO_DISPATCH(hello, (greet));
