#!/bin/ksh

### Clean Build Dir
rm -rf build

### iOS Devices
xcodebuild archive \
	-scheme MOFoundation-iOS \
	-archivePath "./build/ios.xcarchive" \
	-sdk iphoneos \
	SKIP_INSTALL=NO \
	SUPPORTS_MACCATALYST=YES

### iOS Simulator
xcodebuild archive \
	-scheme MOFoundation-iOS \
	-archivePath "./build/ios_sim.xcarchive" \
	-sdk iphonesimulator \
	SKIP_INSTALL=NO

### MacOS
xcodebuild archive \
	-scheme MOFoundation-macOS \
	-archivePath "./build/macos.xcarchive" \
	SKIP_INSTALL=NO

### Mac Catalyst
#	-scheme MOFoundation-maccatalyst \
#	-archivePath "./build/maccatalyst.xcarchive" \
#	SKIP_INSTALL=NO \
#	BUILD_LIBRARIES_FOR_DISTRIBUTION=YES \
#	SUPPORTS_MACCATALYST=YES


xcodebuild -create-xcframework \
-framework "./build/ios.xcarchive/Products/Library/Frameworks/MOFoundation-iOS.framework" \
-framework "./build/ios_sim.xcarchive/Products/Library/Frameworks/MOFoundation-iOS.framework" \
-framework "./build/macos.xcarchive/Products/Library/Frameworks/MOFoundation_macOS.framework" \
-output "./build/MOFoundation.xcframework" 

