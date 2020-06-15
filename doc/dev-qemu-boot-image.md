# Boot image with QEMU

## ENV variable

```bash
. build/script/dev-env.sh
```

## Script

```bash
build/script/dev-qemu.sh /path/to/dev-nmcore.img [optional args]
```

## OVMF

We use both QEMU and UEFI thus OVMF should be installed and appropriately configured before we boot the image.

On GNU/Debian bullseye `OVMF_CODE.fd` and `OVMF_VARS.fd` are located at `/usr/share/OVMF`

On Arch Linux `OVMF_CODE.fd` and `OVMF_VARS.fd` are located at `/usr/share/OVMF/x64`