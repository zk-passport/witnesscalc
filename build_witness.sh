#!/usr/bin/env bash

if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "Usage: $0 <absolute path to the cpp folder without the trailing \`/\`> <circuit name> <path to witnesscalc repo>"
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
witness_calc="$3"

last_value="${path##*/}"
circuit="${last_value%_*}"
source_cpp_file="$path/${circuit}.cpp"
source_dat_file="$path/${circuit}.dat"

patch_cpp=$witness_calc/patch_cpp.sh

mkdir "${witness_calc}/build_witnesscalc_${baseName}"

cd "${witness_calc}/build_witnesscalc_${baseName}" && cmake .. -DTARGET_PLATFORM=x86_host -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../package

make ${baseName}

cp $source_dat_file "${witness_calc}/build_witnesscalc_${baseName}/src/${baseName}.dat"