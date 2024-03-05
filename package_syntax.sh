#!/bin/bash -x
#
# DIY rebuild of all binary framework zip files from source.
# This script takes about half an hour to run through.
#
# Make a fork of https://github.com/johnno1962/InstantSyntax
# clone it and run this file inside the clone. After completion,
# edit binary targets in Package.swift for the updated checksums
# using copy and paste and the base URL of your fork then commit.
# The zver in Package.swift needs to tie with a tag on your fork.
#
# The command to create the swift_syntax.xcodeproj (Xcode 13) is:
# swift package generate-xcodeproj
#

TAG=510.0.0
DD=/private/tmp/swift-syntax
DEST=../InstantSyntax/$TAG
SOURCE=../swift-syntax

cd "$(dirname "$0")" &&
if [ ! -d $SOURCE ]; then
  git clone https://github.com/apple/swift-syntax.git $SOURCE
#  cp -rf swift-syntax.xcodeproj $SOURCE
fi

cd $SOURCE &&
#git stash &&
#git checkout $TAG &&

# This seems to be the easiest way to regenerate the plugin static library.
sed -e 's/, targets: /, type: .static, targets: /' Package.swift >P.swift &&
mv -f P.swift Package.swift &&
arch -arm64 swift build -c release &&
arch -x86_64 swift build -c release &&
lipo -create .build/*-apple-macosx/release/libSwiftCompilerPlugin.a -output $DEST/libSwiftSyntax.a &&

#git checkout Package.swift &&

sed -e 's/, type: .static, targets: /, type: .dynamic, targets: /' Package.swift >P.swift &&
mv -f P.swift Package.swift &&

for module in SwiftBasicFormat SwiftCompilerPlugin SwiftCompilerPluginMessageHandling SwiftDiagnostics SwiftIDEUtils SwiftOperators SwiftParser SwiftParserDiagnostics SwiftRefactor SwiftSyntax SwiftSyntaxBuilder SwiftSyntaxMacros SwiftSyntaxMacroExpansion  SwiftSyntaxMacrosTestSupport; do

    for sdk in macosx iphonesimulator iphoneos appletvsimulator appletvos xrsimulator xros; do
        xcodebuild -scheme $module -configuration Release -destination "generic/platform=${sdk}" -derivedDataPath "$DD/$sdk" BUILD_LIBRARY_FOR_DISTRIBUTION=YES SWIFT_SERIALIZE_DEBUGGING_OPTIONS=NO || exit 1
    done

    PLATFORMS=""
    for DERIVED in $DD/*; do
    for FRAMEWORK in $DERIVED/Build/Products/Release*/PackageFrameworks/$module.framework; do
        PLATFORMS="$PLATFORMS -framework $FRAMEWORK" &&

        mkdir -p "$FRAMEWORK/Modules" &&

        find "$DERIVED/Build" -type d -name $module.swiftmodule | xargs -I {} cp -r {} "$FRAMEWORK/Modules" &&

        codesign -f --timestamp -s "Developer ID Application" "$FRAMEWORK"
    done
    done

    rm -rf $DEST/$module.xcframework
    xcodebuild -create-xcframework $PLATFORMS -output $DEST/$module.xcframework || exit 1
done &&

cd $DEST &&
rm -f *.zip &&
zip -9 libSwiftSyntax.a.zip libSwiftSyntax.a &&

for f in *.xcframework; do
    codesign --timestamp -v --sign "Developer ID Application" $f
    zip -r9 --symlinks "$f.zip"  "$f" >>../../zips.txt
    CHECKSUM=`swift package compute-checksum $f.zip`
    cat <<"HERE" | sed -e s/__NAME__/$f/g | sed -e s/.xcframework\",/\",/g | sed -e s/__CHECKSUM__/$CHECKSUM/g | tee -a ../Package.swift
    .binaryTarget(
        name: "__NAME__",
        url: repo + "__NAME__.zip",
        checksum: "__CHECKSUM__"
    ),
HERE
done

echo "Build complete, edit Package.swift to update the checksums"
