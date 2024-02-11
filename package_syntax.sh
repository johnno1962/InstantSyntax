#!/bin/bash -x
#
# DIY rebuild all binary framework zip files from source.
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

DD=./build
TAG=509.1.1
DEST=../InstantSyntax/$TAG
SOURCE=../swift-syntax

cd "$(dirname "$0")" &&
if [ ! -d $SOURCE ]; then
  git clone https://github.com/apple/swift-syntax.git $SOURCE
  cp -rf swift-syntax.xcodeproj $SOURCE
fi

cd $SOURCE &&
git stash &&
git checkout $TAG &&

git apply <<PATCH &&
diff --git a/Sources/SwiftSyntaxMacrosTestSupport/Assertions.swift b/Sources/SwiftSyntaxMacrosTestSupport/Assertions.swift
index 0d138d55..2f7c1ffd 100644
--- a/Sources/SwiftSyntaxMacrosTestSupport/Assertions.swift
+++ b/Sources/SwiftSyntaxMacrosTestSupport/Assertions.swift
@@ -20,6 +20,11 @@ import SwiftSyntaxMacros
 import SwiftSyntaxMacroExpansion
 import XCTest

+func XCTFail(_ msg: String, file: StaticString = #file, line: UInt = #line) {
+
+}
+func XCTAssertEqual<G: Equatable>(_ a: G, _ b: G, _ msg: String = "?", file: StaticString = #file, line: UInt = #line) {
+}
 // MARK: - Note

 /// Describes a diagnostic note that tests expect to be created by a macro expansion.
diff --git a/Sources/_SwiftSyntaxTestSupport/AssertEqualWithDiff.swift b/Sources/_SwiftSyntaxTestSupport/AssertEqualWithDiff.swift
index 5cbdba15..1f51b91a 100644
--- a/Sources/_SwiftSyntaxTestSupport/AssertEqualWithDiff.swift
+++ b/Sources/_SwiftSyntaxTestSupport/AssertEqualWithDiff.swift
@@ -143,3 +143,21 @@ public func failStringsEqualWithDiff(
     XCTFail(fullMessage, file: file, line: line)
   }
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
  for sdk in macosx iphonesimulator iphoneos appletvsimulator appletvos; do
    xcodebuild archive -target SwiftSyntax-all -sdk $sdk -project swift-syntax.xcodeproj || exit 1
  done
fi &&

for module in SwiftBasicFormat SwiftCompilerPlugin SwiftCompilerPluginMessageHandling SwiftDiagnostics SwiftOperators SwiftParser SwiftParserDiagnostics SwiftSyntax SwiftSyntax509 SwiftSyntaxBuilder SwiftSyntaxMacroExpansion SwiftSyntaxMacros SwiftSyntaxMacrosTestSupport _SwiftSyntaxTestSupport; do

    PLATFORMS=""
    for p in $DD/UninstalledProducts/*/$module.framework; do
      codesign -f --timestamp -s "Developer ID Application" $p || exit 1
      PLATFORMS="$PLATFORMS -framework $p"
    done

    rm -rf $DEST/$module.xcframework
    xcodebuild -create-xcframework $PLATFORMS -output $DEST/$module.xcframework || exit 1
done &&

rm -f libSwiftSyntax-*.a &&
for arch in x86_64 arm64; do
  ar -r libSwiftSyntax-$arch.a $DD/swift-syntax.build/Release/*Swift*.build/Objects-normal/$arch/*.o
  ranlib libSwiftSyntax-$arch.a
done &&

lipo -create libSwiftSyntax-*.a -output $DEST/libSwiftSyntax.a &&

cd $DEST &&

rm -f *.zip &&
zip -9 libSwiftSyntax.a.zip libSwiftSyntax.a &&

for f in *.xcframework; do
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
