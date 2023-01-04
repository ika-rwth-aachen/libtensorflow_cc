# libtensorflow_cc

<p align="center">
  <img src="https://img.shields.io/github/v/release/ika-rwth-aachen/libtensorflow_cc"/>
  <img src="https://img.shields.io/github/license/ika-rwth-aachen/libtensorflow_cc"/>
  <a href="https://zenodo.org/badge/latestdoi/540364171"><img src="https://zenodo.org/badge/540364171.svg"></a>
  <a href="https://github.com/ika-rwth-aachen/libtensorflow_cc/actions/workflows/test.yml"><img src="https://github.com/ika-rwth-aachen/libtensorflow_cc/actions/workflows/test.yml/badge.svg"/></a>
  <a href="https://hub.docker.com/r/rwthika/tensorflow-cc"><img src="https://img.shields.io/docker/pulls/rwthika/tensorflow-cc"/></a>
  <img src="https://img.shields.io/github/stars/ika-rwth-aachen/libtensorflow_cc?style=social"/>
</p>

We provide a **pre-built library and a Docker image** for easy installation and usage of the [TensorFlow C++ API](https://www.tensorflow.org/api_docs/cc).

In order to, e.g., run TensorFlow models from C++ source code, one usually needs to build the C++ API in the form of the `libtensorflow_cc.so` library from source. There is no official release of the library and the build from source is only sparsely documented.

We try to remedy this current situation by providing two main components:
1. We provide the pre-built `libtensorflow_cc.so` including accompanying headers as a one-command-install deb-package. The package is available for both x86_64/amd64 and arm64 machines running Ubuntu. See [Installation](#installation).
2. We provide a pre-built Docker image based on the official TensorFlow Docker image. Our Docker image has both TensorFlow Python and TensorFlow C++ installed. The Docker images support both x86_64/amd64 and arm64 architectures. The arm64 version is specifically targeted at [NVIDIA Jetson Orin](https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/). See [Docker Images](#docker-images).

If you want to use the TensorFlow C++ API to load, inspect, and run saved models and frozen graphs in C++, we suggest that you also check out our helper library [*tensorflow_cpp*](https://github.com/ika-rwth-aachen/tensorflow_cpp). <img src="https://img.shields.io/github/stars/ika-rwth-aachen/tensorflow_cpp?style=social"/>

---

- [Demo](#demo)
- [Installation](#installation)
  - [CMake Integration](#cmake-integration)
- [Docker Images](#docker-images)
- [Build](#build)
- [Supported TensorFlow Versions](#supported-tensorflow-versions)
  - [Version Matrix](#version-matrix)


## Demo

Run the following from the Git repository root to mount, build and run the [example application](example/) in the pre-built Docker container.

```bash
# libtensorflow_cc$
docker run --rm \
    --volume $(pwd)/example:/example \
    --workdir /example \
    rwthika/tensorflow-cc:latest \
        ./build-and-run.sh

# Hello from TensorFlow C++ 2.9.3!
#
# A = 
# 1 2
# 3 4
#
# x = 
# 1
# 2
#
# A * x = 
#  5
# 11
```


## Installation

The pre-built `libtensorflow_cc.so` library and accompanying headers are packaged as a deb-package that can be installed as shown below. The deb-package can also be downloaded manually from the [Releases page](https://github.com/ika-rwth-aachen/libtensorflow_cc/releases). We provide versions with and without GPU support for x86_64/amd64 and arm64 architectures.

#### GPU

```bash
wget https://github.com/ika-rwth-aachen/libtensorflow_cc/releases/download/v2.9.3/libtensorflow-cc_2.9.3-gpu_$(dpkg --print-architecture).deb
sudo dpkg -i libtensorflow-cc_2.9.3-gpu_$(dpkg --print-architecture).deb
ldconfig
```

#### CPU

```bash
wget https://github.com/ika-rwth-aachen/libtensorflow_cc/releases/download/v2.9.3/libtensorflow-cc_2.9.3_$(dpkg --print-architecture).deb
sudo dpkg -i libtensorflow-cc_2.9.3_$(dpkg --print-architecture).deb
ldconfig
```

### CMake Integration

Use `find_package()` to locate and integrate the TensorFlow C++ API into your CMake project.

```cmake
# CMakeLists.txt
find_package(TensorFlow REQUIRED)
# ...
add_executable(foo ...) # / add_library(foo ...)
# ...
target_include_directories(foo PRIVATE ${TensorFlow_INCLUDE_DIRS})
target_link_libraries(foo PRIVATE ${TensorFlow_LIBRARIES})
```


## Docker Images

Instead of installing the TensorFlow C++ API using our deb-package, you can also run or build on top the pre-built Docker images in our [Docker Hub repository](https://hub.docker.com/r/rwthika/tensorflow-cc). If supported, we offer CPU-only and GPU-supporting images. Starting with TensorFlow 2.9.2, we offer multi-arch images, supporting x86_64/amd64 and arm64 architectures.

The amd64 images are based on the [official TensorFlow Docker images](https://hub.docker.com/r/tensorflow/tensorflow). The arm64 images are based on [NVIDIA's official L4T TensorFlow images for Jetson](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-tensorflow), targeted at [NVIDIA Jetson Orin](https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/). Our provided images only install the TensorFlow C++ API on top of those. The resulting images therefore enable you to run TensorFlow in both Python and C++. 

| TensorFlow Version | CPU/GPU | Architecture | Image:Tag |
| :---: | :---: | :---: | --- |
| 2.9.3 | GPU | amd64, arm64 | `rwthika/tensorflow-cc:latest-gpu` |
| 2.9.3 | CPU | amd64, arm64 | `rwthika/tensorflow-cc:latest` |

<details>
<summary><i>All TensorFlow Versions (GPU)</i></summary>

| TensorFlow Version | Architecture | Image:Tag |
| :---: | :---: | --- |
| latest | amd64, arm64 | `rwthika/tensorflow-cc:latest-gpu` |
| 2.9.3 | amd64, arm64 | `rwthika/tensorflow-cc:2.9.3-gpu` |
| 2.9.2 | amd64, arm64 | `rwthika/tensorflow-cc:2.9.2-gpu` |
| 2.9.1 | amd64 | `rwthika/tensorflow-cc:2.9.1-gpu` |
| 2.9.0 | amd64 | `rwthika/tensorflow-cc:2.9.0-gpu` |
| 2.8.4 | amd64 | `rwthika/tensorflow-cc:2.8.4-gpu` |
| 2.8.3 | amd64 | `rwthika/tensorflow-cc:2.8.3-gpu` |
| 2.8.2 | amd64 | `rwthika/tensorflow-cc:2.8.2-gpu` |
| 2.8.1 | amd64 | `rwthika/tensorflow-cc:2.8.1-gpu` |
| 2.8.0 | amd64 | `rwthika/tensorflow-cc:2.8.0-gpu` |
| 2.7.4 | amd64 | `rwthika/tensorflow-cc:2.7.4-gpu` |
| 2.7.3 | amd64 | `rwthika/tensorflow-cc:2.7.3-gpu` |
| 2.7.2 | amd64 | `rwthika/tensorflow-cc:2.7.2-gpu` |
| 2.7.1 | amd64 | `rwthika/tensorflow-cc:2.7.1-gpu` |
| 2.7.0 | amd64 | `rwthika/tensorflow-cc:2.7.0-gpu` |

</details>

<details>
<summary><i>All TensorFlow Versions (CPU)</i></summary>

| TensorFlow Version | Architecture | Image:Tag |
| :---: | :---: | --- |
| latest | amd64, arm64 | `rwthika/tensorflow-cc:latest` |
| 2.9.3 | amd64, arm64 | `rwthika/tensorflow-cc:2.9.3` |
| 2.9.2 | amd64, arm64 | `rwthika/tensorflow-cc:2.9.2` |
| 2.9.1 | amd64 | `rwthika/tensorflow-cc:2.9.1` |
| 2.9.0 | amd64 | `rwthika/tensorflow-cc:2.9.0` |
| 2.8.4 | amd64, arm64 | `rwthika/tensorflow-cc:2.8.4` |
| 2.8.3 | amd64 | `rwthika/tensorflow-cc:2.8.3` |
| 2.8.2 | amd64 | `rwthika/tensorflow-cc:2.8.2` |
| 2.8.1 | amd64 | `rwthika/tensorflow-cc:2.8.1` |
| 2.8.0 | amd64 | `rwthika/tensorflow-cc:2.8.0` |
| 2.7.4 | amd64 | `rwthika/tensorflow-cc:2.7.4` |
| 2.7.3 | amd64 | `rwthika/tensorflow-cc:2.7.3` |
| 2.7.2 | amd64 | `rwthika/tensorflow-cc:2.7.2` |
| 2.7.1 | amd64 | `rwthika/tensorflow-cc:2.7.1` |
| 2.7.0 | amd64 | `rwthika/tensorflow-cc:2.7.0` |
| 2.6.1 | amd64 | `rwthika/tensorflow-cc:2.6.1` |
| 2.6.0 | amd64 | `rwthika/tensorflow-cc:2.6.0` |
| 2.5.1 | amd64 | `rwthika/tensorflow-cc:2.5.1` |
| 2.5.0 | amd64 | `rwthika/tensorflow-cc:2.5.0` |
| 2.4.3 | amd64 | `rwthika/tensorflow-cc:2.4.3` |
| 2.4.2 | amd64 | `rwthika/tensorflow-cc:2.4.2` |
| 2.4.1 | amd64 | `rwthika/tensorflow-cc:2.4.1` |
| 2.4.0 | amd64 | `rwthika/tensorflow-cc:2.4.0` |
| 2.3.4 | amd64 | `rwthika/tensorflow-cc:2.3.4` |
| 2.3.3 | amd64 | `rwthika/tensorflow-cc:2.3.3` |
| 2.3.2 | amd64 | `rwthika/tensorflow-cc:2.3.2` |
| 2.3.1 | amd64 | `rwthika/tensorflow-cc:2.3.1` |
| 2.3.0 | amd64 | `rwthika/tensorflow-cc:2.3.0` |
| 2.0.4 | amd64 | `rwthika/tensorflow-cc:2.0.4` |
| 2.0.3 | amd64 | `rwthika/tensorflow-cc:2.0.3` |
| 2.0.1 | amd64 | `rwthika/tensorflow-cc:2.0.1` |
| 2.0.0 | amd64 | `rwthika/tensorflow-cc:2.0.0` |

</details>


## Build

If you would like to build the deb-package and Docker images yourself, use the [`Makefile`](Makefile) as instructed below.

All `make` targets support the flags `TF_VERSION` (defaults to `2.9.3`), `GPU` (defaults to `1`), and `ARCH` (defaults to host architecture) in order to build a specific TensorFlow version in CPU/GPU mode for a specific architecture.

All `make` targets listed below also have a counterpart named `<target>-all`, which can be used to build multiple TensorFlow versions one after the other using the `TF_VERSIONS` flag like so:

```shell
make 0-download-official-dockerfiles-all TF_VERSIONS="2.9.0 2.8.0 2.7.0"
```

#### 0. Download Dockerfiles from TensorFlow repository

This downloads the directory [`tensorflow/tools/dockerfiles/` from the TensorFlow repository](https://github.com/tensorflow/tensorflow/tree/master/tensorflow/tools/dockerfiles).

```shell
make 0-download-official-dockerfiles
```

#### 1. Build TensorFlow Development Image

This builds a TensorFlow development image `tensorflow/tensorflow:X.Y.Z-devel[-gpu]` based on the Dockerfile downloaded from the TensorFlow repository.

```shell
make 1-build-official-devel-image
```

#### 2. Build TensorFlow C++ Image

Based on the development image, this builds the TensorFlow C++ library `libtensorflow_cc.so` and installs it in a runtime image `rwthika/tensorflow-cc:X.Y.Z[-gpu]`, including both Python and C++ TensorFlow. In an intermediate Docker build stage, a deb-package `libtensorflow-cc_X.Y.Z[-gpu].deb` is created.

```shell
make 2-build-cpp-image
```

#### 3. Export TensorFlow C++ Library Installation Package

This exports the deb-package `libtensorflow-cc_X.Y.Z[-gpu].deb` to the [`libtensorflow-cc`](libtensorflow-cc/) output folder.

```shell
make 3-export-libtensorflow-cc
```

#### 4. Test TensorFlow C++

This installs builds and runs the [example application](example/) inside a container of the runtime image.

```shell
make 4-test-libtensorflow-cc
```

#### 5. Print Versions of Build Tools

This prints the exact version numbers of all tools involved in the build process.

```shell
make 5-print-versions
```


## Supported TensorFlow Versions

<details>
<summary><i>Show Table</i></summary>

| Version | Architecture | Step 1 (CPU) | Step 2 (CPU) | Step 4 (CPU) | Step 1 (GPU) | Step 2 (GPU) | Step 4 (GPU) | Notes |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | --- |
| 2.9.3 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
| 2.9.3 | arm64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
| 2.9.2 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
| 2.9.2 | arm64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
| 2.9.1 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
| 2.9.0 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
| 2.8.4 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
| 2.8.4 | arm64 | ??? | ??? | ??? | ??? | ??? | ??? |  |
| 2.8.3 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
| 2.8.2 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
| 2.8.1 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
| 2.8.0 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
| 2.7.4 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
| 2.7.3 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
| 2.7.2 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
| 2.7.1 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
| 2.7.0 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: | :white_check_mark: |  |
| 2.6.5 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | missing image `tensorflow/tensorflow:2.6.5`; unable to locate `libcudnn7=8.1.0.77-1+cuda11.2` |
| 2.6.4 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | missing image `tensorflow/tensorflow:2.6.4`; unable to locate `libcudnn7=8.1.0.77-1+cuda11.2` |
| 2.6.3 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | missing image `tensorflow/tensorflow:2.6.3`; unable to locate `libcudnn7=8.1.0.77-1+cuda11.2` |
| 2.6.2 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | missing image `tensorflow/tensorflow:2.6.2`; unable to locate `libcudnn7=8.1.0.77-1+cuda11.2` |
| 2.6.1 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=8.1.0.77-1+cuda11.2` |
| 2.6.0 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=8.1.0.77-1+cuda11.2` |
| 2.5.3 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | missing image `tensorflow/tensorflow:2.5.3`; unable to locate `libcudnn7=8.1.0.77-1+cuda11.2` |
| 2.5.2 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | missing image `tensorflow/tensorflow:2.5.2`; unable to locate `libcudnn7=8.1.0.77-1+cuda11.2` |
| 2.5.1 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=8.1.0.77-1+cuda11.2` |
| 2.5.0 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=8.1.0.77-1+cuda11.2` |
| 2.4.4 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | missing image `tensorflow/tensorflow:2.4.4`; unable to locate `libcudnn7=8.0.4.30-1+cuda11.0` |
| 2.4.3 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=8.0.4.30-1+cuda11.0` |
| 2.4.2 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=8.0.4.30-1+cuda11.0` |
| 2.4.1 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=8.0.4.30-1+cuda11.0` |
| 2.4.0 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=8.0.4.30-1+cuda11.0` |
| 2.3.4 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=7.6.4.38-1+cuda10.1` |
| 2.3.3 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=7.6.4.38-1+cuda10.1` |
| 2.3.2 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=7.6.4.38-1+cuda10.1` |
| 2.3.1 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=7.6.4.38-1+cuda10.1` |
| 2.3.0 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=7.6.4.38-1+cuda10.1` |
| 2.2.3 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | no module named `numpy`; unable to locate `libcudnn7=7.6.4.38-1+cuda10.1` |
| 2.2.2 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | no module named `numpy`; unable to locate `libcudnn7=7.6.4.38-1+cuda10.1` |
| 2.2.1 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | no module named `numpy`; unable to locate `libcudnn7=7.6.4.38-1+cuda10.1` |
| 2.2.0 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | no module named `numpy`; unable to locate `libcudnn7=7.6.4.38-1+cuda10.1` |
| 2.1.4 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | no module named `numpy`; unable to locate `libcudnn7=7.6.2.24-1+cuda10.0` |
| 2.1.3 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | no module named `numpy`; unable to locate `libcudnn7=7.6.2.24-1+cuda10.0` |
| 2.1.2 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | no module named `numpy`; unable to locate `libcudnn7=7.6.2.24-1+cuda10.0` |
| 2.1.1 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | no module named `numpy`; unable to locate `libcudnn7=7.6.2.24-1+cuda10.0` |
| 2.1.0 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | no module named `numpy`; unable to locate `libcudnn7=7.6.2.24-1+cuda10.0` |
| 2.0.4 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=7.6.2.24-1+cuda10.0` |
| 2.0.3 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=7.6.2.24-1+cuda10.0` |
| 2.0.2 | amd64 | :white_check_mark: | :x: | - | :x: | - | - | missing image `tensorflow/tensorflow:2.0.2`; unable to locate `libcudnn7=7.6.2.24-1+cuda10.0` |
| 2.0.1 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=7.6.2.24-1+cuda10.0` |
| 2.0.0 | amd64 | :white_check_mark: | :white_check_mark: | :white_check_mark: | :x: | - | - | unable to locate `libcudnn7=7.6.2.24-1+cuda10.0` |

</details>


### Version Matrix

<details>
<summary><i>Show Table</i></summary>

| TensorFlow | Architecture | Ubuntu | GCC | Bazel | Python | protobuf | CUDA | cuDNN | TensorRT | GPU Compute Capability |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2.9.3 | amd64 | 20.04 | 9.4.0 | 5.3.2 | 3.8.10 | 3.9.2 | 11.2.152 | 8.1.0 | 7.2.2 | 8.6, 8.0, 7.5, 7.2, 7.0, 6.1, 6.0, 5.3 |
| 2.9.3 | arm64 | 20.04 | 9.4.0 | 6.0.0 | 3.8.10 | 3.9.2 | 11.4.239 | 8.4.1 | 8.4.1 | 8.7, 8.6, 8.0, 7.5, 7.2, 7.0, 6.1, 6.0, 5.3 |
| 2.9.2 | amd64 | 20.04 | 9.4.0 | 5.3.1 | 3.8.10 | 3.9.2 | 11.2.152 | 8.1.0 | 7.2.2 | 8.6, 8.0, 7.5, 7.2, 7.0, 6.1, 6.0, 5.3 |
| 2.9.2 | arm64 | 20.04 | 9.4.0 | 5.3.2 | 3.8.10 | 3.9.2 | 11.4.239 | 8.4.1 | 8.4.1 | 8.7, 8.6, 8.0, 7.5, 7.2, 7.0, 6.1, 6.0, 5.3 |
| 2.9.1 | amd64 | 20.04 | 9.4.0 | 5.3.0 | 3.8.10 | 3.9.2 | 11.2.152 | 8.1.0 | 7.2.2 | 8.6, 8.0, 7.5, 7.2, 7.0, 6.1, 6.0, 5.3 |
| 2.9.0 | amd64 | 20.04 | 9.4.0 | 5.3.0 | 3.8.10 | 3.9.2 | 11.2.152 | 8.1.0 | 7.2.2 | 8.6, 8.0, 7.5, 7.2, 7.0, 6.1, 6.0, 5.3 |
| 2.8.4 | amd64 | 20.04 | 9.4.0 | 4.2.1 | 3.8.10 | 3.9.2 | 11.2.152 | 8.1.0 | 7.2.2 | 8.6, 8.0, 7.5, 7.2, 7.0, 6.1, 6.0, 5.3 |
| 2.8.4 | arm64 | 20.04 | TODO | TODO | TODO | TODO | TODO | TODO | TODO | TODO |
| 2.8.3 | amd64 | 20.04 | 9.4.0 | 4.2.1 | 3.8.10 | 3.9.2 | 11.2.152 | 8.1.0 | 7.2.2 | 8.6, 8.0, 7.5, 7.2, 7.0, 6.1, 6.0, 5.3 |
| 2.8.2 | amd64 | 20.04 | 9.4.0 | 4.2.1 | 3.8.10 | 3.9.2 | 11.2.152 | 8.1.0 | 7.2.2 | 8.6, 8.0, 7.5, 7.2, 7.0, 6.1, 6.0, 5.3 |
| 2.8.1 | amd64 | 20.04 | 9.4.0 | 4.2.1 | 3.8.10 | 3.9.2 | 11.2.152 | 8.1.0 | 7.2.2 | 8.6, 8.0, 7.5, 7.2, 7.0, 6.1, 6.0, 5.3 |
| 2.8.0 | amd64 | 20.04 | 9.4.0 | 4.2.1 | 3.8.10 | 3.9.2 | 11.2.152 | 8.1.0 | 7.2.2 | 8.6, 8.0, 7.5, 7.2, 7.0, 6.1, 6.0, 5.3 |
| 2.7.4 | amd64 | 20.04 | 9.4.0 | 3.7.2 | 3.8.10 | 3.9.2 | 11.2.152 | 8.1.0 | 8.0.0 | 8.6, 8.0, 7.5, 7.2, 7.0, 6.1, 6.0, 5.3 |
| 2.7.3 | amd64 | 20.04 | 9.4.0 | 3.7.2 | 3.8.10 | 3.9.2 | 11.2.152 | 8.1.0 | 8.0.0 | 8.6, 8.0, 7.5, 7.2, 7.0, 6.1, 6.0, 5.3 |
| 2.7.2 | amd64 | 20.04 | 9.4.0 | 3.7.2 | 3.8.10 | 3.9.2 | 11.2.152 | 8.1.0 | 8.0.0 | 8.6, 8.0, 7.5, 7.2, 7.0, 6.1, 6.0, 5.3 |
| 2.7.1 | amd64 | 20.04 | 9.4.0 | 3.7.2 | 3.8.10 | 3.9.2 | 11.2.152 | 8.1.0 | 8.0.0 | 8.6, 8.0, 7.5, 7.2, 7.0, 6.1, 6.0, 5.3 |
| 2.7.0 | amd64 | 20.04 | 9.4.0 | 3.7.2 | 3.8.10 | 3.9.2 | 11.2.152 | 8.1.0 | 8.0.0 | 8.6, 8.0, 7.5, 7.2, 7.0, 6.1, 6.0, 5.3 |
| 2.6.5 | amd64 | 18.04 | 7.5.0 | 3.7.2 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.6.4 | amd64 | 18.04 | 7.5.0 | 3.7.2 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.6.3 | amd64 | 18.04 | 7.5.0 | 3.7.2 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.6.2 | amd64 | 18.04 | 7.5.0 | 3.7.2 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.6.1 | amd64 | 18.04 | 7.5.0 | 3.7.2 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.6.0 | amd64 | 18.04 | 7.5.0 | 3.7.2 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.5.3 | amd64 | 18.04 | 7.5.0 | 3.7.2 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.5.2 | amd64 | 18.04 | 7.5.0 | 3.7.2 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.5.1 | amd64 | 18.04 | 7.5.0 | 3.7.2 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.5.0 | amd64 | 18.04 | 7.5.0 | 3.7.2 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.4.4 | amd64 | 18.04 | 7.5.0 | 3.1.0 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.4.3 | amd64 | 18.04 | 7.5.0 | 3.1.0 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.4.2 | amd64 | 18.04 | 7.5.0 | 3.1.0 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.4.1 | amd64 | 18.04 | 7.5.0 | 3.1.0 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.4.0 | amd64 | 18.04 | 7.5.0 | 3.1.0 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.3.4 | amd64 | 18.04 | 7.5.0 | 3.1.0 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.3.3 | amd64 | 18.04 | 7.5.0 | 3.1.0 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.3.2 | amd64 | 18.04 | 7.5.0 | 3.1.0 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.3.1 | amd64 | 18.04 | 7.5.0 | 3.1.0 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.3.0 | amd64 | 18.04 | 7.5.0 | 3.1.0 | 3.6.9 | 3.9.2 | - | - | - | - |
| 2.2.3 | amd64 | 18.04 | 7.5.0 | 2.0.0 | 2.7.17 | 3.8.0 | - | - | - | - |
| 2.2.2 | amd64 | 18.04 | 7.5.0 | 2.0.0 | 2.7.17 | 3.8.0 | - | - | - | - |
| 2.2.1 | amd64 | 18.04 | 7.5.0 | 2.0.0 | 2.7.17 | 3.8.0 | - | - | - | - |
| 2.2.0 | amd64 | 18.04 | 7.5.0 | 2.0.0 | 2.7.17 | 3.8.0 | - | - | - | - |
| 2.1.4 | amd64 | 18.04 | 7.5.0 | 0.29.1 | 2.7.17 | 3.8.0 | - | - | - | - |
| 2.1.3 | amd64 | 18.04 | 7.5.0 | 0.29.1 | 2.7.17 | 3.8.0 | - | - | - | - |
| 2.1.2 | amd64 | 18.04 | 7.5.0 | 0.29.1 | 2.7.17 | 3.8.0 | - | - | - | - |
| 2.1.1 | amd64 | 18.04 | 7.5.0 | 0.29.1 | 2.7.17 | 3.8.0 | - | - | - | - |
| 2.1.0 | amd64 | 18.04 | 7.5.0 | 0.29.1 | 2.7.17 | 3.8.0 | - | - | - | - |
| 2.0.4 | amd64 | 18.04 | 7.5.0 | 0.26.1 | 2.7.17 | 3.8.0 | - | - | - | - |
| 2.0.3 | amd64 | 18.04 | 7.5.0 | 0.26.1 | 2.7.17 | 3.8.0 | - | - | - | - |
| 2.0.2 | amd64 | 18.04 | 7.5.0 | 0.26.1 | 2.7.17 | 3.8.0 | - | - | - | - |
| 2.0.1 | amd64 | 18.04 | 7.5.0 | 0.26.1 | 2.7.17 | 3.8.0 | - | - | - | - |
| 2.0.0 | amd64 | 18.04 | 7.5.0 | 0.26.1 | 2.7.17 | 3.8.0 | - | - | - | - |

</details>


## Acknowledgements

This work is accomplished within the projects [6GEM](https://6gem.de/) (FKZ 16KISK038) and [UNICAR*agil*](https://www.unicaragil.de/) (FKZ 16EMO0284K). We acknowledge the financial support for the projects by the Federal Ministry of Education and Research of Germany (BMBF).


## Notice

This repository is not endorsed by or otherwise affiliated with [TensorFlow](https://www.tensorflow.org) or Google. TensorFlow, the TensorFlow logo and any related marks are trademarks of Google Inc. [TensorFlow](https://github.com/tensorflow/tensorflow) is released under the [Apache License 2.0](https://github.com/tensorflow/tensorflow/blob/master/LICENSE).
