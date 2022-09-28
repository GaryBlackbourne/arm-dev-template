# ARM CMSIS project template

This is an example project to get started with bare metal programming on register level, with ARM Cortex microcontrollers. The project includes a FreeRTOS template as well, but source files have to be downloaded separately.

## Project setup

### dependencies

This project requires you to have an arm toolchain installed, and added to your PATH variable. This can be achieved by using your package manager (apt, pacman, ...) and install `arm-none-eabi-gcc` package.

``` shell
sudo pacman -S arm-none-eabi-gcc
# OR
sudo apt install arm-none-eabi-gcc
```

Also `make` is essential tool since this project is using Makefile to compile code.

``` shell
sudo pacman -S make
# OR
sudo apt install make
```

For latter use, it is recommended to have a terminal which can connect to serial communicators, or debuggers like `screen`, `putty`, or `minicom`.

For debugging, one might need `openOCD` and `arm-none-eabi-gdb`.

``` Shell
sudo pacman -S openocd arm-none-eabi-gdb
# OR
sudo apt install openocd arm-none-eabi-gdb
```

### Clone repository

Clone this repostitory the way you wish, I presume you are using a linux system.

```
git clone git@github.com:GaryBlackbourne/arm-dev-template.git
```

### Download files for your microcontroller

After you cloned the repo, you have to obtain the necessary files from the manufacturer. I used this project with `STM32` and CubeMX generated projects tend to have all necessary files but all manufacturer has to have a mirror, where these files could be downloaded from.

The files you need are:
- includes - put them in the `inc` directory
  - \<device\>.h - (note: this might not be in one file, i.e. stm23f303xe.h AND stm32f3xx.h, with stm32f303re)
  - system_\<device\>.h 
  - core_\<cpu\>.h
  - cmsis_compiler.h - (note: this might need a compiler specific header like cmsis_gcc.h)
  - cmsis_version.h 
  - mpu-armv7.h - if you have an MPU in your controller, then this file is also needed
- sources - put them in the `src` directory
  - main.c (this is self explanatory)
  - system_\<device\>.c 
  - startup_\<device\>.s
- other - put it in the project root, next to the Makefile
  - \<device\>\_FLASH.ld

![](https://www.keil.com/pack/doc/cmsis/Core/html/CMSIS_CORE_Files.png)

You can learn more about these files at [this site](https://arm-software.github.io/CMSIS_5/Core/html/using_pg.html) and [this site](https://www.keil.com/pack/doc/cmsis/Core/html/templates_pg.html).

### Edit the Makefile

The projects heart is a single Makefile which gives you total control over the project. After you placed the necessary files 
into their places (headers to `inc`, and sources to `src`) you have to edit the Makefile to match your projects architecture.

#### Initial moves

##### DEVICE
First, find the `DEVICE` variable and replace the template with your microcontrollers type. Some microcontrollers have to have a define in the code which specifies the device being used. This essentially does the same, only it does not in the code, but in the compilers arguments list. For an STM32 based project, this can be obtained from the device header file, which has a commented segment with all the possible define values. For my F303RE this would look like this:

``` Makefile
DEVICE = -DSTM32F303xE
```

##### LINKERSCRIPT
Then edit the linker script the same way, add your linker script. In my case for example:

``` Makefile
LINKERSCRIPT = STM32F303xE_FLASH.ld
```

#### MEMORY_START_ADDR
Edit the `MEMORY_START_ADDR` variable according to your linkerscript, and MCU specifications. This value is the beginning of your program so it should be, where the FLASH segment starts in your controllers memory map.

##### CMSIS FILES
Then replace the startup and system templates in the Makefiles `MCU files` segment, and add your hardware specific source files to the project.

#### CPU flag
You have to set for which CPU are you compiling with the `-mcpu` flag which is by default is equal to cortex-m4. You may find this flag in the Makefiles `compiler (and precompiler) flags`. This value obiviously tells the compiler, which CPU core is in use.

#### FPU flags
Some controllers, have an FPU embedded, int that case, you have to specify the type for the compiler. There is a segment called `FPU flags` in the Makefile, where you can set the appropriate options.

If you have no FPU in your device, then set `-mfloat-abi=soft`and comment out the `-mfpu=...` flag. This 
makes the compiler to generate emulated floating point operations, which are much slower, but still works. 
If you have an FPU, then you can specify how the floating point operations should work, using the flags mentioned above. 
More on this topic, and about values can be found here: [FPU-know-how](https://embeddedartistry.com/blog/2017/10/11/demystifying-arm-floating-point-compiler-options/)



### Create `compile_commands.json`

If you are using a language server which requres a compile commands JSON file, you can generate it whith the following command, if you have `bear` installed:

```
bear -- make all
```
### Debugging

If you wish to debug your application, then you will need a tool called `openOCD`. This awesome project can be downloaded the same way as other dependencies. Debugging an embedded application requires an openOCD to run a GDB server and connect to the target MCU via the debugger hardver like ST-Link. For this very reason, this project has a shell script named `openocd-start`, which simply starts an openOCD as a background process, and starts a GDB server which you can connect to from your favourite GDB frontend, or even GDB commandline as well.

### Integrate FreeRTOS

The project contains a FreeRTOS directory into which you can place the code downloaded from [official source](https://www.freertos.org/). 
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

These files can be easily downloaded from the official website in a zip format. The .zip contains tons of other files, like demos, examples, ports for various controllers, etc. You only need the `Source` directory, and the appropriate port from the `portabe` directory, and memory management files. Since this project is based on the GCC compiler, we search for our ports there.

Other than that, you only need a `FreeRTOSConfig.h` which can be created based on templates you already downloaded in the FreeRTOS zip file, or you can write your own based on the [documentation](https://www.freertos.org/a00110.html).

Now uncomment the sources int the sources in the Makefiles `FreeRTOS files` segment, and set the appropriate port, in the `FREERTOS_PORTABLE_DIR` variable.

## Manage the project during development

### Add sources to your projec
If you wish to add a new source file to the project, then create the file in the `src` directory and append the `SOURCES` variable in the Makefile. 

``` Makefile
SOURCES += src/my_shiny_new_source.c
```

Header files does not require any work as long as they are put into the `inc` directory.
