#!/bin/sh

cd `dirname $0`
xcodebuild -project ikvm-natives.xcodeproj \
    -target ikvm-natives -sdk iphonesimulator -configuration Release clean build
cp build/Release-iphonesimulator/libikvm-natives.a libikvm-natives-i386.a
xcodebuild -project ikvm-natives.xcodeproj \
    -target ikvm-natives -sdk iphoneos -arch armv6 -configuration Release clean build
cp build/Release-iphoneos/libikvm-natives.a libikvm-natives-arm6.a
xcodebuild -project ikvm-natives.xcodeproj \
    -target ikvm-natives -sdk iphoneos -arch armv7 -configuration Release clean build
cp build/Release-iphoneos/libikvm-natives.a libikvm-natives-arm7.a
lipo -create -output libikvm-natives.a \
    libikvm-natives-i386.a \
    libikvm-natives-arm6.a \
    libikvm-natives-arm7.a
cp libikvm-natives.a ../../bin
rm lib*.a
