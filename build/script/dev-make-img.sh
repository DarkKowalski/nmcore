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
# Rest 380M for root path
sudo sgdisk --new 3:266240:1044479 --change-name 3:"ROOT" --typecode 3:8300 --attributes "3:set:3" ${BUILD_DIR}/dev-build/dev-nmcore.img
sudo sgdisk --print ${BUILD_DIR}/dev-build/dev-nmcore.img
if [[ $? -ne 0 ]]; then
    echo "[ERROR]: Faild to initialize partitions."
    exit 1
fi

sudo losetup /dev/loop0 -P ${BUILD_DIR}/dev-build/dev-nmcore.img
echo "[INFO]: Mount ROOT"
sudo mkfs.ext4 /dev/loop0p3
sudo mount /dev/loop0p3 ${BUILD_DIR}/dev-build/mnt
if [[ $? -ne 0 ]]; then
    echo "[ERROR]: Faild to mount ROOT."
    exit 1
fi
sudo mkdir -p ${BUILD_DIR}/dev-build/mnt/boot/grub
sudo mkdir -p ${BUILD_DIR}/dev-build/mnt/efi

echo "[INFO]: Mount ESP"
sudo mkdosfs -F 32 /dev/loop0p2
sudo mount /dev/loop0p2 ${BUILD_DIR}/dev-build/mnt/efi
if [[ $? -ne 0 ]]; then
    echo "[ERROR]: Faild to mount ESP."
    exit 1
fi

# Install GRUB
sudo grub-install --target=x86_64-efi \
             --efi-directory=${BUILD_DIR}/dev-build/mnt/efi \
             --root-directory=${BUILD_DIR}/dev-build/mnt \
             --bootloader-id=GRUB --removable
sudo cp ${PROJECT_ROOT}/build/config/grub.cfg ${BUILD_DIR}/dev-build/mnt/boot/grub/grub.cfg

# Install Kernel
sudo cp ${BUILD_DIR}/dev-build/dev-nmcore.bin ${BUILD_DIR}/dev-build/mnt/boot/dev-nmcore.bin

echo "[INFO]: Umount BOOT and ESP"
sudo umount /dev/loop0p2
sudo umount /dev/loop0p3
sudo losetup -d /dev/loop0
rm -rf ${BUILD_DIR}/dev-build/mnt
if [[ $? -eq 0 ]]; then
    echo "[INFO]: Done!"
fi

