// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let tag = "601.0.1" // swift-syntax version
let archive = "https://github.com/swift-precompiled/swift-syntax/releases/download/"+tag
let modules: [(name: String, checksum: String, depends: [String])] = [
  ("SwiftBasicFormat", "2c498972cdb297a440b7c962cc05396fd4860d60de45d88e7fa7544e6c167077", ["SwiftSyntax509"]),
  ("SwiftCompilerPlugin", "5a51dbb55b212f66747bba8713b2178b0cab46b5d160a1d3f471209a6654e51f", ["SwiftCompilerPluginMessageHandling", "SwiftSyntaxMacroExpansion", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftBasicFormat", "SwiftOperators", "SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509", "SwiftSyntax510", "SwiftSyntax600", "SwiftSyntax601", /*"_SwiftSyntaxCShims"*/]),
  ("SwiftCompilerPluginMessageHandling", "ef395ccf6bbb18388a539a67ad94927c2a748d3b120dcc7cbfbb3e67a5cf3dc1", ["SwiftSyntaxMacroExpansion", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftBasicFormat", "SwiftOperators", "SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftDiagnostics", "0ca8f91e0c0b53905da9d82f2e69d01d2f6b48c252e1775730a74a3cd0354760", ["SwiftSyntax509"]),
  ("SwiftIDEUtils", "f4b1df344d77851b85a8c21310101e37779efb90bb3ae5d318f234496b25d4f4", ["SwiftSyntax509"]),
  ("SwiftIfConfig", "441f4f96f3e227a3730fb1036b3120b7ea1792fd0e59d65207fa204de175d445", ["SwiftSyntax509"]),
  ("SwiftLexicalLookup", "884acdaee11ac8121917f2d5544b898f2abed6396cf8dd596556a9457ebf319f", ["SwiftSyntax509"]),
  ("SwiftOperators", "5a7ee39f80141c0ca6ad5f6c1360d59bbe7ccef674f7b499f7c88c81b87f981d", ["SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftParser", "cb0217a1dbcb506490b7918cdf2114c731773201b469a336d9af1930613e7791", ["SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftParserDiagnostics", "f7f02971975d9d0ed4a4a38b57e221bf3d5fd4fdd71d9b38a21761b69df95d4a", ["SwiftParser", "SwiftDiagnostics", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftRefactor", "6fb5bbee91ac086def24a263bde594c215f6061fbc5aecad89ed0a7e669884b3", ["SwiftSyntax509"]),
  ("SwiftSyntax", "23a3bde9b8ecf5514e8fd813652b30be6f1ecc3542d398486b1c8fc2ff893b78", ["SwiftSyntax509"]),
  ("SwiftSyntax509", "623694ffbbf0db0f4449627922f1d2b362005068049261711eb35732bf770751", []),
  ("SwiftSyntax510", "286beafe90a8b5d1bf38d1bc81d99f8c0925f5df3fdb43b3ea27947ab37dadae", []),
  ("SwiftSyntax600", "9fe071ba080666feb341f4f22379bc70243e17664e13e12284516f836fd9bc19", []),
  ("SwiftSyntax601", "24c4e8357ef8d7891d86a12ef2c85b0399fa7c37a4c434b85f775b415582e2e3", []),
  ("SwiftSyntaxBuilder", "95101b35e0735fc839794fb601607c741c003c912420b7bf4b23dd81b1fa9e19", ["SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacroExpansion", "58629356b78b4486047f8efbba9dc05fd7174d8b01171078771628f0269959eb", ["SwiftOperators", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacros", "f12a8bd28801b45a07c2df8f0961bf791135af39b8ce8283e9cb9ad181c49fab", ["SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacrosTestSupport", "acbc76f207113bc8f887c265ab4dfb04b031c794088eb4eef09e7c0bde971332", [/*"_SwiftSyntaxTestSupport", */"SwiftSyntaxMacroExpansion", "SwiftOperators", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
//  ("_SwiftSyntaxCShims", "1c620be31b51590e9420668d13d45b197aad28c0a53d73dec30274c40cd4d993", []),
//  ("_SwiftSyntaxTestSupport", ["SwiftSyntaxMacroExpansion", "SwiftOperators", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
//  ("_SwiftCompilerPluginMessageHandling", []),
//  ("_SwiftLibraryPluginProvider", []),
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
      .library(name: $0.name, targets: [$0.name] + $0.depends
    ) },

  targets: modules.map {
      .binaryTarget(
          name: $0.name,
          path: tag + "/" + "\($0.name).xcframework.zip"
      )
  }
)
