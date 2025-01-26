#!/usr/bin/env bash

# take path to open passport as input
if [ -z "$1" ]; then
    echo "Usage: $0 <path to open passport monorepo>"
    exit 1
fi

# throw an error if the path is not an absolute path
if [[ "$1" != /* && "$1" != ~* ]]; then
    echo "Error: The provided path must be an absolute path."
    exit 1
fi

# it should not end with a /
if [[ "$1" == */ ]]; then
    echo "Error: The provided path must not end with a '/'."
    exit 1
fi

snake_to_camel() {
    local input="$1"
    local result

    # Convert first segment to lowercase
    result=$(echo "$input" | awk -F_ '{printf "%s", tolower(substr($1,1,1)) substr($1,2)}')
    # Convert subsequent segments, capitalizing their first letters
    result+=$(echo "$input" | awk -F_ '{for (i=2; i<=NF; i++) printf "%s", toupper(substr($i,1,1)) substr($i,2)}')

    echo "$result"
}

path="$1"
cd "$path/circuits" && yarn && cd "../../"

# circuits=( ["0"]="register_sha256_sha256_sha256_ecdsa_brainpoolP256r1" ["1"]="register_sha1_sha1_sha1_rsa_65537_4096" )
circuits=( ["0"]="register_sha1_sha256_sha256_rsa_65537_4096")

for circuit in "${circuits[@]}"; do
    circuit_name=$(snake_to_camel "$circuit")
    circuit_name_in_caps=$(echo "$circuit_name" | tr '[:lower:]' '[:upper:]')
    type=${circuit%%_*}

    # echo "$path/circuits/circuits/$type/instances/$circuit.circom"

    path_to_circuit="$path/circuits/circuits/$type/instances/$circuit.circom"

    output="./circuits/$type/$circuit/"

    mkdir -p $output

    circom $path_to_circuit -l "$path/circuits/node_modules" -l "$path/circuits/node_modules/@zk-kit/binary-merkle-root.circom/src" -l "$path/circuits/node_modules/circomlib/circuits" --O1 -c --output $output

    cpp_folder_path="circuits/$type/$circuit/${circuit}_cpp"

    cp "$cpp_folder_path/${circuit}.cpp" "src/${circuit_name}.cpp" 
    cp "$cpp_folder_path/${circuit}.dat" "src/${circuit_name}.dat" 

    ./add_circuit.sh $circuit_name $circuit_name_in_caps
done