#!/bin/bash
source  $(dirname "$0")/.common.sh

docker login
docker push ${IMAGE_CPP}
