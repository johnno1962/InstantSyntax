// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription
import Foundation

let tag = "509.1.1"
let repo = "https://github.com/johnno1962/InstantSyntax/raw/main/\(tag)/"
let clone = #filePath.replacingOccurrences(of: "Package.swift", with: "")
let modules = [
  "SwiftBasicFormat",
  "SwiftCompilerPlugin",
  "SwiftCompilerPluginMessageHandling",
  "SwiftDiagnostics",
  "SwiftOperators",
  "SwiftParser",
  "SwiftParserDiagnostics",
  "SwiftSyntax",
  "SwiftSyntax509",
  "SwiftSyntaxBuilder",
  "SwiftSyntaxMacroExpansion",
  "SwiftSyntaxMacros",
  "SwiftSyntaxMacrosTestSupport",
  "_SwiftSyntaxTestSupport",
]

let package = Package(
  name: "swift-syntax",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  
  products: modules.map {
     .library(name: $0, type: .static, targets: [$0, "InstantSyntax"]) },

  targets: [
    // a target to make sure all the binary frameworks are upacked and available.
    .target(
      name: "InstantSyntax",
      dependencies: modules.map {Target.Dependency(stringLiteral: $0)},
      // As compiler plugins are sandboxed the frameworks cannot be loaded.
      // Add these flags to this target and they are added to the main link
      // of each plugin. Override all the frameworks to be weak so they don't
      // even attempt to load (which will just fail) and rely on the statically
      // linked versions from the SwiftSyntax static library included in the repo.
      linkerSettings: [.unsafeFlags(["\(clone)\(tag)/libSwiftSyntax.a"] +
                                    modules.flatMap({ ["-weak_framework", $0] }))]
    ),
    // .library(name: "SwiftBasicFormat", type: .static, targets: ["SwiftBasicFormat", "InstantSyntax"]),
    .binaryTarget(
        name: "SwiftBasicFormat",
        url: repo + "SwiftBasicFormat.framework.xcframework.zip",
        checksum: "9478174e692363f2ec3e719e459bd6ae7278fbffe2009eacff3669a7062ae49e"
    ),
    // .library(name: "SwiftCompilerPlugin", type: .static, targets: ["SwiftCompilerPlugin", "InstantSyntax"]),
    .binaryTarget(
        name: "SwiftCompilerPlugin",
        url: repo + "SwiftCompilerPlugin.framework.xcframework.zip",
        checksum: "953cf791f14bba72574d26a8020d0d9823554d8e7d70c550153a151b954d68aa"
    ),
    // .library(name: "SwiftCompilerPluginMessageHandling", type: .static, targets: ["SwiftCompilerPluginMessageHandling", "InstantSyntax"]),
    .binaryTarget(
        name: "SwiftCompilerPluginMessageHandling",
        url: repo + "SwiftCompilerPluginMessageHandling.framework.xcframework.zip",
        checksum: "75e63a5015af6a4f8a46885df91dbf4fc070089747efc79b771b640f5547b231"
    ),
    // .library(name: "SwiftDiagnostics", type: .static, targets: ["SwiftDiagnostics", "InstantSyntax"]),
    .binaryTarget(
        name: "SwiftDiagnostics",
        url: repo + "SwiftDiagnostics.framework.xcframework.zip",
        checksum: "d74548cb3d322dfb1ddc5c42611508f1b581e0febe98334076aaca8b7a4f8209"
    ),
    // .library(name: "SwiftOperators", type: .static, targets: ["SwiftOperators", "InstantSyntax"]),
    .binaryTarget(
        name: "SwiftOperators",
        url: repo + "SwiftOperators.framework.xcframework.zip",
        checksum: "60f5e7202f2d7ee95cb48f22c972999f0f3c473c8dd651e3b7bc98e93508510a"
    ),
    // .library(name: "SwiftParser", type: .static, targets: ["SwiftParser", "InstantSyntax"]),
    .binaryTarget(
        name: "SwiftParser",
        url: repo + "SwiftParser.framework.xcframework.zip",
        checksum: "135225b16c01558211009f3d688886161fdd40466b6ca61d48b8f5afd67f5055"
    ),
    // .library(name: "SwiftParserDiagnostics", type: .static, targets: ["SwiftParserDiagnostics", "InstantSyntax"]),
    .binaryTarget(
        name: "SwiftParserDiagnostics",
        url: repo + "SwiftParserDiagnostics.framework.xcframework.zip",
        checksum: "eb9d444a5c2bd3e3a75b589748a6bf7d100e53f90e05197011db28bc9cb90d73"
    ),
    // .library(name: "SwiftSyntax", type: .static, targets: ["SwiftSyntax", "InstantSyntax"]),
    .binaryTarget(
        name: "SwiftSyntax",
        url: repo + "SwiftSyntax.framework.xcframework.zip",
        checksum: "ed1f5a65ba9880fc11937a38b429234e738ede9bba19f92b005658cb778cb7a0"
    ),
    // .library(name: "SwiftSyntax509", type: .static, targets: ["SwiftSyntax509", "InstantSyntax"]),
    .binaryTarget(
        name: "SwiftSyntax509",
        url: repo + "SwiftSyntax509.framework.xcframework.zip",
        checksum: "76b5c3f5b01ce5c75d5dff3026b9894169a2a0e435e313dbd35768ebeb092f1d"
    ),
    // .library(name: "SwiftSyntaxBuilder", type: .static, targets: ["SwiftSyntaxBuilder", "InstantSyntax"]),
    .binaryTarget(
        name: "SwiftSyntaxBuilder",
        url: repo + "SwiftSyntaxBuilder.framework.xcframework.zip",
        checksum: "fee97042e6fec0244083c2b9cc2603266cffdbea0ee16dc61d03313c7677faf0"
    ),
    // .library(name: "SwiftSyntaxMacroExpansion", type: .static, targets: ["SwiftSyntaxMacroExpansion", "InstantSyntax"]),
    .binaryTarget(
        name: "SwiftSyntaxMacroExpansion",
        url: repo + "SwiftSyntaxMacroExpansion.framework.xcframework.zip",
        checksum: "e576ac4cfbbdd9ecf64e0206a68a2e6679919b5bf9c9f114d11ebfdeb0cbe5dc"
    ),
    // .library(name: "SwiftSyntaxMacros", type: .static, targets: ["SwiftSyntaxMacros", "InstantSyntax"]),
    .binaryTarget(
        name: "SwiftSyntaxMacros",
        url: repo + "SwiftSyntaxMacros.framework.xcframework.zip",
        checksum: "b02e1e090fb4235cf83e9194de76900975b6c15effbfa39580085f93cadf5282"
    ),
    // .library(name: "SwiftSyntaxMacrosTestSupport", type: .static, targets: ["SwiftSyntaxMacrosTestSupport", "InstantSyntax"]),
    .binaryTarget(
        name: "SwiftSyntaxMacrosTestSupport",
        url: repo + "SwiftSyntaxMacrosTestSupport.framework.xcframework.zip",
        checksum: "a4ced83b4f5ee62ff74875f8488205f58c122c91a7df0aeeed20001b6b4194d0"
    ),
    // .library(name: "_SwiftSyntaxTestSupport", targets: ["_SwiftSyntaxTestSupport", "InstantSyntax"]),
    .binaryTarget(
        name: "_SwiftSyntaxTestSupport",
        url: repo + "_SwiftSyntaxTestSupport.framework.xcframework.zip",
        checksum: "fcc53aacf46fdb09d58feda9db5742d651b7fb6a74dc38612a26770796e5de1c"
    ),
  ]
)
