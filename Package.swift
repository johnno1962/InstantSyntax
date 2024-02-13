// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription
import Foundation

let tag = "509.1.1" // swift-syntax version
let zver = "1.0.11" // tag of zipped xcframeworks
let repo = "https://github.com/johnno1962/InstantSyntax/raw/\(zver)/\(tag)/"
let clone = #filePath.replacingOccurrences(of: "Package.swift", with: "")
let modules: [(name: String, depends: [String])] = [
  ("SwiftBasicFormat", ["SwiftSyntax509"]),
  // *** Resolving source editor problems (SourceKit) ***
  // It might be more correct to uncomment this line and it might even solve a few
  // problems but it results in a scree of error messages with the current Xcode 15.2
  // about "duplicate copy commands being generated" when you are using more than one
  // macro defining package. They should really be just warnings. This is an SPM bug.
  // This may even have been fixed already with 5.10 or more recent 5.9 toolchains.
  ("SwiftCompilerPlugin", []),//["SwiftSyntaxMacroExpansion", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftBasicFormat", "SwiftOperators", "SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftCompilerPluginMessageHandling", ["SwiftSyntaxMacroExpansion", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftBasicFormat", "SwiftOperators", "SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftDiagnostics", ["SwiftSyntax509"]),
  ("SwiftOperators", ["SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftParser", ["SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftParserDiagnostics", ["SwiftParser", "SwiftDiagnostics", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntax", ["SwiftSyntax509"]),
  ("SwiftSyntax509", []),
  ("SwiftSyntaxBuilder", ["SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacroExpansion", ["SwiftOperators", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacros", ["SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacrosTestSupport", ["_SwiftSyntaxTestSupport", "SwiftSyntaxMacroExpansion", "SwiftOperators", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("_SwiftSyntaxTestSupport", ["SwiftSyntaxMacroExpansion", "SwiftOperators", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
]

// As compiler plugins are sandboxed, binary frameworks cannot be loaded.
// Adding these flags to the InstantSyntax target means they are added to
// the linking of all macro plugins. They override all the frameworks to be
// weak so they don't even attempt to load (which will just fail) and rely
// on the statically linked versions from the SwiftSyntax library archive
// included in the repo. Finally, fix up the search paths for frameworks.
let platforms = ["macos-arm64_x86_64", "ios-arm64_x86_64-simulator", "ios-arm64"]
let staticLink = ["\(clone)\(tag)/libSwiftSyntax.a"] +
    modules.map { $0.name }.flatMap({ module in
    ["-weak_framework", module] + platforms.flatMap({
        ["-F", "\(clone)\(tag)/\(module).xcframework/\($0)"] })
    })

let package = Package(
  name: "swift-syntax",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  
  products: modules.map {
      .library(name: $0.name, type: .static, targets: [$0.name, "InstantSyntax"]
               + $0.depends
    ) },

  targets: [
    // a target to patch the linker command for all macro plugins (see above)
    .target(
      name: "InstantSyntax",
//      dependencies: modules.map {Target.Dependency(stringLiteral: $0.name)},
      linkerSettings: [.unsafeFlags(staticLink)]
    ),
    .binaryTarget(
        name: "SwiftBasicFormat",
        url: repo + "SwiftBasicFormat.xcframework.zip",
        checksum: "65ed8310174ca7c61b7fa0969050f1127265d256cce48ebc875a6c06fc7d8a4b"
    ),
    .binaryTarget(
        name: "SwiftCompilerPlugin",
        url: repo + "SwiftCompilerPlugin.xcframework.zip",
        checksum: "1d1ae1d02e17e521ce28bd173bd56603beff0a3d3c19227e8612c675d0e2e9e1"
    ),
    .binaryTarget(
        name: "SwiftCompilerPluginMessageHandling",
        url: repo + "SwiftCompilerPluginMessageHandling.xcframework.zip",
        checksum: "885b4947f16a035174aa240aa1e043091e4bcdf41ca1b518c028127658fd27ea"
    ),
    .binaryTarget(
        name: "SwiftDiagnostics",
        url: repo + "SwiftDiagnostics.xcframework.zip",
        checksum: "5699d76e8a98b027c4d8d1ff55c5febef0c011dbf9c19a58b045b7e60f5b0f73"
    ),
    .binaryTarget(
        name: "SwiftOperators",
        url: repo + "SwiftOperators.xcframework.zip",
        checksum: "0e9df6f921ea7369478296e9de61c10647f3d7617bc587573caf0299bae99feb"
    ),
    .binaryTarget(
        name: "SwiftParser",
        url: repo + "SwiftParser.xcframework.zip",
        checksum: "802072fb39b49121165e72debf575101d9c425c299bbd3a0bfbe833ed799583b"
    ),
    .binaryTarget(
        name: "SwiftParserDiagnostics",
        url: repo + "SwiftParserDiagnostics.xcframework.zip",
        checksum: "9080bbe4ebfd3805b4d31eb7d41d5a516329921880778bbe5887ef8142aa5ae1"
    ),
    .binaryTarget(
        name: "SwiftSyntax",
        url: repo + "SwiftSyntax.xcframework.zip",
        checksum: "c02347fa0522dcfccbb6c75d63a3cf35da392329aef8a10cd8d220a47d722be4"
    ),
    .binaryTarget(
        name: "SwiftSyntax509",
        url: repo + "SwiftSyntax509.xcframework.zip",
        checksum: "f0e83a798d71e9c043aea9564081edd592b8c1b698e0b87234b764087e9d1281"
    ),
    .binaryTarget(
        name: "SwiftSyntaxBuilder",
        url: repo + "SwiftSyntaxBuilder.xcframework.zip",
        checksum: "d5c28e33d8c287563b900bcacd02084c6aba15165bb529e6ba39685f244db9d6"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacroExpansion",
        url: repo + "SwiftSyntaxMacroExpansion.xcframework.zip",
        checksum: "9a6fae2bb85e436753359806372443c7fa0ddb6633954879b2fbcfd1b89345d7"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacros",
        url: repo + "SwiftSyntaxMacros.xcframework.zip",
        checksum: "d2a0147ebddee5fff59a1002762b7abba2fd397673fe11777288dfee0ace6269"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacrosTestSupport",
        url: repo + "SwiftSyntaxMacrosTestSupport.xcframework.zip",
        checksum: "3b2498b29538f8bae2d69210e7a4a6b4911436af9d358aa9ed4b895273987410"
    ),
    .binaryTarget(
        name: "_SwiftSyntaxTestSupport",
        url: repo + "_SwiftSyntaxTestSupport.xcframework.zip",
        checksum: "e92ad786336d3977391a41ce91f3493b79b0bc4d894e879f8a7fe20fec19ccec"
    ),
  ]
)
