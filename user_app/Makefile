TARGET      := user_app
ARCH        ?= x86

OBJ_DIR     := build
BIN_DIR     := bin

ifeq ($(ARCH),riscv)
CC          := riscv64-unknown-elf-gcc
CFLAGS      := -Wall -g -O2 -ffreestanding -nostdlib -nostartfiles \
		   -march=rv64gc -mabi=lp64 \
		   -Iinclude -Ilib -Ilib/arch/riscv
CFLAGS		+= -mcmodel=medany
LDSCRIPT    := ./lib/arch/riscv/user.ld
else ifeq ($(ARCH),x86)
CC          := i386-elf-gcc
CFLAGS      := -Wall -g -O2 -ffreestanding -nostdlib -nostartfiles \
		   -m32 -Iinclude -Ilib -Ilib/arch/x86
LDSCRIPT    := ./lib/arch/x86/user.ld
else
$(error Unsupported ARCH=$(ARCH))
endif

ifeq ($(ARCH),riscv)
OBJDUMP := riscv64-unknown-elf-objdump
OBJCOPY := riscv64-unknown-elf-objcopy
else ifeq ($(ARCH),x86)
OBJDUMP := i386-elf-objdump
OBJCOPY := i386-elf-objcopy
endif

LDFLAGS     := -nostdlib -nostartfiles
ifeq ($(ARCH),x86)
LDFLAGS     += -lgcc
endif

LIB_C_SRCS  := $(wildcard lib/*.c)
APP_C_SRCS  := $(wildcard src/*.c)
S_SRCS      := lib/arch/$(ARCH)/crt.S

OBJS        := $(LIB_C_SRCS:%.c=$(OBJ_DIR)/%.o) \
			   $(APP_C_SRCS:%.c=$(OBJ_DIR)/%.o) \
			   $(S_SRCS:%.S=$(OBJ_DIR)/%.o)

.PHONY: all clean

all: $(BIN_DIR)/$(TARGET).elf $(BIN_DIR)/$(TARGET).bin $(BIN_DIR)/$(TARGET).sym
	$(OBJDUMP) -S $(BIN_DIR)/$(TARGET).elf > $(BIN_DIR)/$(TARGET).asm

$(BIN_DIR)/$(TARGET).elf: $(OBJS)
	@mkdir -p $(BIN_DIR)
	$(CC) $(CFLAGS) -T $(LDSCRIPT) -o $@ $(OBJS) $(LDFLAGS)

$(BIN_DIR)/$(TARGET).bin: $(BIN_DIR)/$(TARGET).elf
	$(OBJCOPY) -O binary $< $@

$(BIN_DIR)/$(TARGET).sym: $(BIN_DIR)/$(TARGET).elf
	$(OBJCOPY) --only-keep-debug $< $@

$(OBJ_DIR)/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR)/%.o: %.S
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

