#!/usr/bin/bash

printf "Start building project %s\n" $PROJECT_NAME

PROJECT_ROOT=$(pwd)

source settings.sh
printf "Settings sourced\n"

printf "Compiling modules...\n"
# compile each module
MODULES=$(realpath $(find modules/ -name "module.sh"))
for MODULE in $MODULES; do
    cd "$(dirname "$MODULE")" || exit 1
    bash module.sh
    # make -j"$(nproc)"
done
printf "Compilation finished...\n"

# link all module objects
cd "$PROJECT_ROOT" || exit 1
printf "Linking object files...\n"
make

printf "Build completed!\n"
