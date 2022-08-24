# === VARIABLES ================================================================

MAKEFLAGS += --no-print-directory
MAKEFILE_DIR := $(shell dirname $(abspath $(lastword $(MAKEFILE_LIST))))

# defaults
DEFAULT_TF_VERSION := 2.9.1
TF_VERSIONS := 2.9.1 2.9.0 2.8.2 2.8.1 2.8.0 2.7.3 2.7.2 2.7.1 2.7.0 2.6.5 2.6.4 2.6.3 2.6.2 2.6.1 2.6.0 2.5.3 2.5.2 2.5.1 2.5.0 2.4.4 2.4.3 2.4.2 2.4.1 2.4.0 2.3.4 2.3.3 2.3.2 2.3.1 2.3.0 2.2.3 2.2.2 2.2.1 2.2.0 2.1.4 2.1.3 2.1.2 2.1.1 2.1.0 2.0.4 2.0.3 2.0.2 2.0.1 2.0.0
DEFAULT_JOBS := $(shell nproc)
DEFAULT_GPU := 1

# arguments
TF_VERSION := $(if $(TF_VERSION),$(TF_VERSION),$(DEFAULT_TF_VERSION))
JOBS := $(if $(JOBS),$(JOBS),$(DEFAULT_JOBS))
GPU := $(if $(GPU),$(GPU),$(DEFAULT_GPU))

# variables
ifeq ($(GPU), 1)
	GPU_POSTFIX := -gpu
else
	GPU_POSTFIX := 
endif
OFFICIAL_DEVEL_IMAGE := tensorflow/tensorflow:$(TF_VERSION)-devel$(GPU_POSTFIX)
OFFICIAL_DEVEL_IMAGES := tensorflow/tensorflow:*-devel$(GPU_POSTFIX)
CPP_IMAGE := gitlab.ika.rwth-aachen.de:5050/automated-driving/docker/tensorflow:$(TF_VERSION)-py-cpp$(GPU_POSTFIX)
CPP_IMAGES := gitlab.ika.rwth-aachen.de:5050/automated-driving/docker/tensorflow:*-py-cpp*
LIBTENSORFLOW_CC_IMAGE := gitlab.ika.rwth-aachen.de:5050/automated-driving/docker/tensorflow:$(TF_VERSION)-libtensorflow_cc*
LIBTENSORFLOW_CC_IMAGES := gitlab.ika.rwth-aachen.de:5050/automated-driving/docker/tensorflow:*-libtensorflow_cc*

# === HELPER RULES =============================================================

