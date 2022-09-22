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

REPO_URL="https://github.com/tensorflow/tensorflow/archive/refs/tags/v${TF_VERSION}.tar.gz"
REPO_PATH="tensorflow/tools/dockerfiles/*"
TEMP_DIR=$(mktemp -d)
REPO_DIR=${TEMP_DIR}/${TF_VERSION}

mkdir -p ${DOWNLOAD_DOCKERFILES_DIR}
echo -n "Downloading TensorFlow ${TF_VERSION} Dockerfiles to $(realpath ${DOWNLOAD_DOCKERFILE_DIR}) ... "

if [[ ! -d ${DOWNLOAD_DOCKERFILE_DIR} ]]; then
    wget --quiet --directory-prefix ${TEMP_DIR} ${REPO_URL}
    mkdir ${REPO_DIR}
    tar -xzf ${TEMP_DIR}/v${TF_VERSION}.tar.gz -C ${REPO_DIR} --strip-components=1
    mkdir ${DOWNLOAD_DOCKERFILE_DIR}
    mv ${REPO_DIR}/${REPO_PATH} ${DOWNLOAD_DOCKERFILE_DIR}
    rm -rf ${TEMP_DIR}
fi

echo "done"
