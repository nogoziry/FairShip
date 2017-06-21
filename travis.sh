#!/bin/bash

set -e -x

echo ${TRAVIS_OS_NAME}
fairship=`pwd`

cd ..

# update and install packages
if [ "$TRAVIS_OS_NAME" = "osx" ]; then
   sw_vers
   osx_vers=`sw_vers -productVersion | cut -d . -f1 -f2`
   brew update >& /dev/null
   # oclint conflicts with gcc, gcc is needed for gfortran run-time
   brew cask uninstall oclint
   brew install gcc
   #brew install openssl
   export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig
   #brew cask install xquartz
   #brew install libtool
   export PYTHON=/usr/bin/python
   export FAIRSOFTTAR="https://cernbox.cern.ch/index.php/s/xEZLZgDknqACMwL/download"
   export FAIRROOTTAR="https://cernbox.cern.ch/index.php/s/qPmN8KuA83f8dFf/download"
   export FAIRSOFT_VERSION=osx12-Jun16
   export FAIRROOT_VERSION=osx12-Jun16
fi

if [ "$TRAVIS_OS_NAME" = "linux" ]; then
   #sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test  # gcc-5
   #wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
   #sudo apt-add-repository -y "deb http://apt.llvm.org/trusty/ llvm-toolchain-trusty-3.9 main"
   #sudo apt-get update
   sudo apt-get -y install python-numpy
   sudo apt-get -y install python-scipy
   #sudo apt-get -y install gfortran
   #sudo apt-get -y install gcc-5 g++-5
   #sudo apt-get -y install valgrind
   #sudo apt-get -y install doxygen
   sudo apt-get -y install cloc
   #sudo apt-get -y install clang-format-3.9 clang-tidy-3.9
   #export CC=gcc-5
   #export CXX=g++-5
   export PYTHON=python
   export FAIRSOFTTAR="https://cernbox.cern.ch/index.php/s/RUwyXapOiiG3tPZ/download"
   export FAIRROOTTAR="https://cernbox.cern.ch/index.php/s/JQpquOipHWLaaJB/download"
   export FAIRSOFT_VERSION=trusty-Jun16
   export FAIRROOT_VERSION=trusty-Jun16
fi

# install FairSoft
wget --progress=dot:giga --no-check-certificate $FAIRSOFTTAR -O FairSoft-${FAIRSOFT_VERSION}.tgz
tar zxf FairSoft-${FAIRSOFT_VERSION}.tgz

# install FairRoot
wget --progress=dot:giga --no-check-certificate $FAIRROOTTAR -O FairRoot-${FAIRSOFT_VERSION}.tgz
tar zxf FairRoot-${FAIRROOT_VERSION}.tgz

# output compiler information
echo ${CXX}
${CXX} --version
${CXX} -v

cd $fairship

# run following commands only on Linux
if [ "$TRAVIS_OS_NAME" = "linux" ]; then
   cloc .
fi

# add master branch
# https://github.com/travis-ci/travis-ci/issues/6069
git remote set-branches --add origin master

# build FairShip
./configure.sh

# run FairShip tests
cd ../FairShipRun
. config.sh
$PYTHON ../FairShip/macro/run_simScript.py --test

# run following commands only on Linux
if [ "$TRAVIS_OS_NAME" = "linux" ]; then
   cd ../FairShip
   #make check-submission
fi