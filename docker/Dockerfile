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

# --- build stage for building libtensorflow_cc --------------------------------
ARG TARGETARCH
ARG TF_VERSION=master
ARG GPU_POSTFIX=-gpu
FROM tensorflow/tensorflow:${TF_VERSION}-devel${GPU_POSTFIX}-${TARGETARCH} as build

ARG TARGETARCH
ARG TF_VERSION
ARG GPU_POSTFIX

# clone TensorFlow
RUN git clone --branch v${TF_VERSION} --depth=1 https://github.com/tensorflow/tensorflow.git /tensorflow
WORKDIR /tensorflow

# fix build issue in 2.10.0, 2.10.1
# https://github.com/tensorflow/tensorflow/issues/57826
RUN if [ "${TF_VERSION}" = "2.10.0" ] || [ "${TF_VERSION}" = "2.10.1" ]; then \
        git fetch --depth=1 origin b1bd1d6beeac169ce669f81dcbf3c48899ca1ed0 && \
        git checkout FETCH_HEAD -- tensorflow/BUILD; \
    fi

# fix GPU-version build issue in 2.11.1, 2.12.0, 2.12.1, 2.13.0
# https://github.com/tensorflow/tensorflow/issues/60398#issuecomment-1537040602
COPY patch/ patch/
RUN if [ "${TF_VERSION}" = "2.11.1" ] || [ "${TF_VERSION}" = "2.12.0" ] || [ "${TF_VERSION}" = "2.12.1" ] || [ "${TF_VERSION}" = "2.13.0" ]; then \
        git apply patch/${TF_VERSION}/workspace2.bzl.patch; \
    fi

# configure compilation
ENV PYTHON_BIN_PATH=/usr/bin/python3
ENV PYTHON_LIB_PATH=/usr/lib/python3/dist-packages
ENV TF_NEED_ROCM=0
ENV TF_NEED_CUDA=1
ENV TF_NEED_TENSORRT=1
ARG TF_CUDA_COMPUTE_CAPABILITIES=6.0,6.1,7.0,7.5,8.0,8.6,8.9,9.0
ENV TF_CUDA_COMPUTE_CAPABILITIES=${TF_CUDA_COMPUTE_CAPABILITIES}
ENV TF_CUDA_CLANG=0
ENV GCC_HOST_COMPILER_PATH=/usr/bin/gcc
ENV CC_OPT_FLAGS="-march=native -Wno-sign-compare"
ENV TF_SET_ANDROID_WORKSPACE=0
RUN ./configure

# build C++ library
# fix runtime issue in 2.10.0, 2.10.1, 2.11.0, 2.11.1, 2.12.0, 2.12.1, 2.13.0 by building non-monolithic
# https://github.com/tensorflow/tensorflow/issues/59081
ARG JOBS="auto"
RUN if [ "${GPU_POSTFIX}" = "-gpu" ]; then \
        if [ "${TF_VERSION}" = "2.10.0" ] || [ "${TF_VERSION}" = "2.10.1" ] || [ "${TF_VERSION}" = "2.11.0" ] || [ "${TF_VERSION}" = "2.11.1" ] || [ "${TF_VERSION}" = "2.12.0" ] || [ "${TF_VERSION}" = "2.12.1" ] || [ "${TF_VERSION}" = "2.13.0" ]; then \
            bazel build --jobs ${JOBS} --config=cuda --config=opt --verbose_failures tensorflow:libtensorflow_cc.so tensorflow:install_headers; \
        else \
            bazel build --jobs ${JOBS} --config=cuda --config=opt --config=monolithic --verbose_failures tensorflow:libtensorflow_cc.so tensorflow:install_headers; \
        fi; \
    else \
        if [ "${TF_VERSION}" = "2.10.0" ] || [ "${TF_VERSION}" = "2.10.1" ] || [ "${TF_VERSION}" = "2.11.0" ] || [ "${TF_VERSION}" = "2.11.1" ] || [ "${TF_VERSION}" = "2.12.0" ] || [ "${TF_VERSION}" = "2.12.1" ] || [ "${TF_VERSION}" = "2.13.0" ]; then \
            bazel build --jobs ${JOBS} --config=opt --verbose_failures tensorflow:libtensorflow_cc.so tensorflow:install_headers; \
        else \
            bazel build --jobs ${JOBS} --config=opt --config=monolithic --verbose_failures tensorflow:libtensorflow_cc.so tensorflow:install_headers; \
        fi; \
    fi

