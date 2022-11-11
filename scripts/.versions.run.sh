#!/bin/bash
# ==============================================================================
# MIT License
# Copyright 2022 Institute for Automotive Engineering of RWTH Aachen University.
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ==============================================================================

PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')

if [[ $(command -v python) ]]; then
    TENSORFLOW_PYTHON_VERSION=$(python3 -c "exec(\"try:\n  import os; os.environ['TF_CPP_MIN_LOG_LEVEL'] = '1'; import tensorflow as tf; print(tf.__version__);\n\rexcept ImportError:\n  pass\")" 2> /dev/null)
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

if [[ -f /usr/include/$(uname -m)-linux-gnu/NvInferVersion.h ]]; then
    TENSORRT_MAJOR=$(cat /usr/include/$(uname -m)-linux-gnu/NvInferVersion.h | grep "#define NV_TENSORRT_MAJOR" | sed "s/#define NV_TENSORRT_MAJOR //" | sed "s#//.*##" | sed "s/ //")
    TENSORRT_MINOR=$(cat /usr/include/$(uname -m)-linux-gnu/NvInferVersion.h | grep "#define NV_TENSORRT_MINOR" | sed "s/#define NV_TENSORRT_MINOR //" | sed "s#//.*##" | sed "s/ //")
    TENSORRT_PATCH=$(cat /usr/include/$(uname -m)-linux-gnu/NvInferVersion.h | grep "#define NV_TENSORRT_PATCH" | sed "s/#define NV_TENSORRT_PATCH //" | sed "s#//.*##" | sed "s/ //")
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
