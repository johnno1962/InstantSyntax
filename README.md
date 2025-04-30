 # InstantSyntax

### 610.0.1 binary frameworks for https://github.com/swiftlang/swift-syntax

Status 27/4/25: Rebuilt taking the above tag of the swift-syntax repo using 
Xcode 16.3 and seems to be working quite well using that Xcode. It can work 
with earlier versions particularly if you open the project in Xcode 16.3 first.

This is a Swift Package containing precompiled binary frameworks of the main 
modules of the [swift-syntax](https://github.com/swiftlang/swift-syntax) project.
It is intended this can be packaged up and used in place of the swit-syntax
source repo by Swift Macro projects to avoid [this problem people have
 experienced](https://forums.swift.org/t/compilation-extremely-slow-since-macros-adoption/67921/65) 
It operates by overriding the swift-syntax source repo pulled in by your macros 
by dragging it onto your project as you would to work on a Swift package as is
[documented here](https://developer.apple.com/documentation/xcode/editing-a-package-dependency-as-a-local-package).

### TL;DR

To use, build your project (and view any previews you would like to view),
then clone this repo, renaming the InstantSyntax directory to swift-syntax 
and unpack the compressed archives using a script exactly as follows:

```
git clone https://github.com/johnno1962/InstantSyntax -b statics --single-branch swift-syntax
```

Now, drag this `swift-syntax` clone onto the top level of your project 
that uses macros. This binary distribution should then take the place 
of the swift-syntax source repo in the side bar in all macro packages. 

If you still experience problems involving "duplicate copy commands being 
generated" when you try to build, try closing and reopening your project.

Use package_syntax.sh if you would like to rebuild from Apple's source.
A huge thanks to repo https://github.com/swift-precompiled/swift-syntax
which showed it was possible package static libraries in .xcframeworks.
