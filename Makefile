# Copyright (C) 2022 Xilinx, Inc
# Copyright (c) 2022-2025, Advanced Micro Devices, Inc.

# SPDX-License-Identifier: BSD-3-Clause

ROOT_PATH := $(abspath $(dir $(firstword $(MAKEFILE_LIST))))

PREBUILT_IMAGE := ${ROOT_PATH}/pynq/sdbuild/prebuilt/pynq_rootfs.aarch64.tar.gz
PREBUILT_SDIST := ${ROOT_PATH}/pynq/sdbuild/prebuilt/pynq_sdist.tar.gz

all: gitsubmodule base image
	echo ${ROOT_PATH}

image: gitsubmodule ${PREBUILT_SDIST} ${PREBUILT_IMAGE}
	cd ${ROOT_PATH}/pynq/sdbuild/ && make BOARDDIR=${ROOT_PATH}/ BOARDS=Pynq-ZU PYNQ_SDIST=${PREBUILT_SDIST} PYNQ_ROOTFS=${PREBUILT_IMAGE}

base: ${BOARD_FILES} ${ROOT_PATH}/Pynq-ZU/base/base.bit
	
${ROOT_PATH}/Pynq-ZU/base/base.bit:
	cd ${ROOT_PATH}/Pynq-ZU/base && make

gitsubmodule:
	@echo "Updating submodule"
	git submodule init && git submodule update

${PREBUILT_IMAGE}:
	wget https://download.amd.com/opendownload/pynq/jammy.aarch64.3.1.0.tar.gz -O $@
	@echo "Got $@"

${PREBUILT_SDIST}:
	wget https://download.amd.com/opendownload/pynq/pynq-3.1.tar.gz -O $@
	@echo "Got $@"

cleanbuild:
	sudo make -C pynq/sdbuild/ clean
