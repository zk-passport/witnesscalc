#!/bin/bash

# In /CMkaeLists.txt move the new circuits above the "fr" line

if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <circuit name> <header name>"
    exit 1
fi

circuit="$1"
header="$2"

cmake_file="CMakeLists.txt"
content=$(<"$cmake_file")

install_targets_start=$(echo "$content" | grep -n "install(TARGETS" | cut -d: -f1)
install_targets_end=$(echo "$content" | sed -n "$install_targets_start,\$p" | grep -n ")" | head -n 1 | cut -d: -f1)
install_targets_end=$((install_targets_start + install_targets_end - 1))

install_files_start_3=$(echo "$content" | grep -n "install(FILES" | sed -n '2p' | cut -d: -f1)
install_files_end_3=$(echo "$content" | sed -n "$install_files_start_3,\$p" | grep -n ")" | head -n 1 | cut -d: -f1)
install_files_end_3=$((install_files_start_3 + install_files_end_3 - 1))

install_files_start_last=$(echo "$content" | grep -n "install(FILES" | tail -n 1 | cut -d: -f1)
install_files_end_last=$(echo "$content" | sed -n "$install_files_start_last,\$p" | grep -n ")" | head -n 1 | cut -d: -f1)
install_files_end_last=$((install_files_start_last + install_files_end_last - 1))

target_lines="    ${circuit}\n"
target_lines+="    witnesscalc_${circuit}\n"
target_lines+="    witnesscalc_${circuit}Static"

data_files=""
data_files+="    src/${circuit}.dat"

header_files=""
header_files+="    src/witnesscalc_${circuit}.h"

content_modified=$(echo "$content" | sed "${install_targets_end}i\\$target_lines")
content_modified=$(echo "$content_modified" | sed "${install_files_end_3}i\\$data_files")
content_modified=$(echo "$content_modified" | sed "${install_files_end_last}i\\$header_files")

echo "$content_modified" > "$cmake_file"

cp ./src/witnesscalc_linkedMultiQuery10.h ./src/witnesscalc_${circuit}.h
cp ./src/witnesscalc_linkedMultiQuery10.cpp ./src/witnesscalc_${circuit}.cpp 

sed -i "s/WITNESSCALC_LINKEDMULTIQUERY10_H/WITNESSCALC_${header^^}_H/g" ./src/witnesscalc_${circuit}.h
sed -i "s/witnesscalc_linkedMultiQuery10/witnesscalc_${circuit}/g" ./src/witnesscalc_${circuit}.h

sed -i "s/witnesscalc_linkedMultiQuery10/witnesscalc_${circuit}/g" ./src/witnesscalc_${circuit}.cpp

file="src/CMakeLists.txt"  # Replace this with the actual file name

# Define the string to be appended with circuit and HEADER variables
cmake_string=$(cat <<EOF

# ${circuit}
set(${header}_SOURCES \${LIB_SOURCES}
    ${circuit}.cpp
    witnesscalc_${circuit}.h
    witnesscalc_${circuit}.cpp
)

add_library(witnesscalc_${circuit} SHARED \${${header}_SOURCES})
add_library(witnesscalc_${circuit}Static STATIC \${${header}_SOURCES})
set_target_properties(witnesscalc_${circuit}Static PROPERTIES OUTPUT_NAME witnesscalc_${circuit})

add_executable(${circuit} main.cpp)
target_link_libraries(${circuit} witnesscalc_${circuit})

target_compile_definitions(witnesscalc_${circuit} PUBLIC CIRCUIT_NAME=${circuit})
target_compile_definitions(witnesscalc_${circuit}Static PUBLIC CIRCUIT_NAME=${circuit})
target_compile_definitions(${circuit} PUBLIC CIRCUIT_NAME=${circuit})
EOF
)

echo "$cmake_string" >> "$file"
