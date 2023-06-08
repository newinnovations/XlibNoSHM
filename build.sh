#!/usr/bin/env bash

TARGET="$1"

if [[ -z ${TARGET} ]]; then
    echo "./build.sh <ubuntu-release>"
    echo
    echo "ubuntu-release: bionic, focal, jammy, ..."
    exit
fi

docker run -it --rm \
    -v .:/opt/noshm \
    -w /opt/noshm \
    -e OWNER="$(id -u):$(id -g)" \
    ubuntu:${TARGET} /bin/bash -c "/opt/noshm/compile.sh ${TARGET}"
