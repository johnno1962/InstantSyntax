#!/bin/bash -x
#
# DIY rebuild of all binary framework zip files from Apple source.
# This script takes about half an hour to run through.
#
# Make a fork of https://github.com/johnno1962/InstantSyntax
# clone it and run this script inside the clone.
#

export REPO=${1:-https://github.com/apple/swift-syntax}
export REPO_NAME=`basename "$REPO"`
export TAG=${2:-601.0.1}
export DEST="$PWD/$TAG"
export SOURCE="/tmp/$REPO_NAME"
export XCODED=`xcode-select -p`

if [ -f Package.swift ]; then
    export MANIFEST="$PWD/Package.swift.generated"
else
    export MANIFEST="$PWD/Package.swift"
fi

if [ ! -d "$SOURCE" ]; then
  git clone "$REPO" "$SOURCE"
fi

mkdir -p $DEST &&
cd $SOURCE &&
git stash &&
git checkout $TAG &&

git apply <<RENAME
diff --git a/Package.swift b/Package.swift
index 10adca69..7329c65d 100644
--- a/Package.swift
+++ b/Package.swift
@@ -40,8 +40,14 @@ if buildDynamicLibrary {
     .library(name: "SwiftSyntaxMacroExpansion", targets: ["SwiftSyntaxMacroExpansion"]),
     .library(name: "SwiftSyntaxMacrosTestSupport", targets: ["SwiftSyntaxMacrosTestSupport"]),
     .library(name: "SwiftSyntaxMacrosGenericTestSupport", targets: ["SwiftSyntaxMacrosGenericTestSupport"]),
+    .library(name: "SwiftSyntax509", targets: ["SwiftSyntax509"]),
+    .library(name: "SwiftSyntax510", targets: ["SwiftSyntax510"]),
+    .library(name: "SwiftSyntax600", targets: ["SwiftSyntax600"]),
+    .library(name: "SwiftSyntax601", targets: ["SwiftSyntax601"]),
+    .library(name: "SwiftCompilerPluginMessageHandling", targets: ["SwiftCompilerPluginMessageHandling"]),
     .library(name: "_SwiftCompilerPluginMessageHandling", targets: ["SwiftCompilerPluginMessageHandling"]),
     .library(name: "_SwiftLibraryPluginProvider", targets: ["SwiftLibraryPluginProvider"]),
+    .library(name: "_SwiftSyntaxTestSupport", targets: ["_SwiftSyntaxTestSupport"]),
   ]
 }
 
RENAME

export MODULES="SwiftCompilerPluginMessageHandling"
for module in `cd Sources; echo {Swift,_}*; cd VersionMarkerModules; echo *`; do
    if [[ $module =~ \.txt ]]; then echo "Skipping $module"
    elif grep ".library(name: \"_$module\"" $SOURCE/Package.swift
    then MODULES="_$module $MODULES"
    else MODULES="$module $MODULES"
    fi
done
export PLATFORMS="${3:-macOS iOS iOS_Simulator tvOS_Simulator}"
export CONDITIONS="RESILIENT_LIBRARIES"
export PARALLEL_BUILDS=4
export CONFIG=Release

ln -sf $CONFIG macos-arm64_x86_64 &&
ln -sf $CONFIG-iphoneos ios-arm64 &&
ln -sf $CONFIG-iphonesimulator ios-arm64_x86_64-simulator &&
ln -sf $CONFIG-appletvsimulator tvos-arm64_x86_64-simulator &&

cat <<PACKAGE >$MANIFEST
// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let tag = "$TAG" // $REPO version
let modules: [(name: String, checksum: String, depends: [String])] = [
PACKAGE

cat <<'INNER' >/tmp/INNER.sh
        PLATFORM=$1
        DDATA="$SOURCE/build.$PLATFORM"
        time $XCODED/usr/bin/xcodebuild -scheme $MODULE -quiet -configuration $CONFIG -destination "generic/platform=$(echo $PLATFORM | sed -e 's/_/ /g')" -archivePath $SOURCE/archives/$MODULE-$PLATFORM.xcarchive -derivedDataPath $DDATA SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES SWIFT_SERIALIZE_DEBUGGING_OPTIONS=NO SWIFT_ACTIVE_COMPILATION_CONDITIONS="$CONDITIONS" || exit 1
INNER

for MODULE in $MODULES; do
    export MODULE
    /bin/bash -x <<'OUTER'
    LIBS=""
    cd $SOURCE &&
    echo $PLATFORMS | sed -e 's/ /\n/g' | xargs -P $PARALLEL_BUILDS -I % bash -x /tmp/INNER.sh % &&
    cat <<PACKAGE >>$MANIFEST
    ("$MODULE", "__CHECKSUM__${MODULE}__", ["$MODULE"]),
PACKAGE

    for PLATFORM in $PLATFORMS; do
        DDATA="$SOURCE/build.$PLATFORM"
        LIB="$DDATA/lib$MODULE.a"
        rm -f $DDATA/lib$MODULE*.a &&
        cd $DDATA/Build/Intermediates.noindex/*.build/$CONFIG*/*`echo $MODULE | sed s/^_//`.build/Objects-normal &&
        for ARCH in *; do
            ar qv $DDATA/lib$MODULE.$ARCH.a $ARCH/*.o &&
            ranlib $DDATA/lib$MODULE.$ARCH.a
        done && cd -
        lipo -create $DDATA/lib$MODULE.*.a -output $LIB &&
        LIBS="$LIBS -library $LIB"
    done
        
    rm -rf $DEST/$MODULE.xcframework &&
    $XCODED/usr/bin/xcodebuild -create-xcframework $LIBS -output $DEST/$MODULE.xcframework || exit 1

    cd $DEST/$MODULE.xcframework && for VARIANT in *; do if [ $VARIANT != "Info.plist" ]; then
        DIR=`readlink "$SOURCE/$VARIANT"`
        cp -r $SOURCE/build.*/Build/Products/$DIR/$MODULE.swiftmodule $VARIANT ||
        cp -rf $SOURCE/build.*/Build/Products/$DIR/SwiftSyntax509.swiftmodule $VARIANT/$MODULE.swiftmodule
    fi done

    cd $DEST && rm -f $MODULE.xcframework.zip $MODULE.xcframework/*/*/*.swiftmodule &&
    codesign -f --timestamp -s "Developer ID Application" $MODULE.xcframework &&
    (zip -r9 --symlinks "$MODULE.xcframework.zip" "$MODULE.xcframework" >>../../zips.txt; \
     CHECKSUM=`swift package compute-checksum "$MODULE.xcframework.zip"`; \
     for MANIFEST in $MANIFEST ../Package.swift; do \
     sed -e "s/[(]\"$MODULE\", \"[^\"]*/(\"$MODULE\", \"$CHECKSUM/g" <$MANIFEST >$MANIFEST.$$ && \
     mv -f $MANIFEST.$$ $MANIFEST; done) &
OUTER
done && sleep 10 && cat <<PACKAGE >>$MANIFEST && echo "Build complete."
]

let package = Package(
  name: "$REPO_NAME",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  
  products: modules.map {
      .library(name: \$0.name, targets: [\$0.name] + \$0.depends
    ) },

  targets: modules.map {
      .binaryTarget(
          name: \$0.name,
          path: tag + "/" + "\(\$0.name).xcframework.zip"
    ) }
)
PACKAGE
