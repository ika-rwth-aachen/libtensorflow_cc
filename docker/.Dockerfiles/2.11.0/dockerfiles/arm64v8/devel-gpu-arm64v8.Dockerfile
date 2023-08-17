ARG UBUNTU_VERSION=20.04

FROM rwthika/cuda:11.8-cudnn-trt-ubuntu20.04-devel as base
ENV DEBIAN_FRONTEND=noninteractive

ARG CUDA=11.8
ARG CUDNN=8.6.0.163-1
ARG CUDNN_MAJOR_VERSION=8
ARG LIBNVINFER=8.5.3-1
ARG LIBNVINFER_MAJOR_VERSION=8

# Needed for string substitution
SHELL ["/bin/bash", "-c"]

# essentials
# See http://bugs.python.org/issue19846
ENV LANG C.UTF-8
RUN apt-get update && apt-get install -y \ 
        build-essential \
        clang-format \
        curl \
        git \
        gnupg2 \
        libcurl3-dev \
        libfreetype6-dev \
        libhdf5-serial-dev \
        libzmq3-dev \
        openjdk-8-jdk \
        pkg-config \
        python3 \
        python3-dev \
        python3-pip \
        rsync \
        software-properties-common \
        swig \
        unzip \
        virtualenv \
        wget \
        zip \
        zlib1g-dev

RUN python3 -m pip --no-cache-dir install --upgrade \
    "pip<20.3" \
    setuptools==49.6.0

# Some TF tools expect a "python" binary
RUN ln -s $(which python3) /usr/local/bin/python

RUN python3 -m pip --no-cache-dir install \
    Pillow \
    h5py \
    keras_preprocessing \
    tb-nightly \
    matplotlib \
    mock \
    'numpy<1.19.0' \
    scipy \
    scikit-learn \
    pandas \
    future \
    portpicker \
    enum34

# Configure the build for our CUDA configuration.
ENV LD_LIBRARY_PATH /usr/local/cuda-11.8/targets/aarch64-linux/lib:/usr/local/cuda/lib64:/usr/include/aarch64-linux-gnu:/usr/lib/aarch64-linux-gnu:$LD_LIBRARY_PATH:/usr/local/cuda/lib64/stubs:/usr/local/cuda-11.8/lib64
ENV TF_NEED_CUDA 1
ENV TF_NEED_TENSORRT 1
ENV TF_CUDA_VERSION=${CUDA}
ENV TF_CUDNN_VERSION=${CUDNN_MAJOR_VERSION}

# Link the libcuda stub to the location where tensorflow is searching for it and reconfigure
# dynamic linker run-time bindings
RUN ln -s /usr/local/cuda/lib64/stubs/libcuda.so /usr/local/cuda/lib64/stubs/libcuda.so.1 \
    && echo "/usr/local/cuda/lib64/stubs" > /etc/ld.so.conf.d/z-cuda-stubs.conf \
    && ldconfig

# Installs bazelisk
RUN mkdir /bazel && \
    curl -fSsL -o /bazel/LICENSE.txt "https://raw.githubusercontent.com/bazelbuild/bazel/master/LICENSE" && \
    mkdir /bazelisk && \
    curl -fSsL -o /bazelisk/LICENSE.txt "https://raw.githubusercontent.com/bazelbuild/bazelisk/master/LICENSE" && \
    curl -fSsL -o /usr/bin/bazel "https://github.com/bazelbuild/bazelisk/releases/download/v1.11.0/bazelisk-linux-arm64" && \
    chmod +x /usr/bin/bazel

COPY bashrc /etc/bash.bashrc
RUN chmod a+rwx /etc/bash.bashrc