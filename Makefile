BUILD_DIR = build/x86

C_SOURCES = $(wildcard kernel/*.c drivers/*.c)
HEADERS   = $(wildcard kernel/*.h drivers/*.h)

OBJECT_FILES = ${C_SOURCES:.c=.o}

all: os-image

sim: all
	qemu-system-x86_64 -chardev stdio,id=seabios -device isa-debugcon,iobase=0x402,chardev=seabios -drive file=$(BUILD_DIR)/img/os-image

os-image: $(BUILD_DIR)/boot/boot_sector.bin $(BUILD_DIR)/kernel/kernel.bin
	cat $^ > $(BUILD_DIR)/img/os-image

$(BUILD_DIR)/kernel/kernel.bin: $(BUILD_DIR)/kernel/kernel_entry.o $(BUILD_DIR)/${OBJECT_FILES}
	ld -o $@ -Ttext 0x1000 $^ --oformat binary

$(BUILD_DIR)/%.o : %.c ${HEADERS}
	gcc -ffreestanding -c $< -o $@

$(BUILD_DIR)/%.o : %.asm
	nasm $< -f elf64 -o $@

$(BUILD_DIR)/%.bin : %.asm
	@echo Assembling $< to $@
	nasm $< -f bin -I 'boot/lib16' -o $@

clean:
	# rm -fr *.bin *.dis *.o os-image
	rm -f $(BUILD_DIR)/img/* $(BUILD_DIR)/boot/*.bin $(BUILD_DIR)/kernel/*.o $(BUILD_DIR)/kernel/*.bin  drivers/*.o
