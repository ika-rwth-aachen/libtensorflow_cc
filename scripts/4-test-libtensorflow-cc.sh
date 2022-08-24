#!/bin/bash
source  $(dirname "$0")/.common.sh

EXAMPLE_DIR=${SCRIPT_DIR}/../example
EXAMPLE_MOUNT="/example"
IMAGE="gitlab.ika.rwth-aachen.de:5050/automated-driving/docker/tensorflow:${TF_VERSION}-py-cpp${GPU_POSTFIX}"
CMD="bash /example/build-and-run.sh"

echo "Testing libtensorflow_cc in ${IMAGE} ... "
docker run --rm --gpus all -v ${EXAMPLE_DIR}:${EXAMPLE_MOUNT} -w ${EXAMPLE_MOUNT} ${IMAGE} ${CMD} | tee ${LOG_FILE}
