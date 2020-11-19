CFLAGS = -g -ffreestanding -Wall -Wextra -fno-exceptions
CC = x86_64-elf-gcc

LD = x86_64-elf-ld
AS = x86_64-elf-as
OBJCOPY = x86_64-elf-objcopy
OBJDUMP = x86_64-elf-objdump

GDB = gdb

QEMU = qemu-system-x86_64

run: bootsect.bin

bootsect.bin: builddir
	${CC} ${CFLAGS} -Wl,-T ./boot/linker.ld -Wl,--oformat=binary -nostdlib -o ./build/bootsect.bin boot/bootsect.S

builddir:
	mkdir -p ./build

qemu: bootsect.bin
	${QEMU} -fda ./build/bootsect.bin

qemu-cli: bootsect.bin
	${QEMU} -fda ./build/bootsect.bin -nographic

disasm: bootsect.bin
	${OBJDUMP} -b binary -m i386 -D ./build/bootsect.bin --adjust-vma 0x7c00

clean:
	rm -rfv ./build
