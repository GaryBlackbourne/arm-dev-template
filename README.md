# ARM CMSIS project template

This project template is an example, created to ease bootstrapping a project. 
The architecture is flexible, and allows bare metal programming on register levels, but 
makes it easy to integrate any library or abstraction layer.

## Architecture

This project template has a modular architecture. You may add modules at your own liking,
separating source files into modules based on functionality. This behavior is achieved
by using a main shell script (`build.sh`) which invokes every modules own script 
(`module.sh`). All module scripts are responsible for their modules build. 
Most may only call make, and then copies output, but complex modules may call 
submodule scripts and so on.

To start a simple build, you only need to execute the `build.sh` file in the project
root directory.

## Project setup

### dependencies

#### Toolchain

This project requires you to have a toolchain installed, and added to your PATH variable.
This can be achieved by using your package manager (apt, pacman, ...), or 
alternatively you can compile the toolchain from source. 
To use gcc, install `arm-none-eabi-gcc` package.

``` shell
sudo pacman -S arm-none-eabi-gcc
# OR
sudo apt install gcc-arm-none-eabi
```

This package contains a compiler and a linker as well. 
Both sould be set, in the `settings.sh` file. (CC -> Compiler, LD -> linker)

*Note: For gcc it is recommended to invoke gcc as linker, and pass linker arguments as -Wl,\<arg\> *

#### Shell 

The scripts are written in `bash`, so this or any compatible shell is needed. 

#### GNU Make

Also `make` is essential tool since this project is using Makefiles to invoke 
the compiler.

``` shell
sudo pacman -S make
# OR
sudo apt install make
```

#### Serial terminal

For latter use, it is recommended to have a terminal which can connect to serial communicators, or debuggers like `screen`, `putty`, or `minicom`.

#### Debugger

For debugging, one might need `openOCD` and `arm-none-eabi-gdb`.

``` Shell
sudo pacman -S openocd arm-none-eabi-gdb
# OR
sudo apt install openocd arm-none-eabi-gdb
```

### Bootstrap project

#### Clone the repo

Clone this repostitory into your project directory:

```
git clone <project_dir> git@github.com:GaryBlackbourne/arm-dev-template.git
```

#### Get the hardware specific sources

After you cloned the repo, you have to obtain the necessary files from the manufacturer. 
For `STM32` target I recommend CubeMX to download paackages or straight up projects, and copy the necessary files.
It tend to have all necessary files but all manufacturer has to have a mirror, where these files could be
downloaded from.


ARM forces all manufacturers to have some sort of implementation of these files for their hardware, as it is part of the 
CMSIS (Cortex Microcontroller Software Interface Standard).


The files you need are:
- includes 
  - \<device\>.h - (note: this might not only be one file, for example for an stm32f303re you have to have stm23f303xe.h AND stm32f3xx.h)
  - system_\<device\>.h 
  - core_\<cpu\>.h
  - cmsis_compiler.h - (note: this might need a compiler specific header like cmsis_gcc.h)
  - cmsis_version.h 
  - mpu-armv7.h - if you have an MPU in your controller, then this file is also needed
- sources - put them in the `src` directory
  - main.c (this is self explanatory)
  - system_\<device\>.c 
  - startup_\<device\>.s
- Linkerscript
  - \<device\>\_FLASH.ld

