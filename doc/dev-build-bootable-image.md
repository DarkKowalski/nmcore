# Build bootable image for development

We should use UEFI instead of BIOS legacy boot.

We use [rEFInd](https://www.rodsbooks.com/refind/) as the boot manager in the development environment.

The kernel should be loaded using [EFI boot stub](https://www.kernel.org/doc/html/latest/admin-guide/efi-stub.html).

## ENV variable

```txt
BUILD_DIR=/path/to/start
PROJECT_ROOT/path/to/project_root
REFIND_BIN=/path/to/refind-bin
```

## Script

```bash
build/script/dev-build.sh
```

## Sequence

1. Create disk image filled with zero
2. Create `ESP` partition for the image
3. Copy boot manager into `ESP`