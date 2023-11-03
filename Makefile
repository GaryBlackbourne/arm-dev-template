all: build/out/program.elf
	arm-none-eabi-objcopy -O binary $^ build/out/program.bin

objects = $(wildcard build/obj/*.o)

build/out/program.elf: $(objects)
	$(LD) $^ -o $@ $(LD_FLAGS)

flash: out/program.bin
	st-flash write $^ $(MEMORY_START_ADDR)

command:
	@echo $(SOURCES)

term:
	@screen /dev/ttyUSB0 115200
bear:
	@bear -- $(MAKE) all


