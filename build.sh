#!/usr/bin/env sh

exec=`realpath $0`
root=`dirname $exec`

set -e

if [ -z "$CMAKE_BUILD_TYPE" ]; then
    export CMAKE_BUILD_TYPE=Debug
fi

if [ -z "$BUILD_SHARED_LIBS" ]; then
    export BUILD_SHARED_LIBS=1
fi

cmake -H$root -B$root/_build -DCMAKE_INSTALL_PREFIX=$root/_install -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DBUILD_SHARED_LIBS=${BUILD_SHARED_LIBS} -Wno-dev
env VERBOSE=1 cmake --build $root/_build --target tests
env VERBOSE=1 cmake --build $root/_build --target install
