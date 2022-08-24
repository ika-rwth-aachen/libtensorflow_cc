set -e
set -o pipefail

DEFAULT_TF_VERSION="2.9.1"
DEFAULT_JOBS=$(nproc)
DEFAULT_GPU=1

TF_VERSION=${TF_VERSION:-${DEFAULT_TF_VERSION}}
JOBS=${JOBS:-${DEFAULT_JOBS}}
GPU=${GPU:-${DEFAULT_GPU}}
[[ $GPU == "1" ]] && GPU_POSTFIX="-gpu" || GPU_POSTFIX=""

SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR=$(realpath $(dirname "$0"))
REPOSITORY_DIR=$(realpath ${SCRIPT_DIR}/..)
DOCKER_DIR=${REPOSITORY_DIR}/docker
LOG_DIR=${DOCKER_DIR}/.log
LOG_FILE=${LOG_DIR}/${SCRIPT_NAME}_${TF_VERSION}${GPU_POSTFIX}.log
mkdir -p ${LOG_DIR}

DOWNLOAD_DOCKERFILES_DIR=${DOCKER_DIR}/.Dockerfiles
DOWNLOAD_DOCKERFILE_DIR=${DOWNLOAD_DOCKERFILES_DIR}/${TF_VERSION}

IMAGE_DEVEL="tensorflow/tensorflow:${TF_VERSION}-devel${GPU_POSTFIX}"
IMAGE_CPP="gitlab.ika.rwth-aachen.de:5050/automated-driving/docker/tensorflow:${TF_VERSION}-py-cpp${GPU_POSTFIX}"
IMAGE_LIBTENSORFLOW_CC="gitlab.ika.rwth-aachen.de:5050/automated-driving/docker/tensorflow:${TF_VERSION}-libtensorflow_cc${GPU_POSTFIX}"
