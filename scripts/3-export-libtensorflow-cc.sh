#!/bin/bash
source  $(dirname "$0")/.common.sh

EXPORT_DIR=${REPOSITORY_DIR}/libtensorflow-cc
CONTAINER_FILE="libtensorflow-cc_${TF_VERSION}.deb"
EXPORT_FILE="libtensorflow-cc_${TF_VERSION}${GPU_POSTFIX}.deb"
STAGE="deb-package"

echo "Building ${IMAGE_LIBTENSORFLOW_CC} ... "
docker build --build-arg TF_VERSION=${TF_VERSION} --build-arg JOBS=${JOBS} --build-arg GPU_POSTFIX=${GPU_POSTFIX} --target ${STAGE} -t ${IMAGE_LIBTENSORFLOW_CC} ${DOCKER_DIR} | tee ${LOG_FILE}

echo "Exporting to $(realpath ${EXPORT_DIR})/${EXPORT_FILE} ... "
TMP_CONTAINER=$(docker create ${IMAGE_LIBTENSORFLOW_CC})
docker cp ${TMP_CONTAINER}:/${EXPORT_FILE} ${EXPORT_DIR}/
docker rm -v ${TMP_CONTAINER}
