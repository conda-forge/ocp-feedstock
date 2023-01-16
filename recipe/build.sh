#!/bin/sh
set -euo pipefail

# get vtk library for osx-arm64
VTK_DIR=${PREFIX}
if [[ "$OSTYPE" == "darwin"* && $OSX_ARCH == "arm64" ]]; then
    VTK_DIR=/tmp/vtk
    conda list -p ${BUILD_PREFIX} > packages.txt
    cat packages.txt
    VTK_PACKAGE_VERSION=`grep vtk packages.txt | awk -F ' ' '{print $2}'`
    export CONDA_SUBDIR=osx-arm64
		conda create -y -p ${VTK_DIR} --no-deps vtk=${VTK_PACKAGE_VERSION} python=${PY_VER}

		# copy back to ${PREFIX}/lib/python${PY_VER}/site-packages to satisfy
		# cmake
		# mkdir -p ${PREFIX}/lib/python${PY_VER}/site-packages
		# cp -a ${VTK_DIR}/lib/python${PY_VER}/site-packages/vtk* ${PREFIX}/lib/python${PY_VER}/site-packages
fi

# FindOpenCascade.cmake bundled with OCP references the env var `CONDA_PREFIX`.
# That is the right prefix when manually running CMake inside a conda env, but
# the wrong one when using conda-build. Substitute the right prefix inline.
CONDA_PREFIX="${PREFIX}" cmake ${CMAKE_ARGS} -B build -S "${SRC_DIR}/src" \
	-G Ninja \
	-DVTK_PREFIX_PATH=${VTK_DIR}

cmake --build build -j ${CPU_COUNT}
cmake --install build --prefix "${STDLIB_DIR}"
