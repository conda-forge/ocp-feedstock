#!/bin/sh
set -euo pipefail

cp ${RECIPE_DIR}/CMakeLists.txt ${SRC_DIR}/src/CMakeLists.txt

cmake -B build -S "${SRC_DIR}/src" \
	-G Ninja \
	-DPython3_ROOT_DIR=${PREFIX} \
	-DCMAKE_BUILD_TYPE=Release

cmake --build build -j ${CPU_COUNT}
cmake --install build --prefix "${STDLIB_DIR}"
