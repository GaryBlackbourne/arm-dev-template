# ARM CMSIS project template

This is an example project to get started with bare metal programming on register level, with ARM Cortex microcontrollers. The project includes a FreeRTOS template as well, but source files have to be downloaded separately.

## Project setup

### dependencies

This project requires you to have an arm toolchain installed, and added to your PATH variable. This can be achieved by using your package manager (apt, pacman, ...) and install `arm-none-eabi-gcc` package. This might or might not include arm-none-eabi-gdb, which is the ARM debugger, and recommended to have.

``` shell
sudo pacman -S arm-none-eabi-gcc
```
or

``` shell
sudo apt install arm-none-eabi-gcc
```

Also `make` is essential tool since this project is using Makefile to compile code.

``` shell
sudo pacman -S make
```
or

``` shell
sudo apt install make
```

For latter use, it is recommended to have a terminal which can connect to serial communicators, or debuggers like `screen`, `putty`, or `minicom`.


### Clone repository

Clone this repostitory the way you wish, I presume you are using a linux system.

```
git clone git@github.com:GaryBlackbourne/arm-dev-template.git
```

### Download files for your microcontroller

After you cloned the repo, you have to obtain the necessary files from the manufacturer. I used this project with `STM32` and CubeMX generated projects tend to have all necessary files.

The files you need are:
- main.c : your main function, self explanatory. In this file you must include your `<device>.h` header file
- \<device\>.h : For example stm32f303xe.h if you are using an stm32f303 microcontroller. This file is your main source of defines, calls etc. which CMSIS provides.
- system_\<device\>.c :  
- startup_\<device\>.s : This file may be a `.c` file, depends on the project, and the microcontroller.
- \<device\>_ FLASH.ld : This file is called the linker script, and it defines your microcontrollers memory map. 

You can learn about these files at [this site](https://arm-software.github.io/CMSIS_5/Core/html/using_pg.html).

### insert the files into specific directories

### Edit the Makefile

The projects heart is a single Makefile which gives you total control over the project. After you placed the necessary files 
into their places (headers to `inc`, and sources to `src`) you have to edit the Makefile to match your projects architecture.

#### Initial moves

##### DEVICE
First, find the `DEVICE` variable and replace the template with your microcontrollers type. For an STM32F303RE based project, this would be:

``` Makefile
DEVICE = -DSTM32F303xE
```

##### LINKERSCRIPT
Then edit the linker script the same way, add your linker script.

``` Makefile
LINKERSCRIPT = STM32F303xE_FLASH.ld
```

#### code memory start address
Edit the `MEMORY_START_ADDR` variable according to your linkerscript, and MCU specifications.

##### CMSIS FILES
Then replace the startup and system templates in the Makefiles `MCU files` segment, and add your hardware specific source files to the project.


#### Add sources to your projec
If you wish to add a new source file to the project, then create the file in the `src` directory and append the `SOURCES` variable in the Makefile. 

``` Makefile
SOURCES += src/my_shiny_new_source.c
```

Header files does not require any work as long as they are put into the `inc` directory.

### Create `compile_commands.json`

If you are using a language server which requres a compile commands JSON file, you can generate it whith the following command:

```
bear -- make all
```

