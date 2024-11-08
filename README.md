# InstantSyntax

509.1.1 SwiftSyntax binary frameworks (This package no longer works!)

This is a Swift Package containg precompiled binary frameworks of the main 
modules of the [swift-syntax](https://github.com/apple/swift-syntax) project.
It is hoped this can be packaged up and used in place of the swit-syntax
source repo by Swift Macro projects to avoid [this problem people have
 experienced](https://forums.swift.org/t/compilation-extremely-slow-since-macros-adoption/67921/59). 
 It operates by overriding the
swift-syntax source repo pulled in by your macros by dragging it 
onto your project as you would to work on a Swift package as is
[documented here](https://developer.apple.com/documentation/xcode/editing-a-package-dependency-as-a-local-package).

These were a bit involved for me to build. First, you need to use an old 
Xcode 13 version of "swift package generate-xcodeproj" to generate a 
swift-syntax.xcodeproj project file. Then, you can generate and package 
the binary frameworks using xcodebuild in the normal way. Where extra
security is imperitive (even though compiler plugins execute in a very
restrictive sandbox) there is a script in the repo that allows you to 
rebuild your own fork of this repo directly from the Apple sources 
which you can then clone and use instead.

### TL;DR

To use, build your project (and view any previews you would like 
to view), then clone this repo, renaming the InstantSyntax directory 
to swift-syntax and unpack the compressed archives using a script.

```
git clone https://github.com/johnno1962/InstantSyntax -b main --single-branch swift-syntax
./swift-syntax/509.1.1/unpack.sh
```

Now, drag this `swift-syntax` clone onto the top level of your project 
that uses macros. This binary distribution should then take the place 
of the swift-syntax source repo in the side bar in all macro packages. 
At the moment, if you perform a "Clean Build Folder" you'll need to 
un-add the swift-syntax override, rebuild your project then re-add it.

### If in doubt remove this package, build clean then re-add it.

If you change platform, for example, from simulator to device the same 
applies. Xcode Previews also count as another platform. You need to 
have used previewing for a platform before adding the binary clone 
for them to work when the binary override is in place. Switching
Xcode versions will also require you to remove, build and re-add
the override.

While this should be resoved now, if you see an error along the 
lines of `External macro implementation type 'XMacros.XMacro' 
could not be found for macro 'color'` in the source editor (even
when your project builds) this seems to be because some files are 
corupted in DerivedData that the binary package override is not 
providing in the right place. You will need to remove the binary
override, build clean then add it again.

If you still experience problems involving "duplicate copy commands
being generated" when you try to build, this is beacuse the repo's
Package.swift seems to tickle some sort of bug in the build system
related to binary frameworks and you won't be able to use the package.
