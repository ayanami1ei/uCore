.PHONY: clean build user
all: build

LOG ?= error

K = os

# ARCH 可以是 riscv 或 x86
ARCH ?= x86

BUILDDIR = build

ifeq ($(ARCH),riscv)
TOOLPREFIX = riscv64-unknown-elf-
QEMU       = qemu-system-riscv64
BOOTLOADER := ./boostloader/rustsbi-qemu.bin
QEMUOPTS   = \
	-m 2G \
	-nographic \
	-machine virt \
	-bios $(BOOTLOADER) \
	-kernel build/kernel \
CFLAGS_ARCH = -DRISCV64 -mcmodel=medany -mno-relax
else ifeq ($(ARCH),x86)
TOOLPREFIX = i386-elf-
QEMU       = qemu-system-i386
# 这里先直接用 -kernel 启动，后续可按需改成 GRUB/BIOS 引导
QEMUOPTS   = \
	-m 2G \
	-nographic \
	-cdrom $(BUILDDIR)/iso/os.iso \
# 32 位 i386 裸机内核常用参数
CFLAGS_ARCH = -DX86 -m32
endif

CC = $(TOOLPREFIX)gcc
AS = $(TOOLPREFIX)gcc
LD = $(TOOLPREFIX)ld
OBJCOPY = $(TOOLPREFIX)objcopy
OBJDUMP = $(TOOLPREFIX)objdump
PY = python3
#GDB = $(TOOLPREFIX)gdb
GDB = gdb-multiarch
CP = cp
MKDIR_P = mkdir -p

C_SRCS = $(wildcard $K/*.c)
ARCH_S_SRCS = $(wildcard $(K)/arch/$(ARCH)/*.S)
ARCH_C_SRCS = $(wildcard $(K)/arch/$(ARCH)/*.c)
ARCH_S_OBJS = $(addprefix $(BUILDDIR)/, $(ARCH_S_SRCS:.S=.o))
ARCH_C_OBJS = $(addprefix $(BUILDDIR)/, $(ARCH_C_SRCS:.c=.o))
C_OBJS = $(addprefix $(BUILDDIR)/, $(addsuffix .o, $(basename $(C_SRCS))))
OBJS = $(C_OBJS) $(ARCH_S_OBJS) $(ARCH_C_OBJS)

HEADER_DEP = $(addsuffix .d, $(basename $(C_OBJS)))

-include $(HEADER_DEP)

CFLAGS = -Wall -Werror -O -fno-omit-frame-pointer -ggdb
CFLAGS += -MD
CFLAGS += -ffreestanding -fno-common -nostdlib
CFLAGS += -I$K
CFLAGS += $(shell $(CC) -fno-stack-protector -E -x c /dev/null >/dev/null 2>&1 && echo -fno-stack-protector)
CFLAGS += $(CFLAGS_ARCH)

ifeq ($(LOG), error)
CFLAGS += -D LOG_LEVEL_ERROR
else ifeq ($(LOG), warn)
CFLAGS += -D LOG_LEVEL_WARN
else ifeq ($(LOG), info)
CFLAGS += -D LOG_LEVEL_INFO
else ifeq ($(LOG), debug)
CFLAGS += -D LOG_LEVEL_DEBUG
else ifeq ($(LOG), trace)
CFLAGS += -D LOG_LEVEL_TRACE
endif

# Disable PIE when possible (for Ubuntu 16.10 toolchain)
ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]no-pie'),)
CFLAGS += -fno-pie -no-pie
endif
ifneq ($(shell $(CC) -dumpspecs 2>/dev/null | grep -e '[^f]nopie'),)
CFLAGS += -fno-pie -nopie
endif

LDFLAGS = -z max-page-size=4096

# user_app 在不同架构下的链接基地址
APP_BASE ?= 0x80400000
ifeq ($(ARCH),x86)
APP_BASE = 0x00400000
endif

$(ARCH_S_OBJS): $(BUILDDIR)/$(K)/arch/$(ARCH)/%.o : $(K)/arch/$(ARCH)/%.S
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

$(ARCH_C_OBJS): $(BUILDDIR)/$(K)/arch/$(ARCH)/%.o : $(K)/arch/$(ARCH)/%.c
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

$(C_OBJS): $(BUILDDIR)/$K/%.o : $K/%.c  $(BUILDDIR)/$K/%.d
	@mkdir -p $(@D)
	$(CC) $(CFLAGS) -c $< -o $@

$(HEADER_DEP): $(BUILDDIR)/$K/%.d : $K/%.c
	@mkdir -p $(@D)
	@set -e; rm -f $@; $(CC) -MM $< $(INCLUDEFLAGS) > $@.$$$$; \
        sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
        rm -f $@.$$$$

build: build/kernel

build/kernel: $(OBJS)
	@mkdir -p build/iso
	mkdir -p iso/boot/grub
	$(LD) $(LDFLAGS) -T $K/arch/$(ARCH)/kernel.ld -o $(BUILDDIR)/kernel $(OBJS)
	$(OBJDUMP) -S $(BUILDDIR)/kernel > $(BUILDDIR)/kernel.asm
	$(OBJDUMP) -t $(BUILDDIR)/kernel | sed '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(BUILDDIR)/kernel.sym
	cp build/kernel iso/boot/kernel
	cp grub.cfg iso/boot/grub/grub.cfg
	grub-mkrescue -o build/iso/os.iso iso/
	rm -rf iso
	@echo 'Build kernel done'


clean:
	rm -rf $(BUILDDIR)

run: build/kernel
	$(QEMU) $(QEMUOPTS)

# QEMU's gdb stub command line changed in 0.11
QEMUGDB = $(shell if $(QEMU) -help | grep -q '^-gdb'; \
	then echo "-gdb tcp::15234"; \
	else echo "-s -p 15234"; fi)
GDBTARGET1 = target remote :15234 
GDBTARGET2 = symbol-file build/kernel

debug: build/kernel .gdbinit
	$(QEMU) $(QEMUOPTS) -S $(QEMUGDB) &
	sleep 1
	$(GDB) -ex "$(GDBTARGET1)" -ex "$(GDBTARGET2)" -ex "add-symbol-file ../user_app/bin/user_app.sym $(APP_BASE)"
	
