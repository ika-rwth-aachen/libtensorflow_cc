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

ARCH=$(uname -m)

UBUNTU_VERSION=$(. /etc/os-release; echo $VERSION_ID)

GCC_VERSION=$(gcc -dumpfullversion)

if [[ $(command -v bazel) ]]; then
    BAZEL_VERSION=$(bazel version 2> /dev/null | grep "Build label" | awk '{print $3}')
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
Architecture:           $ARCH
Ubuntu:                 $UBUNTU_VERSION
GCC:                    $GCC_VERSION
Bazel:                  $BAZEL_VERSION
CUDA:                   $CUDA_VERSION
cuDNN:                  $CUDNN_VERSION
TensorRT:               $TENSORRT_VERSION
EOF
