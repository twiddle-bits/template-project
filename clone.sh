#!/usr/bin/env sh

if [ "$#" -ne 1 ]; then
    printf "Usage:\n\t$0 <dir>\n"
    exit 1;
fi

set -e

srcDir=`dirname $0`

cd $srcDir
srcDir=`pwd`
cd -

mkdir -p $1
cd $1
projDir=`pwd`
cd -

projName=`basename $projDir`
projNameUpper=`echo $projName | tr [a-z] [A-Z]`

# handle CMakeLists.txt
cat $srcDir/CMakeLists.txt | sed "s/<PKG>/$projName/g" | sed "s/<PKGUPPER>/$projNameUpper/g" > $projDir/CMakeLists.txt

# handle export header
mkdir -p $projDir/export/$projName
mkdir -p $projDir/include/$projName
cat $srcDir/export/proj/exports.h | sed "s/<PKG>/$projNameUpper/g" > $projDir/export/$projName/exports.h

# handle cmake/projConfig.cmake.in
mkdir -p $projDir/cmake
cmakeConfig="$projDir/cmake/$projName"Config.cmake.in
cat $srcDir/cmake/projConfig.cmake.in | sed "s/<PKG>/$projName/g" | sed "s/<PKGUPPER>/$projNameUpper/g" > $cmakeConfig

# handle build.sh, clean.sh, tests-install.sh
cp $srcDir/build.sh $srcDir/clean.sh $srcDir/tests-install.sh $projDir

# copy empty.c
mkdir -p $projDir/src/$projName
cat $srcDir/src/proj/empty.c | sed "s/proj/$projName/g" | sed "s/PROJ/$projNameUpper/g" > $projDir/src/$projName/empty.c

# copy tests
mkdir -p $projDir/tests/install
cp -rf $srcDir/tests $projDir/
cat $srcDir/tests/exports.c | sed "s/<PKG>/$projName/g" | sed "s/<PKGUPPER>/$projNameUpper/g" > $projDir/tests/exports.c

# handle tests.cmake and install/CMakeLists.txt
cat $srcDir/tests.cmake | sed "s/<PKG>/$projName/g" > $projDir/tests.cmake
cat $srcDir/tests/install/CMakeLists.txt | sed "s/<PKG>/$projName/g" > $projDir/tests/install/CMakeLists.txt

# copy LICENSE
cat $srcDir/LICENSE | sed "s/<YEAR>/`date +%Y`/g" > $projDir/LICENSE

# copy 3rdparty.cmake
cp $srcDir/3rdparty.cmake $projDir/

# copy CI files
cat $srcDir/.travis.yml | grep -v 'foo' > $projDir/.travis.yml
cat $srcDir/appveyor.yml | grep -v 'foo' > $projDir/appveyor.yml
