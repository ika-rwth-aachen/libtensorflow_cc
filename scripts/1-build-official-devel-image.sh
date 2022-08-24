#!/bin/bash
source  $(dirname "$0")/.common.sh

CPU_GPU_POSTFIX=${GPU_POSTFIX:--cpu}
DOCKERFILE=${DOCKERFILE_DIR}/dockerfiles/devel${CPU_GPU_POSTFIX}.Dockerfile
BUILD_DIR=${DOCKERFILE_DIR}
IMAGE="tensorflow/tensorflow:${TF_VERSION}-devel${GPU_POSTFIX}"

echo "Building ${IMAGE} ... "
docker build -t ${IMAGE} -f ${DOCKERFILE} ${BUILD_DIR} | tee ${LOG_FILE}
