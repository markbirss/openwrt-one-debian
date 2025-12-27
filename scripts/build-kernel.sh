#!/bin/bash
set -e

KERNEL=$1
if [ -z "${KERNEL}" ] ; then
  KERNEL=linux
fi

if [ ! -d ${KERNEL} ] ; then
  git clone --depth 1 -b sjoerd/mtk-openwrt-one-integration \
    https://github.com/sjoerdsimons/linux.git
fi

export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-
export CC=aarch64-linux-gnu-gcc

if [ ! -z "${CONFIG}" ] ; then
  cp -v ${CONFIG} ${KERNEL}/.config
fi

pushd ${KERNEL}
make olddefconfig
make KBUILD_IMAGE=arch/arm64/boot/Image -j$(nproc) bindeb-pkg
