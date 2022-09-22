#!/bin/bash
set -e

g++ -I /usr/local/include/tensorflow \
    hello_tensorflow.cpp \
    -o hello_tensorflow \
    -Wl,-rpath,/usr/local/lib/tensorflow:/usr/local/lib \
    /usr/local/lib/tensorflow/libtensorflow_cc.so \
    /usr/local/lib/libprotobuf.so

./hello_tensorflow
