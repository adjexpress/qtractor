#!/usr/bin/env bash

if [[ $1 == 'debug' || $1 == 'release' ]]; then
    mkdir -p build/$1
    cd build/$1
    qmake ../../traqtor.pro -spec linux-g++ CONFIG+=$1 CONFIG+=qml_debug
    make -j4
    if [[ $? -eq 0 ]]; then
        echo -e "\n---> Output built in `pwd`"
    fi
    cd ../..
elif [[ $1 == 'clean' ]]; then
    if [[ -e build/debug ]]; then
        cd build/debug
        make clean -j4
        if [[ $? -eq 0 ]]; then
            echo -e "\n---> Clean done."
        fi
        cd ../..
    else
        echo "---> There's no debug dir."
    fi
elif [[ $1 == 'run' ]]; then
    if [[ -e build/debug/traqtor/traqtor ]]; then
        './build/debug/traqtor/traqtor'
    else
        echo "---> There isn't file (./build/debug/traqtor/traqtor) to run"
    fi
else
    echo "---> Inappropriate commands!"
    echo "---> Available commands: debug | release | clean | run | debug run | release run"
fi


if [[ $1 == 'debug' || $1 == 'release' && $2 == 'run' ]]; then
    if [[ -e build/$1/traqtor/traqtor ]]; then
        "./build/$1/traqtor/traqtor"
    else
        echo "---> There isn't file (./build/$1/traqtor/traqtor) to run"
    fi
fi
