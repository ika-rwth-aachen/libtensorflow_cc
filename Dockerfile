# --- build stage for building libtensorflow_cc --------------------------------
ARG TF_VERSION=master
ARG GPU_POSTFIX=-gpu
FROM tensorflow/tensorflow:${TF_VERSION}-devel${GPU_POSTFIX} AS build

ARG TF_VERSION
ARG GPU_POSTFIX
ARG JOBS="auto"

# clone TensorFlow
RUN git clone --branch v${TF_VERSION} --depth=1 https://github.com/tensorflow/tensorflow.git /tensorflow
WORKDIR /tensorflow

# configure compilation
ENV PYTHON_BIN_PATH=/usr/bin/python3
ENV PYTHON_LIB_PATH=/usr/lib/python3/dist-packages
ENV TF_NEED_ROCM=0
ENV TF_CUDA_COMPUTE_CAPABILITIES=5.3,6.0,6.1,7.0,7.2,7.5,8.0,8.6
ENV TF_CUDA_CLANG=0
ENV GCC_HOST_COMPILER_PATH=/usr/bin/gcc
ENV CC_OPT_FLAGS="-march=native -Wno-sign-compare"
ENV TF_SET_ANDROID_WORKSPACE=0
RUN ./configure

# build C++ library
RUN if [ "${GPU_POSTFIX}" = "-gpu" ]; then \
        bazel build --jobs ${JOBS} --config=cuda --config=opt --config=monolithic --verbose_failures tensorflow:libtensorflow_cc.so tensorflow:install_headers; \
    else \
        bazel build --jobs ${JOBS} --config=opt --config=monolithic --verbose_failures tensorflow:libtensorflow_cc.so tensorflow:install_headers; \
    fi

# move libtensorflow_cc to separate folder for easier Dockerfile COPY
RUN mkdir bazel-bin/tensorflow/lib && \
    mv bazel-bin/tensorflow/libtensorflow_cc.so* bazel-bin/tensorflow/lib/

# build protobuf from source, same version as TensorFlow is using
WORKDIR /
RUN apt-get install -y autoconf automake libtool curl make g++ unzip && \
    PROTOBUF_URL=$(grep -Eho "https://github.com/protocolbuffers/protobuf/archive/.*\.(zip|tar.gz)" tensorflow/tensorflow/workspace*.bzl) && \
    PROTOBUF_VERSION=$(echo $PROTOBUF_URL | grep -Eo "(.?\..?\..?|[0-9a-f]{40})") && \
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

ARG TF_VERSION
ARG GPU_POSTFIX

# create package structure
WORKDIR /libtensorflow-cc_${TF_VERSION}${GPU_POSTFIX}
COPY DEBIAN DEBIAN
RUN mkdir -p usr/local/include/bin usr/local/include usr/local/lib/
COPY --from=build /tensorflow/bazel-bin/tensorflow/include  usr/local/include/tensorflow
COPY --from=build /tensorflow/bazel-bin/tensorflow/lib      usr/local/lib/tensorflow
COPY --from=build /usr/local/bin/protoc                     usr/local/bin/protoc
COPY --from=build /usr/local/include/google                 usr/local/include/google
COPY --from=build /usr/local/lib                            usr/local/lib/protobuf
RUN cp -d usr/local/lib/protobuf/lib* usr/local/lib/ && \
    rm -rf usr/local/lib/protobuf
RUN sed -i "s/TF_VERSION/$TF_VERSION/" DEBIAN/control

# build .deb
WORKDIR /
RUN dpkg-deb --build --root-owner-group libtensorflow-cc_${TF_VERSION}${GPU_POSTFIX} && \
    rm -rf libtensorflow-cc_${TF_VERSION}${GPU_POSTFIX}/

# --- final stage with TensorFlow Python and C++ Library -----------------------
FROM tensorflow/tensorflow:${TF_VERSION}${GPU_POSTFIX} as final

ARG TF_VERSION
ARG GPU_POSTFIX

# install TensorFlow C++ API incl. protobuf
COPY --from=deb-package /libtensorflow-cc_${TF_VERSION}${GPU_POSTFIX}.deb /tmp
RUN dpkg -i /tmp/libtensorflow-cc_${TF_VERSION}${GPU_POSTFIX}.deb && \
    ldconfig
