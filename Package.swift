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
      // linked versions from the SwiftSyntax library archive included in the repo.
      linkerSettings: [.unsafeFlags(["\(clone)\(tag)/libSwiftSyntax.a"] +
                                    modules.flatMap({ ["-weak_framework", $0] }))]
    ),
    .binaryTarget(
        name: "SwiftBasicFormat",
        url: repo + "SwiftBasicFormat.xcframework.zip",
        checksum: "cc70b82529c1a4cc4a9e302009dee3fabca30c4903203a485589d1922354a2a7"
    ),
    .binaryTarget(
        name: "SwiftCompilerPlugin",
        url: repo + "SwiftCompilerPlugin.xcframework.zip",
        checksum: "f6c775bf542e08f2ba1656d6ace1d04d41d0c2883c5eb4b074aa3356e24097c4"
    ),
    .binaryTarget(
        name: "SwiftCompilerPluginMessageHandling",
        url: repo + "SwiftCompilerPluginMessageHandling.xcframework.zip",
        checksum: "a1f917e2811438045def9da7ee9c0e2cd79cdce03126448222b018f544890f12"
    ),
    .binaryTarget(
        name: "SwiftDiagnostics",
        url: repo + "SwiftDiagnostics.xcframework.zip",
        checksum: "a9f83e2c19e2200867d3075db1c0cc9ad6b5852c1c794310f0d2f244a4175b10"
    ),
    .binaryTarget(
        name: "SwiftOperators",
        url: repo + "SwiftOperators.xcframework.zip",
        checksum: "971a8ab851a1b140b115a54dbb264c28adaa937a6083337f1c24ad9d3c6e9016"
    ),
    .binaryTarget(
        name: "SwiftParser",
        url: repo + "SwiftParser.xcframework.zip",
        checksum: "faf729fb329cb5e096bc3e51edc1b0aa9e3910b54fe9198c89ac0f19c6a50e22"
    ),
    .binaryTarget(
        name: "SwiftParserDiagnostics",
        url: repo + "SwiftParserDiagnostics.xcframework.zip",
        checksum: "9a77ef038d18025021afe381dc5783aa39d900d3df0650a0867c5c8dab1c6dd1"
    ),
    .binaryTarget(
        name: "SwiftSyntax",
        url: repo + "SwiftSyntax.xcframework.zip",
        checksum: "c2e131fbf091c9cbf67ea108a308b7a6270bf19ff51957495f725fad42fe9c5d"
    ),
    .binaryTarget(
        name: "SwiftSyntax509",
        url: repo + "SwiftSyntax509.xcframework.zip",
        checksum: "7ce1b875cbb467348dfdcd8a98a651a24abead751a70799be78afac1abae146d"
    ),
    .binaryTarget(
        name: "SwiftSyntaxBuilder",
        url: repo + "SwiftSyntaxBuilder.xcframework.zip",
        checksum: "9a7c30cc3275acebb9b5673559fd3ef00d67f4d2a8b062312797c2395b30d59a"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacroExpansion",
        url: repo + "SwiftSyntaxMacroExpansion.xcframework.zip",
        checksum: "e2dd86336fb082f1aad5ffccf35733b35158af2599e5896ce759f02cc44a43b6"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacros",
        url: repo + "SwiftSyntaxMacros.xcframework.zip",
        checksum: "14facad306d56bdb429c976511e8617e880ff028726de0e0432435d1c4134d3b"
    ),
    .binaryTarget(
        name: "SwiftSyntaxMacrosTestSupport",
        url: repo + "SwiftSyntaxMacrosTestSupport.xcframework.zip",
        checksum: "61ff4e014bde59825d2cbe080edda0d369007cd37d8cf3a847b5a57b8382f84b"
    ),
    .binaryTarget(
        name: "_SwiftSyntaxTestSupport",
        url: repo + "_SwiftSyntaxTestSupport.xcframework.zip",
        checksum: "94dcaf22c91e4d1aa37871b5f48e4f1b2a4c9bf26a03de3fd92279caf062acee"
    ),
  ]
)
