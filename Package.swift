// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let tag = "601.0.1" // swift-syntax version
let modules: [(name: String, depends: [String])] = [
  ("SwiftBasicFormat", ["SwiftSyntax509"]),
  ("SwiftCompilerPlugin", ["SwiftCompilerPluginMessageHandling", "SwiftSyntaxMacroExpansion", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftBasicFormat", "SwiftOperators", "SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509", "SwiftSyntax510", "SwiftSyntax600", "SwiftSyntax601", "_SwiftSyntaxCShims"]),
  ("SwiftCompilerPluginMessageHandling", ["SwiftSyntaxMacroExpansion", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftBasicFormat", "SwiftOperators", "SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftDiagnostics", ["SwiftSyntax509"]),
  ("SwiftIDEUtils", ["SwiftSyntax509"]),
  ("SwiftIfConfig", ["SwiftSyntax509"]),
  ("SwiftLexicalLookup", ["SwiftSyntax509"]),
  ("SwiftOperators", ["SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftParser", ["SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftParserDiagnostics", ["SwiftParser", "SwiftDiagnostics", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftRefactor", ["SwiftSyntax509"]),
  ("SwiftSyntax", ["SwiftSyntax509"]),
  ("SwiftSyntax509", []),
  ("SwiftSyntax510", []),
  ("SwiftSyntax600", []),
  ("SwiftSyntax601", []),
  ("_SwiftSyntaxCShims", []),
  ("SwiftSyntaxBuilder", ["SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacroExpansion", ["SwiftOperators", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacros", ["SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacrosTestSupport", [/*"_SwiftSyntaxTestSupport", */"SwiftSyntaxMacroExpansion", "SwiftOperators", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
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
          path: tag + "/" + "\($0.name).xcframework"
      )
  }
)
