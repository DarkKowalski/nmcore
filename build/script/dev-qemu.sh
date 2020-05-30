#!/bin/bash
IMAGE=$1
if [[ -z "${IMAGE}" ]]; then
  echo "[ERROR]: IMAGE is missing."
  exit 1
fi

OVMF_DIR="/usr/share/OVMF"

qemu-system-x86_64 -cpu qemu64 \
  -drive if=pflash,format=raw,unit=0,file=${OVMF_DIR}/OVMF_CODE.fd,readonly=on \
  -drive if=pflash,format=raw,unit=1,file=${OVMF_DIR}/OVMF_VARS.fd \
  -drive file=${IMAGE},if=ide \
  -net none \
  -s