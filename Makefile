CFLAGS = -g -ffreestanding -Wall -Wextra -fno-exceptions
CC = x86_64-elf-gcc

LD = x86_64-elf-ld
AS = x86_64-elf-as
OBJCOPY = x86_64-elf-objcopy
OBJDUMP = x86_64-elf-objdump

GDB = gdb

QEMU = qemu-system-x86_64

run: bootsect.bin

os-image.bin: bootsect.bin setup.bin
	cat ./build/bootsect.bin ./build/setup.bin > ./build/os-image.bin

bootsect.bin: builddir
	${CC} ${CFLAGS} -Wl,-T ./boot/bootsect.ld -Wl,--oformat=binary -nostdlib -o ./build/bootsect.bin boot/bootsect.S

setup.bin: builddir
	${CC} ${CFLAGS} -Wl,-T ./boot/setup.ld -Wl,--oformat=binary -nostdlib -o ./build/setup.bin boot/setup.S

builddir:
	mkdir -p ./build

qemu: os-image.bin
	${QEMU} -fda ./build/os-image.bin

clean:
	rm -rfv ./build
