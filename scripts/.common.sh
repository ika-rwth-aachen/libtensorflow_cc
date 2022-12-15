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

set -e
set -o pipefail

DEFAULT_TF_VERSION="2.9.3"
DEFAULT_JOBS=$(nproc)
DEFAULT_GPU=1
DEFAULT_ARCH=$(dpkg --print-architecture)

TF_VERSION=${TF_VERSION:-${DEFAULT_TF_VERSION}}
JOBS=${JOBS:-${DEFAULT_JOBS}}
GPU=${GPU:-${DEFAULT_GPU}}
[[ $GPU == "1" ]] && GPU_POSTFIX="-gpu" || GPU_POSTFIX=""
ARCH=${ARCH:-${DEFAULT_ARCH}}

SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR=$(realpath $(dirname "$0"))
REPOSITORY_DIR=$(realpath ${SCRIPT_DIR}/..)
DOCKER_DIR=${REPOSITORY_DIR}/docker
LOG_DIR=${DOCKER_DIR}/.log
LOG_FILE=${LOG_DIR}/${SCRIPT_NAME}_${TF_VERSION}${GPU_POSTFIX}.log
mkdir -p ${LOG_DIR}

DOWNLOAD_DOCKERFILES_DIR=${DOCKER_DIR}/.Dockerfiles
DOWNLOAD_DOCKERFILE_DIR=${DOWNLOAD_DOCKERFILES_DIR}/${TF_VERSION}

IMAGE_DEVEL_ARCH="tensorflow/tensorflow:${TF_VERSION}-devel${GPU_POSTFIX}-${ARCH}"
IMAGE_CPP="rwthika/tensorflow-cc:${TF_VERSION}${GPU_POSTFIX}"
IMAGE_CPP_ARCH="${IMAGE_CPP}-${ARCH}"
IMAGE_LIBTENSORFLOW_CC_ARCH="rwthika/tensorflow-cc:${TF_VERSION}-libtensorflow_cc${GPU_POSTFIX}-${ARCH}"
