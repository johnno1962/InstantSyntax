# InstantSyntax

SwiftSyntax binary frameworks

This is a Swift Package containg precompiled binary frameworks of the main 
modules of the [swift-syntax](https://github.com/apple/swift-syntax) project.
It is hoped this can be packaged up and used by Swift Macro projects in
place of a direct dependency on that project's source. Something like:

```
    .package(name: "swift-syntax",
             url: "https://github.com/johnno1962/InstantSyntax", from: "1.0.5"),
```

These are a bit involved to build. First, you need to use an old Xcode 13 
version of "swift package generate-xcodeproj" to generate a .xcodeproj
for the swift-syntax project. Then, you can generate and package 
the binary frameworks using xcodebuild in the normal way. To make
sure all these modules are unpacked and available to a .macro target 
it should also have the product InstantSyntax as a dependency.

Current status is that everything seems to build but Macro implementations
won't load as there is a sandbox violation on trying to load the binary
frameworks which are unfortunately extracted into the wrong directory...
