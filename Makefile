# Copyright (C) 2022 Xilinx, Inc

# SPDX-License-Identifier: BSD-3-Clause

ROOT_PATH := $(abspath $(dir $(firstword $(MAKEFILE_LIST))))

PREBUILT_IMAGE := ${ROOT_PATH}/aarch64_prebuilt_image_3.0.0.tar.gz
PREBUILT_SDIST := ${ROOT_PATH}/pynq-3.0.0.tar.gz

all: gitsubmodule base image
	echo ${ROOT_PATH}

image: gitsubmodule ${PREBUILT_SDIST} ${PREBUILT_IMAGE}
	cd ${ROOT_PATH}/pynq/sdbuild/ && make BOARDDIR=${ROOT_PATH}/ BOARDS=Pynq-ZU PYNQ_SDIST=${PREBUILT_SDIST} PYNQ_ROOTFS=${PREBUILT_IMAGE}

base: ${BOARD_FILES} ${ROOT_PATH}/Pynq-ZU/base/base.bit
	
${ROOT_PATH}/Pynq-ZU/base/base.bit:
	cd ${ROOT_PATH}/Pynq-ZU/base && make

gitsubmodule:
	git submodule init && git submodule update

${PREBUILT_IMAGE}:
	# TODO update link
	#wget https://bit.ly/pynq_aarch64_3_0 -O $@
	@echo "Got $@"

${PREBUILT_SDIST}:
	# TODO update link
	#wget https://github.com/Xilinx/PYNQ/releases/download/v2.7.0/pynq-2.7.0.tar.gz -O $@
	@echo "Got $@"

cleanbuild:
	sudo make -C pynq/sdbuild/ clean
	cd Pynq-ZU/packages/ && rm -rf pynqmb_grove/pynq/lib/gc/bsp_iop_grove/ pynqmb_grove/pynq/lib/rpi/ pynqmb_grove/pynq_git/