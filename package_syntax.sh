#!/bin/bash -x
#
# DIY rebuild of all binary framework zip files from Apple source.
# This script takes about half an hour to run through.
#
# Make a fork of https://github.com/johnno1962/InstantSyntax
# clone it and run this script inside the clone.
#

cd "$(dirname "$0")" &&

export REPO=${1:-https://github.com/apple/swift-syntax}
export REPO_NAME=`basename "$REPO"`
export TAG=${2:-601.0.1}
export DEST="$PWD/$TAG"
export SOURCE="/tmp/$REPO_NAME"
export XCODED=`xcode-select -p`

if [ ! -d "$SOURCE" ]; then
  git clone "$REPO" "$SOURCE"
fi

mkdir -p $DEST &&
cd $SOURCE &&
git stash &&
git checkout $TAG &&

git apply <<RENAME
index 10adca69..52310baf 100644
--- a/Package.swift
+++ b/Package.swift
@@ -40,7 +40,11 @@ if buildDynamicLibrary {
     .library(name: "SwiftSyntaxMacroExpansion", targets: ["SwiftSyntaxMacroExpansion"]),
     .library(name: "SwiftSyntaxMacrosTestSupport", targets: ["SwiftSyntaxMacrosTestSupport"]),
     .library(name: "SwiftSyntaxMacrosGenericTestSupport", targets: ["SwiftSyntaxMacrosGenericTestSupport"]),
-    .library(name: "_SwiftCompilerPluginMessageHandling", targets: ["SwiftCompilerPluginMessageHandling"]),
+    .library(name: "SwiftSyntax509", targets: ["SwiftSyntax509"]),
+    .library(name: "SwiftSyntax510", targets: ["SwiftSyntax510"]),
+    .library(name: "SwiftSyntax600", targets: ["SwiftSyntax600"]),
+    .library(name: "SwiftSyntax601", targets: ["SwiftSyntax601"]),
+    .library(name: "SwiftCompilerPluginMessageHandling", targets: ["SwiftCompilerPluginMessageHandling"]),
     .library(name: "_SwiftLibraryPluginProvider", targets: ["SwiftLibraryPluginProvider"]),
   ]
 }
RENAME

export MODULES=`cd Sources; echo {Swift,_}*; cd VersionMarkerModules; echo *`
export PLATFORMS="${3:-macOS iOS iOS_Simulator tvOS_Simulator}"
export CONDITIONS="RESILIENT_LIBRARIES"
export PARALLEL_BUILDS=4
export CONFIG=Release

ln -sf $CONFIG macos-arm64_x86_64 &&
ln -sf $CONFIG-iphoneos ios-arm64 &&
ln -sf $CONFIG-iphonesimulator ios-arm64_x86_64-simulator &&
ln -sf $CONFIG-appletvsimulator tvos-arm64_x86_64-simulator &&

cat <<'INNER' >/tmp/INNER.sh
        PLATFORM=$1
        DD="$SOURCE/build.$PLATFORM"
        time $XCODED/usr/bin/xcodebuild archive -scheme $MODULE -quiet -configuration $CONFIG -destination "generic/platform=$(echo $PLATFORM | sed -e 's/_/ /g')" -archivePath $SOURCE/archives/$MODULE-$PLATFORM.xcarchive -derivedDataPath $DD SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES SWIFT_SERIALIZE_DEBUGGING_OPTIONS=NO SWIFT_ACTIVE_COMPILATION_CONDITIONS="$CONDITIONS" || exit 1
INNER

for MODULE in $MODULES; do
    export MODULE
    /bin/bash -x <<'OUTER'
    LIBS=""
    cd $SOURCE &&
    echo $PLATFORMS | sed -e 's/ /\n/g' | xargs -P $PARALLEL_BUILDS -I % bash -x /tmp/INNER.sh %

    for PLATFORM in $PLATFORMS; do
        DD="$SOURCE/build.$PLATFORM"
        LIB="$DD/lib$MODULE.a"
        rm -f $DD/lib$MODULE*.a &&
        cd $DD/Build/Intermediates.noindex/ArchiveIntermediates/*/IntermediateBuildFilesPath/*.build/$CONFIG*/$MODULE.build/Objects-normal &&
        for a in *; do
            ar qv $DD/lib$MODULE.$a.a $a/*.o
        done && cd -
        lipo -create $DD/lib$MODULE.*.a -output $LIB &&
        LIBS="$LIBS -library $LIB"
    done
        
    rm -rf $DEST/$MODULE.xcframework &&
    $XCODED/usr/bin/xcodebuild -create-xcframework $LIBS -output $DEST/$MODULE.xcframework || exit 1

    cd $DEST/$MODULE.xcframework && for p in *; do if [ $p != "Info.plist" ]; then
        DIR=`readlink "$SOURCE/$p"`
        cp -r $SOURCE/build.*/Build/Intermediates.noindex/ArchiveIntermediates/*/BuildProductsPath/$DIR/$MODULE.swiftmodule $DEST/$MODULE.xcframework/$p ||
        cp -r $SOURCE/build.*/Build/Intermediates.noindex/ArchiveIntermediates/*/BuildProductsPath/$DIR/SwiftSyntax509.swiftmodule $DEST/$MODULE.xcframework/$p
    fi done

    cd $DEST && rm -f $MODULE.xcframework.zip $MODULE.xcframework/*/*/*.swiftmodule &&
    codesign -f --timestamp -s "Developer ID Application" $MODULE.xcframework &&
    zip -r9 --symlinks "$MODULE.xcframework.zip" "$MODULE.xcframework" >>../../zips.txt &
OUTER
done && sleep 10 && echo "Build complete."
