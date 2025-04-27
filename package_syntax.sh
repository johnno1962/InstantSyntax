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

cd "$(dirname "$0")" &&

DD=./build
TAG=${1:-601.0.1}
DEST="$PWD/$TAG"
SOURCE=/tmp/swift-syntax
XCODED=`xcode-select -p`

if [ ! -d $SOURCE ]; then
  git clone https://github.com/apple/swift-syntax.git $SOURCE &&
  cp -rf swift-syntax.xcodeproj $SOURCE
fi &&

mkdir -p $DEST &&
cd $SOURCE &&
git stash &&
git checkout $TAG &&

# This seemed to be the easiest way to regenerate the plugin static library.
#sed -e 's/, targets: /, type: .static, targets: /' Package.swift >P.swift &&
#mv -f P.swift Package.swift &&
#rm -rf .build ./build &&
#arch -arm64 $XCODED/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift build -c debug &&
#arch -x86_64 $XCODED/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift build -c debug &&
#lipo -create .build/*-apple-macosx/debug/libSwiftCompilerPlugin.a -output $DEST/libSwiftSyntax.a &&
#git checkout Package.swift &&

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

if [ ! -d build ]; then
  for sdk in macosx iphonesimulator iphoneos; do #appletvsimulator appletvos xrsimulator xros; do
    $XCODED/usr/bin/xcodebuild archive -target SwiftSyntax-all -sdk $sdk -project swift-syntax.xcodeproj || exit 1
  done
fi &&

for module in SwiftBasicFormat SwiftCompilerPlugin SwiftCompilerPluginMessageHandling SwiftDiagnostics SwiftIDEUtils SwiftIfConfig SwiftLexicalLookup SwiftOperators SwiftParser SwiftParserDiagnostics SwiftRefactor SwiftSyntax SwiftSyntax509 SwiftSyntax510 SwiftSyntax600 SwiftSyntax601  SwiftSyntaxBuilder SwiftSyntaxMacroExpansion SwiftSyntaxMacros SwiftSyntaxMacrosTestSupport SwiftSyntaxMacrosGenericTestSupport _SwiftSyntaxCShims _SwiftSyntaxTestSupport; do # _SwiftCompilerPluginMessageHandling _SwiftLibraryPluginProvider; do

    PLATFORMS=""
    for p in $DD/UninstalledProducts/*/$module.framework; do
      codesign -f --timestamp -s "Developer ID Application" $p || exit 1
      PLATFORMS="$PLATFORMS -framework $p"
    done

    rm -rf $DEST/$module.xcframework
    $XCODED/usr/bin/xcodebuild -create-xcframework $PLATFORMS -output $DEST/$module.xcframework || exit 1
    rm -rf `find $DEST/$module.xcframework -name \*-apple-\*.swiftmodule` &&
    codesign -f --timestamp -s "Developer ID Application" $DEST/$module.xcframework
done &&

rm -f $DEST/libSwiftSyntax*.a &&
for a in arm64 x86_64; do
    ar qv $DEST/libSwiftSyntax.$a.a `ls build/swift-syntax.build/Release/*.build/Objects-normal/$a/*.o | sort -u`
done &&

cd $DEST && rm -f *.zip &&
lipo -create libSwiftSyntax.*.a -output libSwiftSyntax.a &&
zip -9 libSwiftSyntax.a.zip libSwiftSyntax.a &&
rm -f libSwiftSyntax.*.a &&

for f in *.xcframework; do
    zip -r9 --symlinks "$f.zip"  "$f" >>../../zips.txt
#    CHECKSUM=`swift package compute-checksum $f.zip`
#    cat <<"HERE" | sed -e s/__NAME__/$f/g | sed -e s/.xcframework\",/\",/g | sed -e s/__CHECKSUM__/$CHECKSUM/g | tee -a ../Package.swift
#    .binaryTarget(
#        name: "__NAME__",
#        url: repo + "__NAME__.zip",
#        checksum: "__CHECKSUM__"
#    ),
#HERE
done

echo "Build complete."
