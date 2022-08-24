#!/bin/bash
source  $(dirname "$0")/.common.sh

IMAGE="gitlab.ika.rwth-aachen.de:5050/automated-driving/docker/tensorflow:${TF_VERSION}-py-cpp${GPU_POSTFIX}"

echo "Building ${IMAGE} ... "
docker build --build-arg TF_VERSION=${TF_VERSION} --build-arg JOBS=${JOBS} --build-arg GPU_POSTFIX=${GPU_POSTFIX} -t ${IMAGE} ${DOCKER_DIR} | tee ${LOG_FILE}
