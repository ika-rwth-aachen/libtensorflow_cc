#!/bin/bash
source  $(dirname "$0")/.common.sh

SCRIPT_DEVEL=${SCRIPT_DIR}/.versions.devel.sh
SCRIPT_RUN=${SCRIPT_DIR}/.versions.run.sh
SCRIPT_MOUNT=/.versions.sh
IMAGE_DEVEL="tensorflow/tensorflow:${TF_VERSION}-devel${GPU_POSTFIX}"
IMAGE_RUN="gitlab.ika.rwth-aachen.de:5050/automated-driving/docker/tensorflow:${TF_VERSION}-py-cpp${GPU_POSTFIX}"
CMD="bash ${SCRIPT_MOUNT}"

echo "Getting version information from ${IMAGE_DEVEL} and ${IMAGE_RUN} ... "
docker run --rm --gpus all -v ${SCRIPT_DEVEL}:${SCRIPT_MOUNT} ${IMAGE_DEVEL} ${CMD} | tee ${LOG_FILE}
docker run --rm --gpus all -v ${SCRIPT_RUN}:${SCRIPT_MOUNT} ${IMAGE_RUN} ${CMD}| tee -a ${LOG_FILE}
