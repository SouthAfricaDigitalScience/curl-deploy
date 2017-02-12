#!/bin/bash -e
# this should be run after check-build finishes.
. /etc/profile.d/modules.sh
echo ${SOFT_DIR}
module add deploy
module add openssl/1.0.2
module add zlib
echo ${SOFT_DIR}
cd ${WORKSPACE}/${NAME}-${VERSION}/build-${BUILD_NUMBER}
echo "All tests have passed, will now build into ${SOFT_DIR}"
../configure \
--prefix=${SOFT_DIR}
make install -j2
echo "Creating the modules file directory ${LIBRARIES_MODULES}"
mkdir -p ${LIBRARIES_MODULES}/${NAME}
(
cat <<MODULE_FILE
#%Module1.0
## $NAME modulefile
##
proc ModulesHelp { } {
    puts stderr "       This module does nothing but alert the user"
    puts stderr "       that the [module-info name] module is not available"
}

module-whatis   "$NAME $VERSION : See https://github.com/SouthAfricaDigitalScience/CURL-deploy"
setenv CURL_VERSION                     $VERSION
setenv CURL_DIR                               $::env(CVMFS_DIR)/$::env(SITE)/$::env(OS)/$::env(ARCH)/$NAME/$VERSION
prepend-path PATH                           $::env(CURL_DIR)/bin
prepend-path LD_LIBRARY_PATH   $::env(CURL_DIR)/lib
prepend-path CFLAGS                       "-I${CURL_DIR}/include"
prepend-path LDFLAGS                     "-L${CURL_DIR}/lib -lcurl"
MODULE_FILE
) > ${LIBRARIES_MODULES}/${NAME}/${VERSION}
module avail ${NAME}
module add ${NAME}/${VERSION}
which curl
