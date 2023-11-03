#!/usr/bin/bash

if [ "$0" = "$BASH_SOURCE" ]; then
    echo "Error: Script must be sourced"
    exit 1
fi

printf "Source settings ... "

export PROJECT_NAME="<PROJECT_NAME>"
export CC="/usr/bin/arm-none-eabi-gcc"
export LD="/usr/bin/arm-none-eabi-gcc"
# export LD="/usr/bin/arm-none-eabi-ld"

DEVICE="<DEVICE>"
CPU="<your_cpu_type>"
MAPFILE="build/program.map"
LINKERSCRIPT="modules/mcu/<LINKERSCRIPT>"
MEMORY_START_ADDR="<your_memory_start_address>"

# general compiler options
COMPILER_FLAGS=(
    "-D$DEVICE"            # specify target MCU
    "-Wall"                # enable all warnings
    "-ggdb"                # use maximum amount of info for gdb debugger
    "-mcpu=$CPU"           # specify CPU core
    "--specs=nano.specs"   # better newlib implementation (not nosys.specs)
    "-mthumb"              # use thumb instructions
    "-mfloat-abi=soft"     # application binary interface with floating points. 
                           # hard -> compiler using fp instructions,
                           # softfp -> allows fp instructions but maintains compatibility;
    # "-mfpu=fpv4-sp-d16"    # specify fpu for hard fp abi
    "-O0"
)

# general linker options: 
LINKER_FLAGS=(
    "-Wl,-T\"$LINKERSCRIPT\""  # specify linker script
    "-Wl,-Map=$MAPFILE"    # specify .map file
    "-Wl,--gc-sections"    # linker doesnt link dead code
    "-Wl,-lc"
    "-Wl,-lm" # add -l switches and
    "-Wl,-static"              # static linking?
)

export GCC_FLAGS=$(echo "${COMPILER_FLAGS[@]}")
export LD_FLAGS=$(echo "${LINKER_FLAGS[@]}")
export OBJECT_DIR=$(realpath build/obj)

printf "DONE!\n"

