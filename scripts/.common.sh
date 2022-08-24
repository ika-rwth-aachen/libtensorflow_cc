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
LOG_DIR=${SCRIPT_DIR}/../.log
LOG_FILE=${LOG_DIR}/${SCRIPT_NAME}_${TF_VERSION}${GPU_POSTFIX}.log
mkdir -p ${LOG_DIR}

DOCKERFILES_DIR=${SCRIPT_DIR}/../.Dockerfiles
DOCKERFILE_DIR=${DOCKERFILES_DIR}/${TF_VERSION}
