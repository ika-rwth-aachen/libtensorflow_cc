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

EXPORT_DIR=${REPOSITORY_DIR}/libtensorflow-cc
CONTAINER_FILE="libtensorflow-cc_${TF_VERSION}${GPU_POSTFIX}.deb"
EXPORT_FILE="libtensorflow-cc_${TF_VERSION}${GPU_POSTFIX}_${ARCH}.deb"
STAGE="deb-package"

echo "Building ${IMAGE_LIBTENSORFLOW_CC_ARCH} ... "
docker build --build-arg TARGETARCH=$ARCH --build-arg TF_VERSION=${TF_VERSION} --build-arg JOBS=${JOBS} --build-arg GPU_POSTFIX=${GPU_POSTFIX} --build-arg TF_CUDA_COMPUTE_CAPABILITIES=${TF_CUDA_COMPUTE_CAPABILITIES} --target ${STAGE} -t ${IMAGE_LIBTENSORFLOW_CC_ARCH} ${DOCKER_DIR} | tee ${LOG_FILE}

echo "Exporting to $(realpath ${EXPORT_DIR})/${EXPORT_FILE} ... "
TMP_CONTAINER=$(docker create ${IMAGE_LIBTENSORFLOW_CC_ARCH})
docker cp ${TMP_CONTAINER}:/${CONTAINER_FILE} ${EXPORT_DIR}/${EXPORT_FILE}
docker rm -v ${TMP_CONTAINER}
