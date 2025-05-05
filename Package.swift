// swift-tools-version: 5.9

import CompilerPluginSupport
import PackageDescription

let tag = "601.0.1" // swift-syntax version
let modules: [(name: String, checksum: String, depends: [String])] = [
  ("SwiftBasicFormat", "9e6f37657824631983812b22dd6e9a55039d50ed058d11fe703213e94adac78c", ["SwiftSyntax509"]),
  ("SwiftCompilerPlugin", "41b2a7b772691120c1c15180dc325954475797669738be5a42f2d0cd399a11e7", ["SwiftCompilerPluginMessageHandling", "SwiftSyntaxMacroExpansion", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftBasicFormat", "SwiftOperators", "SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509", "SwiftSyntax510", "SwiftSyntax600", "SwiftSyntax601", "_SwiftSyntaxCShims"]),
  ("SwiftCompilerPluginMessageHandling", "c6a3bbbc7ff233317a946e36af233f3d6b4d3a76080c59f83079c90738545a1f", ["SwiftSyntaxMacroExpansion", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftBasicFormat", "SwiftOperators", "SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("_SwiftCompilerPluginMessageHandling", "15f7374c09c2b11bbb261a7472efb8c36c532c03275786243fbfa456d2dc77f5", ["SwiftSyntaxMacroExpansion", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftBasicFormat", "SwiftOperators", "SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftDiagnostics", "f31ec6da35e9a0f2255c5e7ee491b579b8fc67924af73631c5b57882097fe3fb", ["SwiftSyntax509"]),
  ("SwiftIDEUtils", "1a5e3c6c5d7306b6fd5f7a5ec5d8074b38315328d818ce52d84c1a04bf24d0fc", ["SwiftSyntax509"]),
  ("SwiftIfConfig", "9f2fea92e14b96f55352b754bbd7c1b277eb031eff6a91f58e0a2de3df0d7711", ["SwiftSyntax509"]),
  ("SwiftLexicalLookup", "26547de250aa632dc46566a4bd276e9cb3e3aa937c103e94e61b8a0bb057c2f0", ["SwiftSyntax509"]),
  ("SwiftOperators", "9d1a2ae8d02fc77790455a8c76b91d8638b684254eb87e258861ab2510e5cfd8", ["SwiftParser", "SwiftDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftParser", "c665b100eff5b90a0284921e9406b84600cfb0d3e0580738025ccb40792bed7d", ["SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftParserDiagnostics", "4c08b027a476618534346790e6435dee32ca2e301c80a6c6efd04de8625e88cd", ["SwiftParser", "SwiftDiagnostics", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftRefactor", "56abccafa57b973b78a86cac4a06139e679acd5506a879ba3ffae5eb70aea731", ["SwiftSyntax509"]),
  ("SwiftSyntax", "e789db7cd60b53655bcf325cf1aad6a7f114f6d613ee3eefc742c086de9c5a9c", ["SwiftSyntax509"]),
  ("SwiftSyntax509", "51a2fe16625b67d17e475ce10d3c6e44dc56d456c88a8c51b04426d9fd4eb0c0", []),
  ("SwiftSyntax510", "f73aeded8afe4377f57b5fc8b2745681445042da94af28d8d28b910df3d39dbd", []),
  ("SwiftSyntax600", "39c5d957a78b3d6b9b889ca6f8866c68cbaa15318a2a463b10f5446254b2e34b", []),
  ("SwiftSyntax601", "c199af3604abb570a732745b339f91b1ef22936f211a3298efda576e3d308f0e", []),
  ("SwiftSyntaxBuilder", "57184bcf175a3bd0c410cd3865f34f7e9d7c927cf8b5a2d618f3c6c6e5af4a75", ["SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacroExpansion", "1208e034b14bc187b8450b2ec9f6fcdbc3d83b7c94b82f42af4985bba2e9c4f5", ["SwiftOperators", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacros", "3cbd5e6e10ad4d991681ec3e99f780c5b45e178f5fffb4fb9da1c685e1e05dad", ["SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacrosTestSupport", "9385d02dfaefd9e86a674b29726a1a130c2fd58b02c6e56a54726f36cc118fe5", ["_SwiftSyntaxTestSupport", "SwiftSyntaxMacroExpansion", "SwiftOperators", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("SwiftSyntaxMacrosGenericTestSupport", "30a04fb409a7f7b7305559766ca75e40f6ceb307412e4ddb97e6b5da8c7ab43f", ["SwiftDiagnostics", "SwiftIDEUtils", "SwiftParser", "SwiftSyntaxMacros", "SwiftSyntaxMacroExpansion"]),
  ("_SwiftSyntaxCShims", "e5b612bd0143ea49a5bf8d1789839e8298b2046bd0c76cee70239ce09013c518", []),
  ("_SwiftSyntaxTestSupport", "a1b1b928088137f42e9608d08a602c0c59b47bf1061e12a2c02acb0c81c36653", ["SwiftSyntaxMacroExpansion", "SwiftOperators", "SwiftSyntaxMacros", "SwiftSyntaxBuilder", "SwiftParserDiagnostics", "SwiftDiagnostics", "SwiftParser", "SwiftBasicFormat", "SwiftSyntax", "SwiftSyntax509"]),
  ("_SwiftLibraryPluginProvider", "32a21d15da8352b62fb3f6326f2e29681a0f0a879d82167cddc93df24d325dd1", []),
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
