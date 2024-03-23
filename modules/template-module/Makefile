# Template makefile

MODULE_DEPENDS = mcu core

# search for additional dependency includes
dep_include_dirs := $(foreach mod,$(MODULE_DEPENDS),../$(mod)/inc)

# add to gcc includes
gcc_include_dirs := $(foreach inc_dir,$(dep_include_dirs),-I$(inc_dir))
gcc_include_dirs += -Iinc
GCC_FLAGS += $(gcc_include_dirs)

#deps = $(wildcard inc/*.h)
deps := $(foreach inc_dir,$(dep_include_dirs),$(wildcard $(inc_dir)/*.h))
#deps := $(wildcard $(foreach d, $(dep_include_dirs), $(d))/*.h)

objects = $(foreach src, $(sources), obj/$(basename $(src)).o)

all: $(objects)

obj/%.o: src/%.c $(deps)
	$(CC) $(CFLAGS) -c $< -o $@

test:
	@echo $(MODULE_DEPENDS)
	@echo $(dep_include_dirs)
	@echo $(gcc_include_dirs)
	@echo $(deps)
.PHONY: test

clean:
	@rm obj/*
.PHONY: clean

