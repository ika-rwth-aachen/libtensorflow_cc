#!/bin/bash
set -e

apt update && apt install -y cmake
cmake -S . -B build
cmake --build build
./build/hello_tensorflow
