#!/bin/bash -e
. /etc/profile.d/modules.sh
SOURCE_FILE=${NAME}-${VERSION}.tar.gz
module add ci
module add openssl

# We need to make the dependencies and then curl.

mkdir -p $WORKSPACE
mkdir -p $SRC_DIR
mkdir -p $SOFT_DIR

#  Download the source file
# libxml2
# openssl
# metalink

if [ ! -e ${SRC_DIR}/${SOURCE_FILE}.lock ] && [ ! -s ${SRC_DIR}/${SOURCE_FILE} ] ; then
  touch  ${SRC_DIR}/${SOURCE_FILE}.lock
  echo "seems like this is the first build - let's get the source"
  mkdir -p $SRC_DIR
  wget http://curl.haxx.se/download/${SOURCE_FILE} -O $SRC_DIR/$SOURCE_FILE
else
  echo "continuing from previous builds, using source at " $SRC_DIR/$SOURCE_FILE
fi
ls -lht ${SRC_DIR}/${SOURCE_FILE}
echo "extracting the tarball"
tar xfz ${SRC_DIR}/${SOURCE_FILE} -C ${WORKSPACE}
echo "Going to ${WORKSPACE}/${NAME}-${VERSION}"
cd ${WORKSPACE}/${NAME}
mkdir build-${BUILD_NUMBER}
cd ${BUILD_NUMBER}
../configure
