#!/bin/bash

ARCH=$(uname -m)

UBUNTU_VERSION=$(. /etc/os-release; echo $VERSION_ID)

GCC_VERSION=$(gcc -dumpfullversion)

if [[ $(command -v bazel) ]]; then
    BAZEL_VERSION=$(bazel version 2> /dev/null | grep "Build label" | awk '{print $3}')
fi

cat << EOF
Architecture:           $ARCH
Ubuntu:                 $UBUNTU_VERSION
GCC:                    $GCC_VERSION
Bazel:                  $BAZEL_VERSION
EOF
