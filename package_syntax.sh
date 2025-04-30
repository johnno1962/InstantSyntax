#!/bin/bash -x
#
# DIY rebuild of all binary framework zip files from Apple source.
# This script takes about half an hour to run through.
#
# Make a fork of https://github.com/johnno1962/InstantSyntax
# clone it and run this file inside the clone.
#
# The command to create the swift_syntax.xcodeproj (Xcode 13) is:
# swift package generate-xcodeproj
#

cd "$(dirname "$0")" &&

TAG=${1:-601.0.1}
DEST="$PWD/$TAG"
SOURCE=/tmp/swift-syntax
XCODED=`xcode-select -p`
DD="$SOURCE/build"

if [ ! -d $SOURCE ]; then
  git clone https://github.com/apple/swift-syntax.git $SOURCE &&
  cp -rf swift-syntax.xcodeproj $SOURCE
fi &&

mkdir -p $DEST &&
cd $SOURCE &&
git stash &&
git checkout $TAG &&

# These patches required when using xcodebuild.
git apply -v <<PATCH &&
diff --git a/Sources/SwiftSyntaxMacrosTestSupport/Assertions.swift b/Sources/SwiftSyntaxMacrosTestSupport/Assertions.swift
index 6ff8ba2b..5c776b2f 100644
--- a/Sources/SwiftSyntaxMacrosTestSupport/Assertions.swift
+++ b/Sources/SwiftSyntaxMacrosTestSupport/Assertions.swift
@@ -358,3 +358,9 @@ public func assertMacroExpansion(
     column: 0  // Not used in the failure handler
   )
 }
+
+func XCTFail(_ msg: String, file: StaticString = #file, line: UInt = #line) {
+
+}
+func XCTAssertEqual<G: Equatable>(_ a: G, _ b: G, _ msg: String = "?", file: StaticString = #file, line: UInt = #line) {
+}
diff --git a/Sources/_SwiftSyntaxTestSupport/AssertEqualWithDiff.swift b/Sources/_SwiftSyntaxTestSupport/AssertEqualWithDiff.swift
index 5cbdba15..1f51b91a 100644
--- a/Sources/_SwiftSyntaxTestSupport/AssertEqualWithDiff.swift
+++ b/Sources/_SwiftSyntaxTestSupport/AssertEqualWithDiff.swift
@@ -143,3 +143,21 @@ public func failStringsEqualWithDiff(
     line: line
   )
 }
+
+func XCTFail(_ msg: String, file: StaticString = #file, line: UInt = #line) {
+
+}
+func XCTAssertTrue(_ msg: Bool, file: StaticString = #file, line: UInt = #line) {
+
+}
+func XCTAssert(_ opt: Bool, _ msg: String = "?", file: StaticString = #file, line: UInt = #line) {
+
+}
+func XCTAssertNil<G>(_ opt: Optional<G>, file: StaticString = #file, line: UInt = #line) {
+
+}
+func XCTUnwrap<G>(_ opt: Optional<G>, file: StaticString = #file, line: UInt = #line) -> G {
+  return opt!
+}
+func XCTAssertEqual<G>(_ a: G, _ b: G, _ msg: String = "?", file: StaticString = #file, line: UInt = #line) {
+}
PATCH

PLATFORMS="macosx iphonesimulator iphoneos"
if [ ! -d build ]; then
  for sdk in $PLATFORMS; do #appletvsimulator appletvos xrsimulator xros; do
    $XCODED/usr/bin/xcodebuild archive -target SwiftSyntax-all -sdk $sdk -project swift-syntax.xcodeproj || exit 1
  done
fi &&

ln -sf Release $DD/macos-arm64_x86_64 &&
ln -sf Release-iphoneos $DD/ios-arm64 &&
ln -sf Release-iphonesimulator $DD/ios-arm64_x86_64-simulator &&

MODULES="SwiftBasicFormat SwiftCompilerPlugin SwiftCompilerPluginMessageHandling SwiftDiagnostics SwiftIDEUtils SwiftIfConfig SwiftLexicalLookup SwiftOperators SwiftParser SwiftParserDiagnostics SwiftRefactor SwiftSyntax SwiftSyntax509 SwiftSyntax510 SwiftSyntax600 SwiftSyntax601  SwiftSyntaxBuilder SwiftSyntaxMacroExpansion SwiftSyntaxMacros SwiftSyntaxMacrosTestSupport SwiftSyntaxMacrosGenericTestSupport _SwiftSyntaxCShims _SwiftSyntaxTestSupport"
for module in $MODULES; do # _SwiftCompilerPluginMessageHandling _SwiftLibraryPluginProvider; do

    PLATFORMS=""
    for p in $DD/UninstalledProducts/*/$module.framework; do
      codesign -f --timestamp -s "Developer ID Application" $p || exit 1
      PLATFORMS="$PLATFORMS -framework $p"
    done

    rm -rf $DEST/$module.xcframework
    $XCODED/usr/bin/xcodebuild -create-xcframework $PLATFORMS -output $DEST/$module.xcframework || exit 1
    
    LIBS=""
    cd $DEST/$module.xcframework && for p in *; do if [ $p != "Info.plist" ]; then
        DIR=`readlink "$DD"/$p`
        LIB="$DD/$p/lib$module.a"
        LIBS="$LIBS -library $LIB"
        rm -f $DD/lib$module*.a &&
        cd $DD/swift-syntax.build/$DIR/$module.build/Objects-normal &&
        for a in *; do
            ar qv $DD/lib$module.$a.a $a/*.o
        done &&
        lipo -create $DD/lib$module.*.a -output $LIB
    fi done

    rm -rf $DEST/static.$module.xcframework &&
    $XCODED/usr/bin/xcodebuild -create-xcframework $LIBS -output $DEST/static.$module.xcframework || exit 1

    cd $DEST/$module.xcframework && for p in *; do if [ $p != "Info.plist" ]; then
        cp -r $DEST/$module.xcframework/$p/$module.framework/Modules/*.swiftmodule $DEST/static.$module.xcframework/$p ||
        cp -r $DEST/SwiftSyntax509.xcframework/$p/SwiftSyntax509.framework/Modules/*.swiftmodule $DEST/static.$module.xcframework/$p/$module.swiftmodule
    fi done

    codesign -f --timestamp -s "Developer ID Application" $DEST/static.$module.xcframework
    FWKS="$FWKS $module.xcframework"
done &&

cd $DEST && rm -f *.zip &&
for f in $MODULES; do
    rm -r $f.xcframework && mv static.$f.xcframework $f.xcframework &&
    zip -r9 --symlinks "$f.xcframework.zip"  "$f.xcframework" >>../../zips.txt
done

echo "Build complete."
