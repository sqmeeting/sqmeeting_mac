#! /bin/bash                          
echo "install runtime libs..."

BASE_DIR=`pwd`
echo $BASE_DIR      

install_name_tool -id @loader_path/libRtcCommon.dylib         ${SRCROOT}/../frtc_sdk/dist/lib/rtcsdk/arm64/libRtcCommon.dylib

