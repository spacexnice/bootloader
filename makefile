CC=gcc
LD=ld
LDFILE=b.ld
OBJCOPY=objcopy

all: boot.img

boot.o: boot.S
	$(CC) -c boot.S
boot.elf: boot.o
	$(LD) boot.o -o boot.elf -e start -T$(LDFILE)
boot.bin : boot.elf
	$(OBJCOPY) -R .pdr -R .comment -R .not -S -O binary boot.elf boot.bin

boot.img : boot.bin
	@dd if=boot.bin of=boot.img bs=512 count=1
	@dd if=/dev/zero of=boot.img skip=1 seek=1 bs=1024 count=22879
	@mount boot.img mnt
	@cp README mnt/boot.txt
	@cp makefile mnt/makefile.txt
	@cp boot.S mnt/testlongfile.txt
	@sudo umount mnt/
clean:
	@rm -rf boot.o boot.elf boot.bin boot.img