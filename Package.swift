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
        checksum: "1a46504376d662c419617e6423207e236fd313834cc8eaddf38bc24d00e98d5a"
    ),
    // .library(name: "SwiftCompilerPlugin", targets: ["SwiftCompilerPlugin"]),
    .binaryTarget(
        name: "SwiftCompilerPlugin",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftCompilerPlugin.framework.xcframework.zip",
        checksum: "a41af23effd566cd5fde1d367b7cfa3b9c7325a6cb49cbc430142fe37f586058"
    ),
    // .library(name: "SwiftCompilerPluginMessageHandling", targets: ["SwiftCompilerPluginMessageHandling"]),
    .binaryTarget(
        name: "SwiftCompilerPluginMessageHandling",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftCompilerPluginMessageHandling.framework.xcframework.zip",
        checksum: "a1dee1eacbf26ae36942fab79b2dcf42705b7923ce0b9ea0611d00576eebb5db"
    ),
    // .library(name: "SwiftDiagnostics", targets: ["SwiftDiagnostics"]),
    .binaryTarget(
        name: "SwiftDiagnostics",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftDiagnostics.framework.xcframework.zip",
        checksum: "710cbc008e8ab290236979df3430364a2c07112510d10c689ef05c1e380ee2af"
    ),
    // .library(name: "SwiftOperators", targets: ["SwiftOperators"]),
    .binaryTarget(
        name: "SwiftOperators",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftOperators.framework.xcframework.zip",
        checksum: "90a0213c8b5ab2e5096604f75ba232d871fd1481cb697f3c910b35be0b0b8224"
    ),
    // .library(name: "SwiftParser", targets: ["SwiftParser"]),
    .binaryTarget(
        name: "SwiftParser",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftParser.framework.xcframework.zip",
        checksum: "d5d474c7d817315656b5336a53c83ec5be52ed0ee65b3b0b5d618feacb55abb5"
    ),
    // .library(name: "SwiftParserDiagnostics", targets: ["SwiftParserDiagnostics"]),
    .binaryTarget(
        name: "SwiftParserDiagnostics",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftParserDiagnostics.framework.xcframework.zip",
        checksum: "3fdfe2e2b3c5104d19875d5770bfddaf4fb8c351e0b798397f94291ea5faa992"
    ),
    // .library(name: "SwiftSyntax", targets: ["SwiftSyntax"]),
    .binaryTarget(
        name: "SwiftSyntax",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftSyntax.framework.xcframework.zip",
        checksum: "c659cced33e3bcd7656c16708db404e69f2f826ff6f2cd0ef5fb0c96a1f63955"
    ),
    // .library(name: "SwiftSyntax509", targets: ["SwiftSyntax509"]),
    .binaryTarget(
        name: "SwiftSyntax509",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftSyntax509.framework.xcframework.zip",
        checksum: "4418e6b81c420dfcd6eb85f4da8994ed140ce132889d995a55e4d62da8b852ac"
    ),
    // .library(name: "SwiftSyntaxBuilder", targets: ["SwiftSyntaxBuilder"]),
    .binaryTarget(
        name: "SwiftSyntaxBuilder",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftSyntaxBuilder.framework.xcframework.zip",
        checksum: "62989ed837d4288790d66bba4f086df7270ee3f312f233fcb3210dffa1a31672"
    ),
    // .library(name: "SwiftSyntaxMacroExpansion", targets: ["SwiftSyntaxMacroExpansion"]),
    .binaryTarget(
        name: "SwiftSyntaxMacroExpansion",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftSyntaxMacroExpansion.framework.xcframework.zip",
        checksum: "0265aebaa51a1aa17cddcb45a795738b0b02e4611d4c577261ce2a8fe8ec45da"
    ),
    // .library(name: "SwiftSyntaxMacros", targets: ["SwiftSyntaxMacros"]),
    .binaryTarget(
        name: "SwiftSyntaxMacros",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftSyntaxMacros.framework.xcframework.zip",
        checksum: "3975dec36f2cc6e78074561767a1ca127f03e3de5203e30f8f98f50c064c1bdd"
    ),
    // .library(name: "SwiftSyntaxMacrosTestSupport", targets: ["SwiftSyntaxMacrosTestSupport"]),
    .binaryTarget(
        name: "SwiftSyntaxMacrosTestSupport",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/SwiftSyntaxMacrosTestSupport.framework.xcframework.zip",
        checksum: "dcd78ad1553f53db6d9c02eeb55810a3c22ebea0fc1cd5bce1435235c1dd8c22"
    ),
    // .library(name: "_SwiftSyntaxTestSupport", targets: ["_SwiftSyntaxTestSupport"]),
    .binaryTarget(
        name: "_SwiftSyntaxTestSupport",
        url: "https://github.com/johnno1962/InstantSyntax/raw/main/509.1.1/_SwiftSyntaxTestSupport.framework.xcframework.zip",
        checksum: "afac9280454858656434be8076a823fe32b6452b3ea744d116464660e8f90d91"
    ),
  ]
)
