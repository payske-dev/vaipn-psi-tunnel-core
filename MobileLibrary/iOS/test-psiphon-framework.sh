#!/usr/bin/env bash

set -e

BASE_DIR=$(cd "$(dirname "$0")" ; pwd -P)
cd ${BASE_DIR}

# The location of the final framework build
BUILD_DIR="${BASE_DIR}/build"

#
# Run tests
# 

cd ${BASE_DIR}

# Run the framework projects tests
xcodebuild test -project "VaipnTunnel/VaipnTunnel.xcodeproj" -scheme "VaipnTunnel" -destination 'platform=iOS Simulator,name=iPhone 7'
rc=$?; if [[ $rc != 0 ]]; then
  echo "FAILURE: VaipnTunnel tests"
  exit $rc
fi

# Run the sample app project tests
rm -rf "SampleApps/TunneledWebRequest/TunneledWebRequest/VaipnTunnel.framework" 
cp -R "${BUILD_DIR}/VaipnTunnel.framework" "SampleApps/TunneledWebRequest/TunneledWebRequest"
xcodebuild test -project "SampleApps/TunneledWebRequest/TunneledWebRequest.xcodeproj" -scheme "TunneledWebRequest" -destination 'platform=iOS Simulator,name=iPhone 7'
rc=$?; if [[ $rc != 0 ]]; then
  echo "FAILURE: TunneledWebRequest tests"
  exit $rc
fi

echo "TESTS DONE"
