#!/bin/bash
source  $(dirname "$0")/.common.sh

echo "Building ${IMAGE_CPP} ... "
docker build --build-arg TF_VERSION=${TF_VERSION} --build-arg JOBS=${JOBS} --build-arg GPU_POSTFIX=${GPU_POSTFIX} -t ${IMAGE_CPP} ${DOCKER_DIR} | tee ${LOG_FILE}
