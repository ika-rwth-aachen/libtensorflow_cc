#!/bin/bash
source  $(dirname "$0")/.common.sh

EXAMPLE_DIR=${REPOSITORY_DIR}/example
EXAMPLE_MOUNT="/example"
CMD="bash /example/build-and-run.sh"

echo "Testing libtensorflow_cc in ${IMAGE} ... "
docker run --rm --gpus all -v ${EXAMPLE_DIR}:${EXAMPLE_MOUNT} -w ${EXAMPLE_MOUNT} ${IMAGE} ${CMD} | tee ${LOG_FILE}
