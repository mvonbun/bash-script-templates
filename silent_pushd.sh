#!/usr/bin/env bash

# silent pushd / popd
pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}
