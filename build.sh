#!/bin/bash -e
# Copyright 2016 C.S.I.R. Meraka Institute
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

. /etc/profile.d/modules.sh
SOURCE_FILE=${NAME}-${VERSION}.tar.gz
module add ci
module add zlib
module add openssl/1.0.2j

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
cd ${WORKSPACE}/${NAME}-${VERSION}
mkdir build-${BUILD_NUMBER}
cd build-${BUILD_NUMBER}
export CPPFLAGS="-I${OPENSSL_DIR}/include"
export LDFLAGS="-L${OPENSSL_DIR}/lib"
../configure --prefix=${SOFT_DIR} \
--with-ssl=${OPENSSL_DIR}
make
