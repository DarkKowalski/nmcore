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

mkdir -p ${BUILD_DIR}/dev-build && cd ${BUILD_DIR}/dev-build

FLAGS="-fno-builtin -O2 -nostdinc -nostdlib -ffreestanding -g -Wall -Wextra \
               -Werror -I. -MMD -mno-red-zone -mcmodel=kernel -fno-pie \
               -z max-page-size=0x1000 -no-pie -Wl,--build-id=none"
printf "Compile: "
x86_64-elf-gcc ${PROJECT_ROOT}/sys/kernel.c ${PROJECT_ROOT}/sys/arch/amd64/boot.S -c -O2 ${FLAGS}
echo "Done"

printf "Link: "
x86_64-elf-gcc kernel.o boot.o -T ${PROJECT_ROOT}/sys/linker.ld -o dev-nmcore.bin ${FLAGS}
echo "Done"

printf "Check Multiboot2: "
grub-file --is-x86-multiboot2 dev-nmcore.bin
if [[ $? -eq 0 ]]; then
    echo "Confirmed!"
    rm -v boot.o kernel.o
else
    echo "Not multiboot2!"
    exit 1
fi