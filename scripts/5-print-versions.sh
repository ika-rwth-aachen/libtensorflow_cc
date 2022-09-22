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

SCRIPT_DEVEL=${SCRIPT_DIR}/.versions.devel.sh
SCRIPT_RUN=${SCRIPT_DIR}/.versions.run.sh
SCRIPT_MOUNT=/.versions.sh
CMD="bash ${SCRIPT_MOUNT}"

echo "Getting version information from ${IMAGE_DEVEL} and ${IMAGE_CPP} ... "
docker run --rm --gpus all -v ${SCRIPT_DEVEL}:${SCRIPT_MOUNT} ${IMAGE_DEVEL} ${CMD} | tee ${LOG_FILE}
docker run --rm --gpus all -v ${SCRIPT_RUN}:${SCRIPT_MOUNT} ${IMAGE_CPP} ${CMD}| tee -a ${LOG_FILE}
