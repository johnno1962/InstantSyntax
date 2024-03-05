// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription
import Foundation

let tag = "510.0.0" // swift-syntax version
let zver = "1.10.1" // tag of zipped xcframeworks
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
        checksum: "feecc41dd0ab4248dbcffd80d6f43979a73896ef58cfd79c89cfedd1990f89c5"
    ),
    .binaryTarget(
        name: "SwiftCompilerPlugin",
        url: repo + "SwiftCompilerPlugin.xcframework.zip",
        checksum: "f2d8a5843c4507635ebbd5e33b2bbf9c93130ce80bf18c632545baefefb561ba"
    ),
    .binaryTarget(
        name: "SwiftCompilerPluginMessageHandling",
        url: repo + "SwiftCompilerPluginMessageHandling.xcframework.zip",
        checksum: "5ce9257cb0b725e9da7bfec896a0ecd77f931897bf67520be4538edb423bdeac"
    ),
    .binaryTarget(
        name: "SwiftDiagnostics",
        url: repo + "SwiftDiagnostics.xcframework.zip",
        checksum: "5e8b38c0c83143146bafebdca9396d6f7e9ebca9240fc0bfccb65e5385580304"
    ),
    .binaryTarget(
        name: "SwiftIDEUtils",
        url: repo + "SwiftIDEUtils.xcframework.zip",
        checksum: "adf4bf62fd9fa3433cb282c3a77ae27d9d4b3bf5abffb81762ec1c66b4e9ff2a"
    ),
    .binaryTarget(
        name: "SwiftOperators",
        url: repo + "SwiftOperators.xcframework.zip",
        checksum: "cbeccbcd67063d1508f35348f7177f610b8f3667604e90a5a2662eed8ed426a6"
    ),
    .binaryTarget(
        name: "SwiftParser",
        url: repo + "SwiftParser.xcframework.zip",
        checksum: "0269014e4cdb6fe480ab4c5ec62042ef6eb7f4aeb4c146f61823bd5f690a23f3"
    ),
    .binaryTarget(
        name: "SwiftParserDiagnostics",
        url: repo + "SwiftParserDiagnostics.xcframework.zip",
        checksum: "226c21d5ae5513b74892347f8821927c443007dae685811bd2f5c65f3d70e91c"
    ),
//    .binaryTarget(
//        name: "SwiftRefactor",
//        url: repo + "SwiftRefactor.xcframework.zip",
//        checksum: "d93d0be1efce0ca8fd5c699c52b507e4ebe336dc2fa54e5ccb66c05a1e79f0f0"
//    ),
    .binaryTarget(
        name: "SwiftSyntax",
        url: repo + "SwiftSyntax.xcframework.zip",
        checksum: "5f676be66fafbe710ad1e0f9ffaa958b9c1b5c5210888b5c63a4dd26a5f9c780"
    ),
    .binaryTarget(
        name: "SwiftSyntax509",
        url: repo + "SwiftSyntax509.xcframework.zip",
        checksum: "e306eab0f38f73f6e38f2acf88be03116f81f8fcfac5ff5ce8bb7ac297c6d9d7"
    ),
    .binaryTarget(
        name: "SwiftSyntaxBuilder",
        url: repo + "SwiftSyntaxBuilder.xcframework.zip",
        checksum: "dd7dee50ce64995714e47d0ef57960b708e8c68a1341f71379cb09327dd10f6a"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacroExpansion",
        url: repo + "SwiftSyntaxMacroExpansion.xcframework.zip",
        checksum: "6a248c115207f1b35518acbbc9adcebfa8e5301ab017fefec67f7567cbf7899f"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacros",
        url: repo + "SwiftSyntaxMacros.xcframework.zip",
        checksum: "c5244e8a0a26e73c254f27240b596d796d08ba2b355b3c50741bfc665c65cff5"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacrosTestSupport",
        url: repo + "SwiftSyntaxMacrosTestSupport.xcframework.zip",
        checksum: "918127925b2876d40db4e976299bbaea2dbb4f65f0b12e7cdc27cb50feb6135b"
    ),
    .binaryTarget(
        name: "_SwiftSyntaxTestSupport",
        url: repo + "_SwiftSyntaxTestSupport.xcframework.zip",
        checksum: "6112e6f801e17649a6c99132f50672ace803a4be303249bf40beb85d06995af8"
    ),
  ]
)