.PHONY: help
help:
	@LC_ALL=C $(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/(^|\n)# Files(\n|$$)/,/(^|\n)# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'

# ----- LIST IMAGES ------------------------------------------------------------

.PHONY: list-official-devel-images
list-official-devel-images:
	@docker images --format "{{.Repository}}:{{.Tag}}" --filter=reference="$(OFFICIAL_DEVEL_IMAGES)"

.PHONY: list-cpp-images
list-cpp-images:
	@docker images --format "{{.Repository}}:{{.Tag}}" --filter=reference="$(CPP_IMAGES)"

.PHONY: list-libtensorflow-cc-images
list-libtensorflow-cc-images:
	@docker images --format "{{.Repository}}:{{.Tag}}" --filter=reference="$(LIBTENSORFLOW_CC_IMAGES)"

.PHONY: list-images
list-images: list-official-devel-images list-cpp-images list-libtensorflow-cc-images

# ----- CLEAN IMAGES -----------------------------------------------------------

.PHONY: clean-official-devel-image
clean-official-devel-image:
	@docker rmi -f $(shell docker images --format "{{.Repository}}:{{.Tag}}" --filter=reference="$(OFFICIAL_DEVEL_IMAGE)") 2> /dev/null || true

.PHONY: clean-cpp-image
clean-cpp-image:
	@docker rmi -f $(shell docker images --format "{{.Repository}}:{{.Tag}}" --filter=reference="$(CPP_IMAGE)") 2> /dev/null || true

.PHONY: clean-libtensorflow-cc-image
clean-libtensorflow-cc-image:
	@docker rmi -f $(shell docker images --format "{{.Repository}}:{{.Tag}}" --filter=reference="$(LIBTENSORFLOW_CC_IMAGE)") 2> /dev/null || true

.PHONY: clean-official-devel-images
clean-official-devel-images:
	$(foreach TF_VERSION,$(TF_VERSIONS),TF_VERSION=$(TF_VERSION) $(MAKE) clean-official-devel-image;)

.PHONY: clean-cpp-images
clean-cpp-images:
	$(foreach TF_VERSION,$(TF_VERSIONS),TF_VERSION=$(TF_VERSION) $(MAKE) clean-cpp-image;)

.PHONY: clean-libtensorflow-cc-images
clean-libtensorflow-cc-images:
	$(foreach TF_VERSION,$(TF_VERSIONS),TF_VERSION=$(TF_VERSION) $(MAKE) clean-libtensorflow-cc-image;)

.PHONY: clean-images
clean-images: clean-official-devel-images clean-cpp-images clean-libtensorflow-cc-images

# === RULES ====================================================================

# ----- SINGLE VERSION RULES ---------------------------------------------------

.PHONY: 0-download-official-dockerfiles
0-download-official-dockerfiles:
	$(MAKEFILE_DIR)/scripts/$@.sh

.PHONY: 1-build-official-devel-image
1-build-official-devel-image: 0-download-official-dockerfiles
	$(MAKEFILE_DIR)/scripts/$@.sh

.PHONY: 2-build-cpp-image
2-build-cpp-image: 1-build-official-devel-image
	$(MAKEFILE_DIR)/scripts/$@.sh

.PHONY: 3-export-libtensorflow-cc
3-export-libtensorflow-cc: 2-build-cpp-image
	$(MAKEFILE_DIR)/scripts/$@.sh

.PHONY: 4-test-libtensorflow-cc
4-test-libtensorflow-cc: 2-build-cpp-image
	$(MAKEFILE_DIR)/scripts/$@.sh

.PHONY: 5-print-versions
5-print-versions: 2-build-cpp-image
	$(MAKEFILE_DIR)/scripts/$@.sh

# ----- MULTI VERSION RULES ----------------------------------------------------

.PHONY: 0-download-official-dockerfiles-all
0-download-official-dockerfiles-all:
	$(foreach TF_VERSION,$(TF_VERSIONS),TF_VERSION=$(TF_VERSION) $(MAKE) 0-download-official-dockerfiles;)

.PHONY: 1-build-official-devel-image-all
1-build-official-devel-image-all:
	$(foreach TF_VERSION,$(TF_VERSIONS),TF_VERSION=$(TF_VERSION) $(MAKE) 1-build-official-devel-image;)

.PHONY: 2-build-cpp-image-all
2-build-cpp-image-all:
	$(foreach TF_VERSION,$(TF_VERSIONS),TF_VERSION=$(TF_VERSION) $(MAKE) 2-build-cpp-image;)

.PHONY: 3-export-libtensorflow-cc-all
3-export-libtensorflow-cc-all:
	$(foreach TF_VERSION,$(TF_VERSIONS),TF_VERSION=$(TF_VERSION) $(MAKE) 3-export-libtensorflow-cc;)

.PHONY: 4-test-libtensorflow-cc-all
4-test-libtensorflow-cc-all:
	$(foreach TF_VERSION,$(TF_VERSIONS),TF_VERSION=$(TF_VERSION) $(MAKE) 4-test-libtensorflow-cc;)

.PHONY: 5-print-versions-all
5-print-versions-all:
	$(foreach TF_VERSION,$(TF_VERSIONS),TF_VERSION=$(TF_VERSION) $(MAKE) 5-print-versions;)
