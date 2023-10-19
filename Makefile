CC = arm-none-eabi-gcc
LD = arm-none-eabi-ld

MAKEFLAGS += --jobs=$(shell nproc)                          # allow multiple thread to be run when compiling
MAKEFLAGS += --output-sync=target                           # buffer commands outputs

INCLUDE_DIRS += $(wildcard modules/*/inc)                   # standard module includes
INCLUDE_DIRS += FreeRTOS/Source/include                     # freertos includes
INCLUDE_ARGS = $(addprefix -I, $(INCLUDE_DIRS))             # add include prefixes for gcc

SOURCES += $(wildcard modules/*/src)                        # standard module sources
SOURCES += FreeRTOS/Source                                  # freertos sources
# SOURCES += FreeRTOS/Source/portable/MemMang/heap_1.c        # freertor heap manager
# SOURCES += FreeRTOS/Source/portable/GCC/port.c              # freeRTOS port for ARM CM4F

LINKERSCRIPT = modules/mcu/<linkerscript>.ld                # linkerscript (with path)

DEVICE = -D<DEVICE>                                         # device define for cmsis header
MEMORY_START_ADDR = 0x8000000                               # memory base address

# # compiler flags:
# GCC_FLAGS += $(DEVICE) # specify target MCU
# GCC_FLAGS += -I$(INCLUDE_ARGS) # specify include directory
# GCC_FLAGS += -Wall # enable all warnings
# GCC_FLAGS += -ggdb # use maximum amount of info for gdb debugger
# GCC_FLAGS += -mcpu=cortex-m4 # specify CPU core
# GCC_FLAGS += --specs=nano.specs # better newlib implementation (whatever that means?) (not nosys.specs)
# GCC_FLAGS += -mthumb # use thumb instructions

# FPU flags:
# FPU_FLAGS += -mfloat-abi=soft # application binary interface with floating points. hard -> compiler using fp instructions, softfp -> allows fp instructions but maintains compatibility;
# FPU_FLAGS += -mfpu=fpv4-sp-d16 # specify fpu for hard fp abi

# # linker options: (-Wl passes options to linker)
# # LD_FLAGS = $(FPU_FLAGS)
# LD_FLAGS = -T"$(LINKERSCRIPT)" # specify linker script
# LD_FLAGS += -Wl,-Map=$(OUTPUT_DIR)/"program.map" #specify .map file
# LD_FLAGS += -Wl,--gc-sections # linker doesnt link dead code
# LD_FLAGS += -Wl,--start-group -lc -lm -Wl,--end-group # add -l switches and archive files (source: GNU ld manual)
# LD_FLAGS += -static # static linking?

# all: bin
# bin: $(OUTPUT_DIR)/program.elf
# 	arm-none-eabi-objcopy -O binary output/program.elf output/program.bin
# flash: 
# 	st-flash write output/program.bin $(MEMORY_START_ADDR)


command:
	@echo $(SOURCES)

all:

build/objects/%.o: $(SOURCES)/%.c

# term:
# 	@screen /dev/ttyUSB0 115200
# bear:
# 	@bear -- $(MAKE) all


