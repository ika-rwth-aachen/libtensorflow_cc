#!/bin/bash
# ==============================================================================
# MIT License
# Copyright 2022 Institute for Automotive Engineering of RWTH Aachen University.
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ==============================================================================

source  $(dirname "$0")/.common.sh

EXAMPLE_DIR=${REPOSITORY_DIR}/example
EXAMPLE_MOUNT="/example"
CMD="./build-and-run.sh"

echo "Testing libtensorflow_cc in ${IMAGE_CPP} ... "
if [[ "$GPU" == "1" && "$ARCH" = "amd64" ]]; then
    GPU_ARG="--gpus all"
elif [[ "$GPU" == "1" && "$ARCH" = "arm64" ]]; then
    GPU_ARG="--runtime nvidia"
else
    GPU_ARG=""
fi
docker run --rm ${GPU_ARG} -v ${EXAMPLE_DIR}:${EXAMPLE_MOUNT} -w ${EXAMPLE_MOUNT} ${IMAGE_CPP} ${CMD} | tee ${LOG_FILE}
