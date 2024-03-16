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
        path: tag + "/" + "SwiftBasicFormat.xcframework.zip"
    ),
    .binaryTarget(
        name: "SwiftCompilerPlugin",
        path: tag + "/" + "SwiftCompilerPlugin.xcframework.zip"
    ),
    .binaryTarget(
        name: "SwiftCompilerPluginMessageHandling",
        path: tag + "/" + "SwiftCompilerPluginMessageHandling.xcframework.zip"
    ),
    .binaryTarget(
        name: "SwiftDiagnostics",
        path: tag + "/" + "SwiftDiagnostics.xcframework.zip"
    ),
    .binaryTarget(
        name: "SwiftOperators",
        path: tag + "/" + "SwiftOperators.xcframework.zip"
    ),
    .binaryTarget(
        name: "SwiftParser",
        path: tag + "/" + "SwiftParser.xcframework.zip"
    ),
    .binaryTarget(
        name: "SwiftParserDiagnostics",
        path: tag + "/" + "SwiftParserDiagnostics.xcframework.zip"
    ),
    .binaryTarget(
        name: "SwiftSyntax",
        path: tag + "/" + "SwiftSyntax.xcframework.zip"
    ),
    .binaryTarget(
        name: "SwiftSyntax509",
        path: tag + "/" + "SwiftSyntax509.xcframework.zip"
    ),
    .binaryTarget(
        name: "SwiftSyntaxBuilder",
        path: tag + "/" + "SwiftSyntaxBuilder.xcframework.zip"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacroExpansion",
        path: tag + "/" + "SwiftSyntaxMacroExpansion.xcframework.zip"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacros",
        path: tag + "/" + "SwiftSyntaxMacros.xcframework.zip"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacrosTestSupport",
        path: tag + "/" + "SwiftSyntaxMacrosTestSupport.xcframework.zip"
    ),
    .binaryTarget(
        name: "_SwiftSyntaxTestSupport",
        path: tag + "/" + "_SwiftSyntaxTestSupport.xcframework.zip"
    ),
  ]
)
