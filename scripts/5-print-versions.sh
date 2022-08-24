#!/bin/bash
source  $(dirname "$0")/.common.sh

SCRIPT_DEVEL=${SCRIPT_DIR}/.versions.devel.sh
SCRIPT_RUN=${SCRIPT_DIR}/.versions.run.sh
SCRIPT_MOUNT=/.versions.sh
CMD="bash ${SCRIPT_MOUNT}"

echo "Getting version information from ${IMAGE_DEVEL} and ${IMAGE_CPP} ... "
docker run --rm --gpus all -v ${SCRIPT_DEVEL}:${SCRIPT_MOUNT} ${IMAGE_DEVEL} ${CMD} | tee ${LOG_FILE}
docker run --rm --gpus all -v ${SCRIPT_RUN}:${SCRIPT_MOUNT} ${IMAGE_CPP} ${CMD}| tee -a ${LOG_FILE}
