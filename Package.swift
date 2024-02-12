// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription
import Foundation

let tag = "509.1.1" // swift-syntax version
let zver = "1.0.10" // tag of zipped xcframeworks
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
        checksum: "ebcd154c390a8d11cd1e9fd38fe99704974dea68bd5604256718573e171c19b8"
    ),
    .binaryTarget(
        name: "SwiftCompilerPlugin",
        url: repo + "SwiftCompilerPlugin.xcframework.zip",
        checksum: "18122c573ffbe5f138eb5e0f36bfbfe947339958c29c2531fe02fdaad42b1880"
    ),
    .binaryTarget(
        name: "SwiftCompilerPluginMessageHandling",
        url: repo + "SwiftCompilerPluginMessageHandling.xcframework.zip",
        checksum: "d724bee12fb72532e40dd407a3c377c432c0a049b5a536d23bddfcf892c91ddb"
    ),
    .binaryTarget(
        name: "SwiftDiagnostics",
        url: repo + "SwiftDiagnostics.xcframework.zip",
        checksum: "543cba4a8731e7ee4ba6c3b7de0c7c72978ec4ce987a81cfc8abd08bddfd85d0"
    ),
    .binaryTarget(
        name: "SwiftOperators",
        url: repo + "SwiftOperators.xcframework.zip",
        checksum: "ce74590333df72edad38d5b6284a0154511826451d6cb7a8a7f6b1cc7ceb6e99"
    ),
    .binaryTarget(
        name: "SwiftParser",
        url: repo + "SwiftParser.xcframework.zip",
        checksum: "93594ec7822b9b85f904d2dd2b5ef8d1488a4aaff8abb452f5f655ac8137d2da"
    ),
    .binaryTarget(
        name: "SwiftParserDiagnostics",
        url: repo + "SwiftParserDiagnostics.xcframework.zip",
        checksum: "5773a2e8eaf770039dd0805a9b596798c6b1a21c37f10e6c6bcedee508b316dd"
    ),
    .binaryTarget(
        name: "SwiftSyntax",
        url: repo + "SwiftSyntax.xcframework.zip",
        checksum: "abc7055c63134e14577dd5d1373c6b7370e33531a3c9511918fbabeb1d33d187"
    ),
    .binaryTarget(
        name: "SwiftSyntax509",
        url: repo + "SwiftSyntax509.xcframework.zip",
        checksum: "958021c72e1f8b9f730293d1742c411993ede1f9ca73da96ac4c3265537265bf"
    ),
    .binaryTarget(
        name: "SwiftSyntaxBuilder",
        url: repo + "SwiftSyntaxBuilder.xcframework.zip",
        checksum: "bc5a8551e19bb75603deebc2d4619dda0688c04571873ccf2140687f549cb4e7"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacroExpansion",
        url: repo + "SwiftSyntaxMacroExpansion.xcframework.zip",
        checksum: "19d376c15db0b0bc9cca51a377bf0abe463410ff98888d1804cdece12e0e1b21"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacros",
        url: repo + "SwiftSyntaxMacros.xcframework.zip",
        checksum: "b53779d45b3e68e0c427182217af9cca9e79f5652b7f1657048c40a67db536e6"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacrosTestSupport",
        url: repo + "SwiftSyntaxMacrosTestSupport.xcframework.zip",
        checksum: "0d86656c2d7ac43d101c2275d8c47651e24482bf4998ce8819705069b615ec35"
    ),
    .binaryTarget(
        name: "_SwiftSyntaxTestSupport",
        url: repo + "_SwiftSyntaxTestSupport.xcframework.zip",
        checksum: "81dbcbe39bf482f67fbfa530dba7080a61f557fa6ecd7d892d537ac41471153c"
    ),
  ]
)