![](https://www.keil.com/pack/doc/cmsis/Core/html/CMSIS_CORE_Files.png)

You can learn more about these files at [this site](https://arm-software.github.io/CMSIS_5/Core/html/using_pg.html) and [this site](https://www.keil.com/pack/doc/cmsis/Core/html/templates_pg.html).

#### Add the sources to the mcu module

The project has a module already defined for the CMSIS files; this module is called `mcu` module. 
Inside `modules/mcu` you find a readme which tells you exactly what sort of files go where. Basically
you only have to copy all sources to `modules/mcu/src` and all headers to `modules/mcu/inc`. The linkerscript 
should be placed in the module root (modules/mcu).

#### Use the core module

The main functionality is implemented in a specific module called `core`. This module already has a `main.c` file in the `src` directory.
The programs entry is the main function which you may write in this module. 

#### Edit the settings.sh script

##### DEVICE

First, find the `DEVICE` variable and replace the template with your 
microcontrollers type. Some microcontrollers have to have a define in the code 
which specifies the device being used. This essentially does the same, only it is 
not in the code, but in the compilers arguments list. For an STM32 based project, this 
can be obtained from the device header file, which has a commented segment with all 
the possible define values. For my F303RE this would look like this:

``` shell
DEVICE="STM32F303xE"
```

##### LINKERSCRIPT
Then edit the LINKERSCRIPT variable the same way, add your linker script. 
In my case for example:

``` shell
LINKERSCRIPT=modules/mcu/STM32F303xE_FLASH.ld
```

##### MEMORY_START_ADDR

Edit the `MEMORY_START_ADDR` variable according to your linkerscript, 
and MCU specifications. This value is the beginning of your program so 
it should be, where the FLASH segment starts in your controllers memory map.

This variable is only used during flashing.

#### CPU
You have to set for which CPU are you compiling with the `-mcpu` flag 
which is in my example is equal to cortex-m4. This value tells 
the compiler, which CPU core is in use.

#### FPU

Some controllers, have an FPU embedded, int that case, you have to specify the 
type for the compiler. There is an `FPU flags` in the settings, where 
you can set the appropriate options.

If you have no FPU in your device, then set `-mfloat-abi=soft`and comment 
out the `-mfpu=...` flag. This makes the compiler to generate emulated floating 
point operations, which are much slower, but still works. If you have an FPU, 
then you can specify how the floating point operations should work, using 
the flags mentioned above. More on this topic, and about values can be found here: 
[FPU-know-how](https://embeddedartistry.com/blog/2017/10/11/demystifying-arm-floating-point-compiler-options/)

This compiler flag does not have its own variable, feel free to edit the `COMPILER_FLAGS`
variable.

### Create `compile_commands.json`

If you are using a language server which requres a compile commands JSON file (clangd), 
you can generate it whith the following command, if you have `bear` installed:

```
bear -- build.sh
```

It is recommended to generate this when you add another module.

### Debugging

If you wish to debug your application, then you will need a tool called `openOCD`. 
This awesome project can be downloaded the same way as other dependencies. Debugging
an embedded application requires an openOCD to run a GDB server and connect to the 
target MCU via the debugger hardver like ST-Link. For this very reason, this project
has a shell script named `openocd-start`, which simply starts an openOCD as a background
process, and starts a GDB server which you can connect to from your favourite GDB
frontend, or even GDB commandline as well.

### Integrate FreeRTOS

The project contains a FreeRTOS module into which you can place the code 
downloaded from [official source](https://www.freertos.org/). 
The FreeRTOS project architecture requires the following files:

```
FreeRTOS
└── Source
    ├── croutine.c
    ├── event_groups.c
    ├── include
    │   ├── atomic.h
    │   ├── croutine.h
    │   ├── deprecated_definitions.h
    │   ├── event_groups.h
    │   ├── FreeRTOS.h
    │   ├── list.h
    │   ├── message_buffer.h
    │   ├── mpu_prototypes.h
    │   ├── mpu_wrappers.h
    │   ├── portable.h
    │   ├── projdefs.h
    │   ├── queue.h
    │   ├── semphr.h
    │   ├── stack_macros.h
    │   ├── StackMacros.h
    │   ├── stdint.readme
    │   ├── stream_buffer.h
    │   ├── task.h
    │   └── timers.h
    ├── list.c
    ├── portable
    │   ├── GCC
    │   │   └── \<YOUR_PORT\>
    │   │       ├── port.c
    │   │       └── portmacro.h
    │   └── MemMang
    │       ├── heap_1.c
    │       ├── heap_2.c
    │       ├── heap_3.c
    │       ├── heap_4.c
    │       ├── heap_5.c
    │       └── ReadMe.url
    ├── queue.c
    ├── stream_buffer.c
    ├── tasks.c
    └── timers.c
```

These files can be easily downloaded from the official website in a zip archive.
The .zip contains tons of other files, like demos, examples, ports for various 
controllers, etc. You only need the `Source` directory, and the appropriate port from 
the `portabe` directory, and memory management files. Since this project is 
based on the GCC compiler, we search for our ports there.

Other than that, you only need a `FreeRTOSConfig.h` which can be created based 
on templates you already downloaded in the FreeRTOS zip file, or you can write your own 
based on the [documentation](https://www.freertos.org/a00110.html).

