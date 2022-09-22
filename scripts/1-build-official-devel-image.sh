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

#!/bin/bash
source  $(dirname "$0")/.common.sh

CPU_GPU_POSTFIX=${GPU_POSTFIX:--cpu}
DOCKERFILE=${DOWNLOAD_DOCKERFILE_DIR}/dockerfiles/devel${CPU_GPU_POSTFIX}.Dockerfile
BUILD_DIR=${DOWNLOAD_DOCKERFILE_DIR}

echo "Building ${IMAGE_DEVEL} ... "
docker build -t ${IMAGE_DEVEL} -f ${DOCKERFILE} ${BUILD_DIR} | tee ${LOG_FILE}
