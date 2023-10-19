#!/usr/bin/bash

if [ "$0" = "$BASH_SOURCE" ]; then
    echo "Error: Script must be sourced"
    exit 1
fi

export PROJECT_NAME="RPIROBOT_FW"
export CC="/usr/bin/gcc"
export LD="/usr/bin/ld"

DEVICE="STM32F103CX"
MAPFILE="build/program.map"
LINKERSCRIPT="modules/mcu/*.ld"

export OBJECT_DIR=$(realpath build/obj)

# general compiler options
export GCC_FLAGS=(
    "$DEVICE"              # specify target MCU
    "-Wall"                # enable all warnings
    "-ggdb"                # use maximum amount of info for gdb debugger
    "-mcpu=cortex-m4"      # specify CPU core
    "--specs=nano.specs"   # better newlib implementation (not nosys.specs)
    "-mthumb"              # use thumb instructions
    "-mfloat-abi=soft"     # application binary interface with floating points. 
                           # hard -> compiler using fp instructions,
                           # softfp -> allows fp instructions but maintains compatibility;
    "-mfpu=fpv4-sp-d16"    # specify fpu for hard fp abi
)

# general linker options: 
export LD_FLAGS=(
    "-T\"$LINKERSCRIPT\""  # specify linker script
    "-Wl,-Map=$MAPFILE"    # specify .map file
    "-Wl,--gc-sections"    # linker doesnt link dead code
    "-Wl,--start-group -lc -lm -Wl,--end-group" # add -l switches and
                                                # archive files (source: GNU ld manual)
    "-static"              # static linking?
)

