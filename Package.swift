// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let tag = "601.0.1" // swift-syntax version
let archive = "https://github.com/swift-precompiled/swift-syntax/releases/download/"+tag
let modules: [(name: String, checksum: String, depends: [String])] = [
  ("SwiftBasicFormat", "10db9c2ea6f695f3dd00ed6e0dbad3696f7eee281d4813b49888c8acca0589c1", ["SwiftSyntax509"]),
  ("SwiftCompilerPlugin", "67abbac29711a903c843bcaa74ac7d859497832b74d51e72980ee2d64fdf6de9", ["SwiftCompilerPluginMessageHandling", "SwiftSyntaxMacroExpansion", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftBasicFormat", "SwiftOperators", "SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509", "SwiftSyntax510", "SwiftSyntax600", "SwiftSyntax601", "_SwiftSyntaxCShims"]),
  ("SwiftCompilerPluginMessageHandling", "5bca868bd7bc7704b8f38e0a0a17ce829f2eefac6be0580380ac51a191cf23b5", ["SwiftSyntaxMacroExpansion", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftBasicFormat", "SwiftOperators", "SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftDiagnostics", "3c434e7e6092a25bf738a4fdcbc19c43a9aca8456b13f0331ad638a7abf9c225", ["SwiftSyntax509"]),
  ("SwiftIDEUtils", "04d41c581209643f6d3f524bdc3aa6604c160982bfe74d37eef7edd5f311cc9a", ["SwiftSyntax509"]),
  ("SwiftIfConfig", "12962000d8b34a5de05fc2ef083a919e548590d3cf992f32c8b622cc90a76791", ["SwiftSyntax509"]),
  ("SwiftLexicalLookup", "a18c4425960fd18d665b56a4bca9df65d501a65c578737cdd1a22a5ed2eb540b", ["SwiftSyntax509"]),
  ("SwiftOperators", "20161bb2cb1c5b51cdc23114a0f30f60daa898a73df03db1ff4d776d5fa2c687", ["SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftParser", "829b2ac2a55b0bf51a656b54ea2a9d5763216b618082d259f4bacd735c224773", ["SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftParserDiagnostics", "a6a35ec74bbf0c46daa1b1c757cbdf4d241ff368b520b5127f50d21aeb096ff0", ["SwiftParser", "SwiftDiagnostics", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftRefactor", "a776fd2af50d85620944f389fadf98abaf4df2c90a5e44a0dbecdcd661a63b02", ["SwiftSyntax509"]),
  ("SwiftSyntax", "750fc062f3f431e58f3afc0d1f664f51191f6f6c9982a4b6a949ddad1c970bc7", ["SwiftSyntax509"]),
  ("SwiftSyntax509", "c51863bb51cbc23f3c2faff5616346bf07235a5ac775f579dbfb4262409f7a31", []),
  ("SwiftSyntax510", "f0381cd6b0ca2a0340d8fe8a0ca8e557fd7214481f4058e212ac0252b631463f", []),
  ("SwiftSyntax600", "d47864c2898fc0c38fa770574a02c287b3125858771e0100b5f29378fef6dca4", []),
  ("SwiftSyntax601", "c00bc8c61b8e30167a7bc9e15023a2ad695c9decb1efdb2fb65b5cc4bc6c50ec", []),
  ("SwiftSyntaxBuilder", "ca7213037eebdc26d64f0db8ce6679a0be65fa39c492ceb6c3d0b79559734437", ["SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacroExpansion", "e230a8d4aae9ed9f4ff5ba1cfa94f72027ec9015daef951c16451945481a16a1", ["SwiftOperators", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacros", "37cd64e8ccb141a5ff860540107e51124cf0faf4435656588268f7593946e8ec", ["SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacrosTestSupport", "f8f7df797f6c3f389528d8c95389c06184ce0ee7a1bf2a865e2fbf3fc53d9de6", [/*"_SwiftSyntaxTestSupport", */"SwiftSyntaxMacroExpansion", "SwiftOperators", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("_SwiftSyntaxCShims", "631bc3cd7edb64840fb6727c010587e18c2178d3a1f6617d2a6329b762889ca9", []),
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
