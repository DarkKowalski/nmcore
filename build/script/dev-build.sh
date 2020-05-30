#!/bin/bash

# Test ENV
if [[ -z "${BUILD_DIR}" ]]; then
  echo "[ERROR]: BUILD_DIR is missing."
  exit 1
else
  echo "[INFO]: BUILD_DIR=${BUILD_DIR}"
fi

if [[ -z "${PROJECT_ROOT}" ]]; then
  echo "[ERROR]: PROJECT_ROOT is missing."
  exit 1
else
  echo "[INFO]: PROJECT_ROOT=${PROJECT_ROOT}"
fi

if [[ -z "${REFIND_BIN}" ]]; then
  echo "[ERROR]: REFIND_BIN is missing."
  exit 1
else
  echo "[INFO]: REFIND_BIN=${REFIND_BIN}"
fi

mkdir -p ${BUILD_DIR}/dev-build/mnt

echo "[INFO]: Create empty disk image(512MB):"
# 512-byte sector, 512 MB (1MB = 1024KB, 1KB = 1024B)
dd if=/dev/zero of=${BUILD_DIR}/dev-build/dev-nmcore.img bs=512 count=1048576
if [[ $? -ne 0 ]]; then
    echo "[ERROR]: Faild to create disk image."
    exit 1
fi

echo "[INFO]: Initialize partitions:"
sudo sgdisk --zap-all ${BUILD_DIR}/dev-build/dev-nmcore.img
sudo sgdisk --clear --mbrtopgt ${BUILD_DIR}/dev-build/dev-nmcore.img
# 1M space for BIOS/GRUB
sudo sgdisk --new 1:2048:4095 --change-name 1:"GRUB" --typecode 1:ef02 ${BUILD_DIR}/dev-build/dev-nmcore.img
# 128M space for ESP
sudo sgdisk --new 2:4096:266239 --change-name 2:"EFI" --typecode 2:ef00 --attributes "2:set:2" ${BUILD_DIR}/dev-build/dev-nmcore.img
sudo sgdisk --print ${BUILD_DIR}/dev-build/dev-nmcore.img
if [[ $? -ne 0 ]]; then
    echo "[ERROR]: Faild to initialize partitions."
    exit 1
fi

echo "[INFO]: Mount ESP to copy file"
# Make filesystem then mount ESP, 4096 512-byte sectors = 2097152B, 128MB = 134217728B
sudo losetup --offset 2097152 --sizelimit 134217728 /dev/loop0 ${BUILD_DIR}/dev-build/dev-nmcore.img
sudo mkdosfs -F 32 /dev/loop0
sudo mount /dev/loop0 ${BUILD_DIR}/dev-build/mnt
if [[ $? -ne 0 ]]; then
    echo "[ERROR]: Faild to mount ESP."
    exit 1
fi

sudo mkdir -p ${BUILD_DIR}/dev-build/mnt/EFI/refind
# Target amd64
sudo cp ${REFIND_BIN}/refind/refind_x64.efi ${BUILD_DIR}/dev-build/mnt/EFI/refind
sudo cp ${REFIND_BIN}/refind/refind.conf-sample ${BUILD_DIR}/dev-build/mnt/EFI/refind/refind.conf
sudo cp -r ${REFIND_BIN}/refind/icons ${BUILD_DIR}/dev-build/mnt/EFI/refind

echo "[INFO]: Umount ESP"
sudo umount /dev/loop0
sudo losetup -d /dev/loop0
rm -rf ${BUILD_DIR}/dev-build/mnt
if [[ $? -eq 0 ]]; then
    echo "[INFO]: Done!"
fi

