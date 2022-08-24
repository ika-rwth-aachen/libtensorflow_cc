#!/bin/bash
source  $(dirname "$0")/.common.sh

EXAMPLE_DIR=${REPOSITORY_DIR}/example
EXAMPLE_MOUNT="/example"
CMD="bash /example/build-and-run.sh"

echo "Testing libtensorflow_cc in ${IMAGE_CPP} ... "
docker run --rm --gpus all -v ${EXAMPLE_DIR}:${EXAMPLE_MOUNT} -w ${EXAMPLE_MOUNT} ${IMAGE_CPP} ${CMD} | tee ${LOG_FILE}
