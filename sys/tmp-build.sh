#!/bin/bash
mkdir -p tmp-build && cd tmp-build

FLAGS="-fno-builtin -O2 -nostdinc -nostdlib -ffreestanding -g -Wall -Wextra \
               -Werror -I. -MMD -mno-red-zone -mcmodel=kernel -fno-pie \
               -z max-page-size=0x1000 -no-pie -Wl,--build-id=none"
printf "Compile: "
x86_64-elf-gcc ../kernel.c ../arch/amd64/boot.S -c -O2 ${FLAGS}
echo "Done"

printf "Link: "
x86_64-elf-gcc kernel.o boot.o -T ../linker.ld -o dev-nmcore.bin ${FLAGS}
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

mkdir -p isodir/boot/grub
cp ../grub.cfg isodir/boot/grub
cp dev-nmcore.bin isodir/boot
grub-mkrescue -o dev-nmcore.iso isodir
rm -rfv isodir
echo "Done!"

qemu-system-x86_64 -cdrom dev-nmcore.iso -serial stdio -m 1024M --enable-kvm