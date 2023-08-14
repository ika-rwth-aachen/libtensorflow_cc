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

source  $(dirname "$0")/.common.sh

CPU_GPU_POSTFIX=${GPU_POSTFIX:--cpu}
BUILD_DIR=${DOWNLOAD_DOCKERFILE_DIR}
BSD_SED_ARG=""
if [ "$(uname -s)" = "Darwin" ]; then
    BSD_SED_ARG=".bak"
fi

if [ "$ARCH" = "amd64" ]; then
    DOCKERFILE=${DOWNLOAD_DOCKERFILE_DIR}/dockerfiles/devel${CPU_GPU_POSTFIX}.Dockerfile
elif [ "$ARCH" = "arm64" ]; then
    DOCKERFILE=${DOWNLOAD_DOCKERFILE_DIR}/dockerfiles/arm64v8/devel-cpu-arm64v8.Dockerfile
    if [ "$TF_VERSION" = "2.8.4" ]; then
        sed -i "s/ubuntu:\${UBUNTU_VERSION}/nvcr.io\/nvidia\/l4t-tensorflow:r34.1.1-tf2.8-py3/" $DOCKERFILE
    else
        sed -i "s/ubuntu:\${UBUNTU_VERSION}/nvcr.io\/nvidia\/l4t-tensorflow:r35.1.0-tf2.9-py3/" $DOCKERFILE
    fi
fi

# replace sklearn (deprecated) with scikit-learn
# https://pypi.org/project/sklearn/
sed -i $BSD_SED_ARG "s/sklearn/scikit-learn/" $DOCKERFILE

echo "Building ${IMAGE_DEVEL_ARCH} ... "
docker build -t ${IMAGE_DEVEL_ARCH} -f ${DOCKERFILE} ${BUILD_DIR} | tee ${LOG_FILE}
