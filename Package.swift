// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "swift-syntax",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
     .library(name: "InstantSyntax", targets: ["InstantSyntax"]),
     .library(name: "SwiftBasicFormat", targets: ["SwiftBasicFormat"]),
     .library(name: "SwiftCompilerPlugin", targets: ["SwiftCompilerPlugin"]),
     .library(name: "SwiftCompilerPluginMessageHandling", targets: ["SwiftCompilerPluginMessageHandling"]),
     .library(name: "SwiftDiagnostics", targets: ["SwiftDiagnostics"]),
     .library(name: "SwiftOperators", targets: ["SwiftOperators"]),
     .library(name: "SwiftParser", targets: ["SwiftParser"]),
     .library(name: "SwiftParserDiagnostics", targets: ["SwiftParserDiagnostics"]),
     .library(name: "SwiftSyntax", targets: ["SwiftSyntax"]),
     .library(name: "SwiftSyntax509", targets: ["SwiftSyntax509"]),
     .library(name: "SwiftSyntaxBuilder", targets: ["SwiftSyntaxBuilder"]),
     .library(name: "SwiftSyntaxMacroExpansion", targets: ["SwiftSyntaxMacroExpansion"]),
     .library(name: "SwiftSyntaxMacros", targets: ["SwiftSyntaxMacros"]),
     .library(name: "SwiftSyntaxMacrosTestSupport", targets: ["SwiftSyntaxMacrosTestSupport"]),
     .library(name: "_SwiftSyntaxTestSupport", targets: ["_SwiftSyntaxTestSupport"]),  ],
  targets: [
    .target(
      name: "InstantSyntax",
      dependencies: [
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
    ),
    // .library(name: "SwiftBasicFormat", targets: ["SwiftBasicFormat"]),
    .binaryTarget(
        name: "SwiftBasicFormat",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftBasicFormat.framework.xcframework.zip",
        checksum: "9478174e692363f2ec3e719e459bd6ae7278fbffe2009eacff3669a7062ae49e"
    ),
    // .library(name: "SwiftCompilerPlugin", targets: ["SwiftCompilerPlugin"]),
    .binaryTarget(
        name: "SwiftCompilerPlugin",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftCompilerPlugin.framework.xcframework.zip",
        checksum: "953cf791f14bba72574d26a8020d0d9823554d8e7d70c550153a151b954d68aa"
    ),
    // .library(name: "SwiftCompilerPluginMessageHandling", targets: ["SwiftCompilerPluginMessageHandling"]),
    .binaryTarget(
        name: "SwiftCompilerPluginMessageHandling",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftCompilerPluginMessageHandling.framework.xcframework.zip",
        checksum: "75e63a5015af6a4f8a46885df91dbf4fc070089747efc79b771b640f5547b231"
    ),
    // .library(name: "SwiftDiagnostics", targets: ["SwiftDiagnostics"]),
    .binaryTarget(
        name: "SwiftDiagnostics",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftDiagnostics.framework.xcframework.zip",
        checksum: "d74548cb3d322dfb1ddc5c42611508f1b581e0febe98334076aaca8b7a4f8209"
    ),
    // .library(name: "SwiftOperators", targets: ["SwiftOperators"]),
    .binaryTarget(
        name: "SwiftOperators",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftOperators.framework.xcframework.zip",
        checksum: "60f5e7202f2d7ee95cb48f22c972999f0f3c473c8dd651e3b7bc98e93508510a"
    ),
    // .library(name: "SwiftParser", targets: ["SwiftParser"]),
    .binaryTarget(
        name: "SwiftParser",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftParser.framework.xcframework.zip",
        checksum: "135225b16c01558211009f3d688886161fdd40466b6ca61d48b8f5afd67f5055"
    ),
    // .library(name: "SwiftParserDiagnostics", targets: ["SwiftParserDiagnostics"]),
    .binaryTarget(
        name: "SwiftParserDiagnostics",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftParserDiagnostics.framework.xcframework.zip",
        checksum: "eb9d444a5c2bd3e3a75b589748a6bf7d100e53f90e05197011db28bc9cb90d73"
    ),
    // .library(name: "SwiftSyntax", targets: ["SwiftSyntax"]),
    .binaryTarget(
        name: "SwiftSyntax",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftSyntax.framework.xcframework.zip",
        checksum: "ed1f5a65ba9880fc11937a38b429234e738ede9bba19f92b005658cb778cb7a0"
    ),
    // .library(name: "SwiftSyntax509", targets: ["SwiftSyntax509"]),
    .binaryTarget(
        name: "SwiftSyntax509",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftSyntax509.framework.xcframework.zip",
        checksum: "76b5c3f5b01ce5c75d5dff3026b9894169a2a0e435e313dbd35768ebeb092f1d"
    ),
    // .library(name: "SwiftSyntaxBuilder", targets: ["SwiftSyntaxBuilder"]),
    .binaryTarget(
        name: "SwiftSyntaxBuilder",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftSyntaxBuilder.framework.xcframework.zip",
        checksum: "fee97042e6fec0244083c2b9cc2603266cffdbea0ee16dc61d03313c7677faf0"
    ),
    // .library(name: "SwiftSyntaxMacroExpansion", targets: ["SwiftSyntaxMacroExpansion"]),
    .binaryTarget(
        name: "SwiftSyntaxMacroExpansion",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftSyntaxMacroExpansion.framework.xcframework.zip",
        checksum: "e576ac4cfbbdd9ecf64e0206a68a2e6679919b5bf9c9f114d11ebfdeb0cbe5dc"
    ),
    // .library(name: "SwiftSyntaxMacros", targets: ["SwiftSyntaxMacros"]),
    .binaryTarget(
        name: "SwiftSyntaxMacros",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftSyntaxMacros.framework.xcframework.zip",
        checksum: "b02e1e090fb4235cf83e9194de76900975b6c15effbfa39580085f93cadf5282"
    ),
    // .library(name: "SwiftSyntaxMacrosTestSupport", targets: ["SwiftSyntaxMacrosTestSupport"]),
    .binaryTarget(
        name: "SwiftSyntaxMacrosTestSupport",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftSyntaxMacrosTestSupport.framework.xcframework.zip",
        checksum: "a4ced83b4f5ee62ff74875f8488205f58c122c91a7df0aeeed20001b6b4194d0"
    ),
    // .library(name: "_SwiftSyntaxTestSupport", targets: ["_SwiftSyntaxTestSupport"]),
    .binaryTarget(
        name: "_SwiftSyntaxTestSupport",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/_SwiftSyntaxTestSupport.framework.xcframework.zip",
        checksum: "fcc53aacf46fdb09d58feda9db5742d651b7fb6a74dc38612a26770796e5de1c"
    ),
  ]
)
