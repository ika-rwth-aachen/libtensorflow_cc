#!/bin/bash

PYTHON_VERSION=$(python --version 2>&1 | awk '{print $2}')

if [[ $(command -v python) ]]; then
    TENSORFLOW_PYTHON_VERSION=$(python -c "exec(\"try:\n  import os; os.environ['TF_CPP_MIN_LOG_LEVEL'] = '1'; import tensorflow as tf; print(tf.__version__);\n\rexcept ImportError:\n  pass\")" 2> /dev/null)
fi

if [[ -f /usr/local/include/tensorflow/tensorflow/core/public/version.h ]]; then
    TENSORFLOW_CPP_MAJOR=$(cat /usr/local/include/tensorflow/tensorflow/core/public/version.h | grep "#define TF_MAJOR_VERSION" | sed "s/#define TF_MAJOR_VERSION //")
    TENSORFLOW_CPP_MINOR=$(cat /usr/local/include/tensorflow/tensorflow/core/public/version.h | grep "#define TF_MINOR_VERSION" | sed "s/#define TF_MINOR_VERSION //")
    TENSORFLOW_CPP_PATCH=$(cat /usr/local/include/tensorflow/tensorflow/core/public/version.h | grep "#define TF_PATCH_VERSION" | sed "s/#define TF_PATCH_VERSION //")
    TENSORFLOW_CPP_VERSION=$TENSORFLOW_CPP_MAJOR.$TENSORFLOW_CPP_MINOR.$TENSORFLOW_CPP_PATCH
fi

if [[ $(command -v protoc) ]]; then
    PROTOBUF_VERSION=$(protoc --version | awk '{print $2}')
fi

if [[ $(command -v nvcc) ]]; then
    CUDA_VERSION=$(nvcc --version | grep ^Cuda | awk '{print $6}' | sed 's/V//')
fi

if [[ -f /usr/include/cudnn_version.h ]]; then
    CUDNN_MAJOR=$(cat /usr/include/cudnn_version.h | grep "#define CUDNN_MAJOR" | sed "s/#define CUDNN_MAJOR //")
    CUDNN_MINOR=$(cat /usr/include/cudnn_version.h | grep "#define CUDNN_MINOR" | sed "s/#define CUDNN_MINOR //")
    CUDNN_PATCH=$(cat /usr/include/cudnn_version.h | grep "#define CUDNN_PATCHLEVEL" | sed "s/#define CUDNN_PATCHLEVEL //")
    CUDNN_VERSION=$CUDNN_MAJOR.$CUDNN_MINOR.$CUDNN_PATCH
fi

if [[ -f /usr/include/x86_64-linux-gnu/NvInferVersion.h ]]; then
    TENSORRT_MAJOR=$(cat /usr/include/x86_64-linux-gnu/NvInferVersion.h | grep "#define NV_TENSORRT_MAJOR" | sed "s/#define NV_TENSORRT_MAJOR //" | sed "s#//.*##" | sed "s/ //")
    TENSORRT_MINOR=$(cat /usr/include/x86_64-linux-gnu/NvInferVersion.h | grep "#define NV_TENSORRT_MINOR" | sed "s/#define NV_TENSORRT_MINOR //" | sed "s#//.*##" | sed "s/ //")
    TENSORRT_PATCH=$(cat /usr/include/x86_64-linux-gnu/NvInferVersion.h | grep "#define NV_TENSORRT_PATCH" | sed "s/#define NV_TENSORRT_PATCH //" | sed "s#//.*##" | sed "s/ //")
    TENSORRT_VERSION=$TENSORRT_MAJOR.$TENSORRT_MINOR.$TENSORRT_PATCH
fi

cat << EOF
Python:                 $PYTHON_VERSION
TensorFlow (Python):    $TENSORFLOW_PYTHON_VERSION
TensorFlow (C++):       $TENSORFLOW_CPP_VERSION
protobuf:               $PROTOBUF_VERSION
CUDA:                   $CUDA_VERSION
cuDNN:                  $CUDNN_VERSION
TensorRT:               $TENSORRT_VERSION
EOF
