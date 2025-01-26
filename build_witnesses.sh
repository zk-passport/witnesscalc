#!/usr/bin/env bash

# run from root

snake_to_camel() {
    local input="$1"
    local result

    result=$(echo "$input" | awk -F_ '{printf "%s", tolower(substr($1,1,1)) substr($1,2)}')
    result+=$(echo "$input" | awk -F_ '{for (i=2; i<=NF; i++) printf "%s", toupper(substr($i,1,1)) substr($i,2)}')

    echo "$result"
}

circuits=( ["0"]="register_sha1_sha256_sha256_rsa_65537_4096")

for circuit in "${circuits[@]}"; do
    type=${circuit%%_*}
    circuit_name=$(snake_to_camel "$circuit")
    cpp_folder_path="circuits/$type/$circuit/${circuit}_cpp"

    absolute_cpp_folder_path=$PWD/$cpp_folder_path

    ./build_witness.sh $absolute_cpp_folder_path $circuit_name
done 