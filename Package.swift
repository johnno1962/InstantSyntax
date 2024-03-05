// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription
import Foundation

let tag = "510.0.0" // swift-syntax version
let zver = "1.10.0" // tag of zipped xcframeworks
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
  ("SwiftIDEUtils", ["SwiftSyntax509"]),
  ("SwiftOperators", ["SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftParser", ["SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftParserDiagnostics", ["SwiftParser", "SwiftDiagnostics", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftRefactor", ["SwiftSyntax509"]),
  ("SwiftSyntax", ["SwiftSyntax509"]),
  ("SwiftSyntax509", []),
  ("SwiftSyntaxBuilder", ["SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacroExpansion", ["SwiftOperators", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacros", ["SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacrosTestSupport", ["_SwiftSyntaxTestSupport", "SwiftSyntaxMacroExpansion", "SwiftOperators", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
//  ("_SwiftSyntaxTestSupport", ["SwiftSyntaxMacroExpansion", "SwiftOperators", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
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
        checksum: "43e6fa4e2771823ed13894ddc7373c36d17a924d0240ff5469fc653f43d4f135"
    ),
    .binaryTarget(
        name: "SwiftCompilerPlugin",
        url: repo + "SwiftCompilerPlugin.xcframework.zip",
        checksum: "c07bdbb3ae8597e5ce4acc91c541e99ef5b5ed930ab891441c198ac6e7d5a1a0"
    ),
    .binaryTarget(
        name: "SwiftCompilerPluginMessageHandling",
        url: repo + "SwiftCompilerPluginMessageHandling.xcframework.zip",
        checksum: "1ca85e74eede7cc46a04c1c6d54f9516278c331e85434c38c904492ad7cf7f4a"
    ),
    .binaryTarget(
        name: "SwiftDiagnostics",
        url: repo + "SwiftDiagnostics.xcframework.zip",
        checksum: "0ff801251d050baafafcf7f0816f3b10ab3f971832eb746b13f6337c264ed949"
    ),
    .binaryTarget(
        name: "SwiftIDEUtils",
        url: repo + "SwiftIDEUtils.xcframework.zip",
        checksum: "d134d706f6868d57e803715c971f145ff1c09af8266f186a5edf9d5b9aba2ea1"
    ),
    .binaryTarget(
        name: "SwiftOperators",
        url: repo + "SwiftOperators.xcframework.zip",
        checksum: "c0b123e85a18e3844cbe4e6a915b57eb519c4d77fa2ee6d4bb049baf4ebfb356"
    ),
    .binaryTarget(
        name: "SwiftParser",
        url: repo + "SwiftParser.xcframework.zip",
        checksum: "e23e44f15d62f40eaee95cf6b199b4ed27c20b1ace2115fbe953574b61524074"
    ),
    .binaryTarget(
        name: "SwiftParserDiagnostics",
        url: repo + "SwiftParserDiagnostics.xcframework.zip",
        checksum: "18283d2822c2ee58752d5622f887413ed958cf3240bc279e60de3187c544c14c"
    ),
    .binaryTarget(
        name: "SwiftRefactor",
        url: repo + "SwiftRefactor.xcframework.zip",
        checksum: "52f7169359dd843c9c0bf6ebe5d2cd50073c44587b2fc4c9bf7852eb405249b8"
    ),
    .binaryTarget(
        name: "SwiftSyntax",
        url: repo + "SwiftSyntax.xcframework.zip",
        checksum: "9ce32e1a79429afb8a24a644054b50afd5a8ac16ed51062f95bf23107948a33c"
    ),
    .binaryTarget(
        name: "SwiftSyntax509",
        url: repo + "SwiftSyntax509.xcframework.zip",
        checksum: "dca089c4b9d0aa71ccc2a3ab554072623729676c3816aceec507983b998c6832"
    ),
    .binaryTarget(
        name: "SwiftSyntaxBuilder",
        url: repo + "SwiftSyntaxBuilder.xcframework.zip",
        checksum: "fb723b7c6651121910060ad03a22c5aa42ac38da8293db8e74b4efbb06ef5b48"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacroExpansion",
        url: repo + "SwiftSyntaxMacroExpansion.xcframework.zip",
        checksum: "3301f5220654d1a2971b000fe5f44249a7df7ccb2263af4caa0dfc3fedbe7999"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacros",
        url: repo + "SwiftSyntaxMacros.xcframework.zip",
        checksum: "b7939816ef56a1cf7af784012decd35e7542ccb6cacea17b01892bb228b56021"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacrosTestSupport",
        url: repo + "SwiftSyntaxMacrosTestSupport.xcframework.zip",
        checksum: "dbc27df1184e165a37810a3e6c16c1645737bff0e0b70e8b738ac79b73418969"
    ),
  ]
)
