ARG UBUNTU_VERSION=20.04

FROM nvcr.io/nvidia/l4t-base:35.4.1 as base
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
    setuptools

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


# CUDA 11.8 - jetson - native - ubuntu 20.04
RUN wget -q -O /tmp/cuda-keyring_1.0-1_all.deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/arm64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i /tmp/cuda-keyring_1.0-1_all.deb

# l4t stuff
RUN echo "deb https://repo.download.nvidia.com/jetson/common r35.4 main" >> /etc/apt/sources.list && \
    echo "deb https://repo.download.nvidia.com/jetson/t194 r35.4 main" >> /etc/apt/sources.list && \
    apt-key adv --fetch-key http://repo.download.nvidia.com/jetson/jetson-ota-public.asc
RUN mkdir -p /opt/nvidia/l4t-packages/ && \
    touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall

# install CUDA 11.8 for jetson and its dependencies (includes l4t stuff)
RUN apt-get update && \
    echo "N" | apt-get install -y cuda-${CUDA/./-}
RUN echo "export PATH=/usr/local/cuda-11.8/bin:$PATH" >> ~/.bashrc

# libcudnn8
# Download from https://developer.nvidia.com/compute/cudnn/secure/8.6.0/local_installers/11.8/cudnn-local-repo-ubuntu2004-8.6.0.163_1.0-1_arm64.deb
COPY dockerfiles/arm64v8/cudnn-local-repo-ubuntu2004-8.6.0.163_1.0-1_arm64.deb /cudnn-local-repo-ubuntu2004-8.6.0.163_1.0-1_arm64.deb
RUN dpkg -i cudnn-local-repo-ubuntu2004-8.6.0.163_1.0-1_arm64.deb && \
    cp /var/cudnn-local-repo-ubuntu2004-8.6.0.163/cudnn-local-04A93B30-keyring.gpg /usr/share/keyrings/ && \
    apt-get update && \
    apt-get install -y \
        libcudnn${CUDNN_MAJOR_VERSION}=${CUDNN}+cuda${CUDA} \
        libcudnn${CUDNN_MAJOR_VERSION}-dev=${CUDNN}+cuda${CUDA}

# libnvinfer8 (TensorRT)
# Download from: https://developer.nvidia.com/downloads/compute/machine-learning/tensorrt/secure/8.5.3/local_repos/nv-tensorrt-local-repo-ubuntu2004-8.5.3-cuda-11.8_1.0-1_arm64.deb
COPY dockerfiles/arm64v8/nv-tensorrt-local-repo-ubuntu2004-8.5.3-cuda-11.8_1.0-1_arm64.deb /nv-tensorrt-local-repo-ubuntu2004-8.5.3-cuda-11.8_1.0-1_arm64.deb
RUN dpkg -i nv-tensorrt-local-repo-ubuntu2004-8.5.3-cuda-11.8_1.0-1_arm64.deb && \
    cp /var/nv-tensorrt-local-repo-ubuntu2004-8.5.3-cuda-11.8/nv-tensorrt-local-5C39D720-keyring.gpg /usr/share/keyrings/ && \
    apt-get update && \
    apt-get install -y \
        libnvinfer${LIBNVINFER_MAJOR_VERSION}=${LIBNVINFER}+cuda${CUDA} \
        libnvinfer-dev=${LIBNVINFER}+cuda${CUDA} \
        libnvinfer-plugin-dev=${LIBNVINFER}+cuda${CUDA} \
        libnvinfer-plugin${LIBNVINFER_MAJOR_VERSION}=${LIBNVINFER}+cuda${CUDA}

# Configure the build for our CUDA configuration.
ENV LD_LIBRARY_PATH /usr/local/cuda-11.8/targets/x86_64-linux/lib:/usr/local/cuda/extras/CUPTI/lib64:/usr/local/cuda/lib64:/usr/include/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH:/usr/local/cuda/lib64/stubs:/usr/local/cuda-11.8/lib64
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