#!/bin/bash
set -e

g++ -I /usr/local/include/tensorflow \
    hello_tensorflow.cpp \
    -ltensorflow_cc -ltensorflow_framework -lprotobuf \
    -o hello_tensorflow

./hello_tensorflow