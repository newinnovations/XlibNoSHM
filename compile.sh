#!/bin/bash

if [[ -z ${OWNER} ]]; then
    echo "Should be run inside docker"
    exit
fi

apt-get update

apt-get install -y --no-install-recommends \
    gcc libc-dev libxext-dev gcc-multilib

cc -shared -o XlibNoSHM-$1-64.so XlibNoSHM.c
cc -m32 -shared -o XlibNoSHM-$1-32.so XlibNoSHM.c

chown ${OWNER} XlibNoSHM*.so
