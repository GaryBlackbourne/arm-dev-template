#!/usr/bin/bash

# create directory
mdkir -p obj/

# Compile module
make -j"$(nproc)"

# copy output to global output
cp obj/* "$OBJECT_DIR/"

