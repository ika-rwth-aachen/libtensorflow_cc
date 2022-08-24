#!/bin/bash
source  $(dirname "$0")/.common.sh

REPO_URL="https://github.com/tensorflow/tensorflow/archive/refs/tags/v${TF_VERSION}.tar.gz"
REPO_PATH="tensorflow/tools/dockerfiles/*"
TEMP_DIR=$(mktemp -d)
REPO_DIR=${TEMP_DIR}/${TF_VERSION}

mkdir -p ${DOCKERFILES_DIR}
echo -n "Downloading TensorFlow ${TF_VERSION} Dockerfiles to $(realpath ${DOCKERFILE_DIR}) ... "

if [[ ! -d ${DOCKERFILE_DIR} ]]; then
    wget --quiet --directory-prefix ${TEMP_DIR} ${REPO_URL}
    mkdir ${REPO_DIR}
    tar -xzf ${TEMP_DIR}/v${TF_VERSION}.tar.gz -C ${REPO_DIR} --strip-components=1
    mkdir ${DOCKERFILE_DIR}
    mv ${REPO_DIR}/${REPO_PATH} ${DOCKERFILE_DIR}
    rm -rf ${TEMP_DIR}
fi

echo "done"
