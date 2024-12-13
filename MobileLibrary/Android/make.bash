#!/usr/bin/env bash

set -e -u -x

if [ ! -f make.bash ]; then
  echo "make.bash must be run from $GOPATH/src/github.com/payske-dev/vaipn-psi-tunnel-core/MobileLibrary/Android"
  exit 1
fi

# $1, if specified, is go build tags
if [ -z ${1+x} ]; then BUILD_TAGS=""; else BUILD_TAGS="$1"; fi

# At this time, vaipn-psi-tunnel-core doesn't support modules
export GO111MODULE=off

export GOCACHE=/tmp

BUILDINFOFILE="vaipn-psi-tunnel-core_buildinfo.txt"
BUILDDATE=$(date --iso-8601=seconds)
BUILDREPO="https://github.com/payske-dev/vaipn-psi-tunnel-core.git"
BUILDREV=$(git rev-parse --short HEAD)
GOVERSION=$(go version | perl -ne '/go version (.*?) / && print $1')

LDFLAGS="\
-s \
-w \
-X github.com/payske-dev/vaipn-psi-tunnel-core/psiphon/common/buildinfo.buildDate=$BUILDDATE \
-X github.com/payske-dev/vaipn-psi-tunnel-core/psiphon/common/buildinfo.buildRepo=$BUILDREPO \
-X github.com/payske-dev/vaipn-psi-tunnel-core/psiphon/common/buildinfo.buildRev=$BUILDREV \
-X github.com/payske-dev/vaipn-psi-tunnel-core/psiphon/common/buildinfo.goVersion=$GOVERSION \
"

echo -e "${BUILDDATE}\n${BUILDREPO}\n${BUILDREV}\n" > $BUILDINFOFILE

echo "Variables for ldflags:"
echo " Build date: ${BUILDDATE}"
echo " Build repo: ${BUILDREPO}"
echo " Build revision: ${BUILDREV}"
echo " Go version: ${GOVERSION}"
echo ""

gomobile bind -v -x -target=android/arm,android/arm64,android/386,android/amd64 -tags="${BUILD_TAGS}" -ldflags="$LDFLAGS" github.com/payske-dev/vaipn-psi-tunnel-core/MobileLibrary/psi
if [ $? != 0 ]; then
  echo "..'gomobile bind' failed, exiting"
  exit $?
fi

mkdir -p build-tmp/psi
unzip -o psi.aar -d build-tmp/psi
yes | cp -f VaipnTunnel/AndroidManifest.xml build-tmp/psi/AndroidManifest.xml
yes | cp -f VaipnTunnel/libs/armeabi-v7a/libtun2socks.so build-tmp/psi/jni/armeabi-v7a/libtun2socks.so
yes | cp -f VaipnTunnel/libs/arm64-v8a/libtun2socks.so build-tmp/psi/jni/arm64-v8a/libtun2socks.so
yes | cp -f VaipnTunnel/libs/x86/libtun2socks.so build-tmp/psi/jni/x86/libtun2socks.so
yes | cp -f VaipnTunnel/libs/x86_64/libtun2socks.so build-tmp/psi/jni/x86_64/libtun2socks.so
mkdir -p build-tmp/psi/res/xml
yes | cp -f VaipnTunnel/ca_vaipnpsi_vaipntunnel_backup_rules.xml build-tmp/psi/res/xml/ca_vaipnpsi_vaipntunnel_backup_rules.xml

javac -d build-tmp -bootclasspath $ANDROID_HOME/platforms/android-$ANDROID_PLATFORM_VERSION/android.jar -source 1.8 -target 1.8 -classpath build-tmp/psi/classes.jar VaipnTunnel/VaipnTunnel.java
if [ $? != 0 ]; then
  echo "..'javac' compiling VaipnTunnel failed, exiting"
  exit $?
fi

cd build-tmp

jar uf psi/classes.jar ca/psiphon/*.class
if [ $? != 0 ]; then
  echo "..'jar' failed to add classes, exiting"
  exit $?
fi

cd -
cd build-tmp/psi
echo -e "-keep class psi.** { *; }\n-keep class ca.vaipnpsi.** { *; }\n"  >> proguard.txt
rm -f ../../ca.vaipnpsi.aar
zip -r ../../ca.vaipnpsi.aar ./
cd -
rm -rf build-tmp
echo "Done"
