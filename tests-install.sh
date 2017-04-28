#!/usr/bin/env sh

cd `dirname $0`
root=`pwd`
cd -

set -e

$root/build.sh
cd $root/tests/install
./test.sh
