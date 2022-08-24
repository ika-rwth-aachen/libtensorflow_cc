#!/bin/bash
source  $(dirname "$0")/.common.sh

CPU_GPU_POSTFIX=${GPU_POSTFIX:--cpu}
DOCKERFILE=${DOWNLOAD_DOCKERFILE_DIR}/dockerfiles/devel${CPU_GPU_POSTFIX}.Dockerfile
BUILD_DIR=${DOWNLOAD_DOCKERFILE_DIR}
IMAGE="tensorflow/tensorflow:${TF_VERSION}-devel${GPU_POSTFIX}"

echo "Building ${IMAGE} ... "
docker build -t ${IMAGE} -f ${DOCKERFILE} ${BUILD_DIR} | tee ${LOG_FILE}
