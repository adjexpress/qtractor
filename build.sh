#!/usr/bin/env bash

if [[ $1 == 'debug' || $1 == 'release' ]]; then
    mkdir -p build/$1
    cd build/$1
    qmake ../../traqtor.pro -spec linux-g++ CONFIG+=$1 CONFIG+=qml_debug
    make -j4
elif [[ $1 == 'clean' ]]; then
    if [[ -e build/debug ]]; then
        cd build/debug
        make clean -j4
    else
        echo "There's no debug dir."
    fi
else
    echo "Inappropriate arguments!"
fi