# move libtensorflow_cc to separate folder for easier Dockerfile COPY
RUN mkdir -p bazel-bin/tensorflow/lib && \
    mv bazel-bin/tensorflow/libtensorflow_cc.so* bazel-bin/tensorflow/lib/ && \
    mv bazel-bin/tensorflow/libtensorflow_framework.so* bazel-bin/tensorflow/lib/ && \
    ln -sf libtensorflow_framework.so.2 bazel-bin/tensorflow/lib/libtensorflow_framework.so && \
    rm bazel-bin/tensorflow/lib/*params

# build pip package
# fix runtime issue in 2.10.0, 2.10.1, 2.11.0, 2.11.1, 2.12.0, 2.12.1, 2.13.0 by building non-monolithic
# https://github.com/tensorflow/tensorflow/issues/59081
ARG BUILD_PIP_PACKAGE=0
RUN if [ "${BUILD_PIP_PACKAGE}" = "1" ]; then \
        if [ "${GPU_POSTFIX}" = "-gpu" ]; then \
            if [ "${TF_VERSION}" = "2.10.0" ] || [ "${TF_VERSION}" = "2.10.1" ] || [ "${TF_VERSION}" = "2.11.0" ] || [ "${TF_VERSION}" = "2.11.1" ] || [ "${TF_VERSION}" = "2.12.0" ] || [ "${TF_VERSION}" = "2.12.1" ] || [ "${TF_VERSION}" = "2.13.0" ]; then \
                bazel build --jobs ${JOBS} --config=cuda --config=opt --verbose_failures tensorflow/tools/pip_package:build_pip_package; \
            else \
                bazel build --jobs ${JOBS} --config=cuda --config=opt --config=monolithic --verbose_failures tensorflow/tools/pip_package:build_pip_package; \
            fi; \
        else \
            if [ "${TF_VERSION}" = "2.10.0" ] || [ "${TF_VERSION}" = "2.10.1" ] || [ "${TF_VERSION}" = "2.11.0" ] || [ "${TF_VERSION}" = "2.11.1" ] || [ "${TF_VERSION}" = "2.12.0" ] || [ "${TF_VERSION}" = "2.12.1" ] || [ "${TF_VERSION}" = "2.13.0" ]; then \
                bazel build --jobs ${JOBS} --config=opt --verbose_failures tensorflow/tools/pip_package:build_pip_package; \
            else \
                bazel build --jobs ${JOBS} --config=opt --config=monolithic --verbose_failures tensorflow/tools/pip_package:build_pip_package; \
            fi; \
        fi; \
        pip install patchelf && \
        ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow/pip ; \
    else \
        mkdir -p /tmp/tensorflow/pip && \
        touch /tmp/tensorflow/pip/tensorflow-dummy.whl ; \
    fi

# build protobuf from source, same version as TensorFlow is using
WORKDIR /
RUN apt-get install -y autoconf automake libtool curl make g++ unzip wget && \
    PROTOBUF_URL=$(grep -Eho "https://github.com/protocolbuffers/protobuf/archive/.*\.(zip|tar.gz)" tensorflow/tensorflow/workspace*.bzl) && \
    PROTOBUF_VERSION=$(echo $PROTOBUF_URL | grep -Eo "([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}|[0-9a-f]{40})") && \
    wget -q $PROTOBUF_URL -O protobuf.archive && \
    (unzip -q protobuf.archive || tar -xzf protobuf.archive) && \
    rm protobuf.archive && \
    mv protobuf-$PROTOBUF_VERSION protobuf && \
    cd protobuf && \
    ./autogen.sh && \
    ./configure --prefix=/usr/local && \
    make -j $(nproc) && \
    make install && \
    ldconfig

# --- deb-package stage providing libtensorflow-cc.deb -------------------------
FROM ubuntu:focal as deb-package

ARG TARGETARCH
ARG TF_VERSION
ARG GPU_POSTFIX

# create package structure
WORKDIR /libtensorflow-cc_${TF_VERSION}${GPU_POSTFIX}
RUN mkdir -p usr/local/include/bin usr/local/include usr/local/lib/ usr/local/lib/cmake/tensorflow
COPY DEBIAN DEBIAN
COPY cmake/TensorFlowConfig.cmake usr/local/lib/cmake/tensorflow/TensorFlowConfig.cmake
COPY --from=build /tensorflow/bazel-bin/tensorflow/include  usr/local/include/tensorflow
COPY --from=build /tensorflow/bazel-bin/tensorflow/lib      usr/local/lib/tensorflow
COPY --from=build /usr/local/bin/protoc                     usr/local/bin/protoc
COPY --from=build /usr/local/include/google                 usr/local/include/google
COPY --from=build /usr/local/lib                            usr/local/lib/protobuf
RUN cp -d usr/local/lib/tensorflow/lib* usr/local/lib/protobuf/lib* usr/local/lib/ && \
    rm -rf usr/local/lib/tensorflow usr/local/lib/protobuf
RUN sed -i "s/TF_VERSION/$TF_VERSION/" DEBIAN/control
RUN sed -i "s/TARGETARCH/$TARGETARCH/" DEBIAN/control

# build .deb
WORKDIR /
RUN dpkg-deb --build --root-owner-group libtensorflow-cc_${TF_VERSION}${GPU_POSTFIX} && \
    rm -rf libtensorflow-cc_${TF_VERSION}${GPU_POSTFIX}/

# copy pip package, if built
ARG BUILD_PIP_PACKAGE=0
COPY --from=build /tmp/tensorflow/pip/tensorflow*.whl /

# --- final stage with TensorFlow Python and C++ Library -----------------------
FROM --platform=amd64 tensorflow/tensorflow:${TF_VERSION}${GPU_POSTFIX} as final-amd64
ARG TARGETARCH

# FROM ubuntu
FROM --platform=arm64 ubuntu:focal as final-arm64
ARG TARGETARCH

FROM --platform=arm64 nvcr.io/nvidia/l4t-tensorflow:r35.1.0-tf2.9-py3 as final-arm64-gpu
ARG TARGETARCH

FROM "final-${TARGETARCH}${GPU_POSTFIX}" as final

ARG DEBIAN_FRONTEND=noninteractive
ARG TF_VERSION
ARG GPU_POSTFIX

# make sure gcc is installed
RUN apt-get update && \
    apt-get install -y build-essential && \
    rm -rf /var/lib/apt/lists/*

# install gcc 11 for 2.12.0, 2.12.1, 2.13.0
# https://stackoverflow.com/a/67453352/7264974
RUN if [ "${TF_VERSION}" = "2.12.0" ] || [ "${TF_VERSION}" = "2.12.1" ] || [ "${TF_VERSION}" = "2.13.0" ]; then \
        apt-get update && \
	    apt-get install -y software-properties-common && \
        add-apt-repository ppa:ubuntu-toolchain-r/test && \
        apt-get install -y gcc-11 g++-11 && \
        rm -rf /var/lib/apt/lists/* && \
        update-alternatives --remove-all cpp && \
        update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 90 --slave /usr/bin/g++ g++ /usr/bin/g++-9 --slave /usr/bin/gcov gcov /usr/bin/gcov-9 --slave /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-9 --slave /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-9 --slave /usr/bin/cpp cpp /usr/bin/cpp-9 && \
        update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 110 --slave /usr/bin/g++ g++ /usr/bin/g++-11 --slave /usr/bin/gcov gcov /usr/bin/gcov-11 --slave /usr/bin/gcc-ar gcc-ar /usr/bin/gcc-ar-11 --slave /usr/bin/gcc-ranlib gcc-ranlib /usr/bin/gcc-ranlib-11  --slave /usr/bin/cpp cpp /usr/bin/cpp-11 ; \
    fi

# install TensorFlow C++ API incl. protobuf
COPY --from=deb-package /libtensorflow-cc_${TF_VERSION}${GPU_POSTFIX}.deb /tmp
RUN dpkg -i /tmp/libtensorflow-cc_${TF_VERSION}${GPU_POSTFIX}.deb && \
    ldconfig && \
    rm /tmp/libtensorflow-cc_${TF_VERSION}${GPU_POSTFIX}.deb
