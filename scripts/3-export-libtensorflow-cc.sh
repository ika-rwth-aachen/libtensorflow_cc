#!/bin/bash
source  $(dirname "$0")/.common.sh

EXPORT_DIR=${REPOSITORY_DIR}/libtensorflow-cc
CONTAINER_FILE="libtensorflow-cc_${TF_VERSION}.deb"
EXPORT_FILE="libtensorflow-cc_${TF_VERSION}${GPU_POSTFIX}.deb"
IMAGE="gitlab.ika.rwth-aachen.de:5050/automated-driving/docker/tensorflow:${TF_VERSION}-libtensorflow_cc${GPU_POSTFIX}"
STAGE="deb-package"

echo "Building ${IMAGE} ... "
docker build --build-arg TF_VERSION=${TF_VERSION} --build-arg JOBS=${JOBS} --build-arg GPU_POSTFIX=${GPU_POSTFIX} --target ${STAGE} -t ${IMAGE} ${DOCKER_DIR} | tee ${LOG_FILE}

echo "Exporting to $(realpath ${EXPORT_DIR})/${EXPORT_FILE} ... "
TMP_CONTAINER=$(docker create ${IMAGE})
docker cp ${TMP_CONTAINER}:/${EXPORT_FILE} ${EXPORT_DIR}/
docker rm -v ${TMP_CONTAINER}
