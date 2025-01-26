#!/usr/bin/env bash

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <absolute path to the cpp folder without the trailing \`/\`> <circuit name>"
    exit 1
fi

if [[ "$1" != /* && "$1" != ~* ]]; then
    echo "Error: The provided path must be an absolute path."
    exit 1
fi

if [[ "$1" == */ ]]; then
    echo "Error: The provided path must not end with a '/'."
    exit 1
fi

path="$1"
baseName="$2"

last_value="${path##*/}"
circuit="${last_value%_*}"
source_cpp_file="$path/${circuit}.cpp"
source_dat_file="$path/${circuit}.dat"

./patch_cpp.sh $source_cpp_file > ./src/${baseName}.cpp
mkdir "build_witnesscalc_${baseName}"

cd "build_witnesscalc_${baseName}" && cmake .. -DTARGET_PLATFORM=x86_host -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../package

cp $source_dat_file ./src/${baseName}.dat

make ${baseName}
