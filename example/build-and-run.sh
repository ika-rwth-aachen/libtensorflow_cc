#!/bin/bash
set -e

g++ -I /usr/local/include/tensorflow \
    hello_tensorflow.cpp \
    -ltensorflow_cc -lprotobuf \
    -o hello_tensorflow

./hello_tensorflow