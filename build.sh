#!/usr/bin/bash

printf "Start building project %s\n" $PROJECT_NAME

source settings.sh
printf "Settings sourced\n"

echo ${GCC_FLAGS[@]}
echo "-----------------"
echo ${LD_FLAGS[@]}

MODULES=$(realpath $(find modules/ -name Makefile))
for MODULE in $MODULES; do
    cd $(dirname $MODULE)
    make -j$(nproc)
done

